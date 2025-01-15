import fs from "fs";
import { Shazam } from "node-shazam";
import SoundCloud from "soundcloud-scraper";
import { parseFile } from "music-metadata";
import dotenv from "dotenv";
import { sql } from "../../db.js";
import path from "path";
import { fileURLToPath } from "url";
import { validationResult } from "express-validator";

const shazam = new Shazam();
dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let corrupted = false;

export const postCheckTrack = async (req, res) => {
	const filePath = req.file.path;
	try {
		const recognise = await shazam.recognise(filePath, "en-US");

		fs.unlink(filePath, (err) => {
			if (err) {
				console.error(`Error deleting file ${filePath}:`, err);
			} else {
				console.log(`File ${filePath} deleted successfully.`);
			}
		});

		if (recognise) {
			const track = {
				name: recognise.track.title,
				artist: recognise.track.subtitle,
				image: recognise.track.images.background,
			};

			const check = await sql`select 1
			from tracks t 
			join artists a on a.artist_key = t.fk_artist_key
			where t.name || '-' || a.name = ${track.name + "-" + track.artist}`;

			if (check.length > 0) return res.status(200).send({ status: "ERROR", trackStatus: "FOUND", message: "This track already exists in our database. Please try uploading a different one." });

			return res.status(200).send({ status: "SUCCESSFUL", trackStatus: "FOUND", track });
		}

		return res.status(200).send({ status: "SUCCESSFUL", trackStatus: "NOTFOUND" });
	} catch (error) {
		fs.unlink(filePath, (err) => {
			if (err) {
				console.error(`Error deleting file ${filePath}:`, err);
			} else {
				console.log(`File ${filePath} deleted successfully.`);
			}
		});

		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Track check failed" });
	}
};

export const postTrackUpload = async (req, res) => {
	try {
		let trackFile = req.files.track ? req.files.track[0] : null;
		let imageFile = req.files.image ? req.files.image[0] : null;
		const trackName = req.body.name;
		const trackArtist = req.body.artist ?? req.session.user.username;
		const isUserAuthor = !!req.body.artist;

		// validate data
		const errors = validationResult(req);
		if (!errors.isEmpty()) {
			// delete track file
			if (trackFile) {
				const filePath = path.join(trackFile.path);

				fs.unlink(filePath, (err) => {
					if (err) {
						console.error(`Error deleting file ${filePath}:`, err);
					} else {
						console.log(`File ${filePath} deleted successfully.`);
					}
				});
			}

			// delete image file
			if (imageFile) {
				const filePath = path.join(imageFile.path);

				fs.unlink(filePath, (err) => {
					if (err) {
						console.error(`Error deleting file ${filePath}:`, err);
					} else {
						console.log(`File ${filePath} deleted successfully.`);
					}
				});
			}

			// get error messages
			const errorsMsg = errors
				.array()
				.map((e) => e.msg)
				.join(" <br/>");

			return res.status(200).send({ status: "ERROR", message: errorsMsg });
		}

		let imageFullName = "";
		// check if file exists
		if (imageFile == null) {
			imageFullName = req.body.image;
		} else {
			// rename image file
			const fileExt = imageFile.path.split(".")[1];
			imageFullName = `${trackArtist.toLowerCase()}-${trackName.toLowerCase()}.image.${fileExt}`.replace(/ /g, "_");
			const imageFilePath = `${process.env.IMAGE_FOLDER_PATH}/${imageFullName}`;
			fs.renameSync(imageFile.path, imageFilePath);
		}

		// rename track file
		const trackFullName = `${trackArtist.toLowerCase()}-${trackName.toLowerCase()}.mp3`.replace(/ /g, "_");
		const trackFilePath = path.join(__dirname, "../../" + process.env.TRACK_FOLDER_PATH, trackFullName);
		if (imageFile == null) {
			const newTrackFile = await getTrackFromSoundCloud(trackName, trackArtist);

			if (newTrackFile == null) corrupted = true;
		} else corrupted = true;

		// rename user track file if it soundcloud file corrupted
		// else delete user track if all ok
		if (corrupted) {
			fs.renameSync(trackFile.path, trackFilePath);
		} else {
			fs.unlink(trackFile.path, (err) => {
				if (err) {
					console.error(`Error deleting file ${trackFile.path}:`, err);
				} else {
					console.log(`File ${trackFile.path} deleted successfully.`);
				}
			});
		}

		// get track duration (1:00)
		const trackDuration = await getTrackDuration(trackFilePath);

		const trackArtistKey = await getArtistKey(trackArtist, req.session.user, isUserAuthor);

		await sql`insert into 
		tracks(name, fk_artist_key, fk_user_key, duration, image_path, track_path, listen_count)
		values(${trackName}, ${trackArtistKey}, ${req.session.user.key}, ${trackDuration}, ${imageFullName}, ${trackFullName}, 0)`;

		return res.status(200).send({ status: "SUCCESSFUL", message: "Track upload successfully" });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Track upload failed" });
	}
};

// upload track from soundcloud
async function getTrackFromSoundCloud(trackName, trackArtist) {
	const soundcloudApiKey = process.env.SOUNDCLOUND_API_KEY;

	const client = new SoundCloud.Client(soundcloudApiKey);
	// get search result from soundcloud
	console.log(trackName + " - " + trackArtist);
	
	const result = await client.search(trackName + " - " + trackArtist, "all");
	
	console.log(result);
	
	if (result.length == 0) return null;
	// get song info from soundcloud
	const song = await client.getSongInfo(result[0].url);

	// download track from soundcloud
	const stream = await song.downloadProgressive();

	// rename track
	const trackFileName = `${trackArtist.toLowerCase()}-${trackName.toLowerCase()}.mp3`.replace(/ /g, "_");
	const trackFilePath = path.join(__dirname, "../../" + process.env.TRACK_FOLDER_PATH, trackFileName);
	const writer = stream.pipe(fs.createWriteStream(trackFilePath, { encoding: "binary" }));
	await new Promise((resolve, reject) => {
		writer.on("finish", () => {
			console.log("File successfully written: ", trackFilePath);

			const stats = fs.statSync(trackFilePath);
			if (stats.size < 500 * 1024) {
				console.log("Downloaded file is too small, possibly corrupted.");
				corrupted = true;

				// delete file if it corrupted
				fs.unlink(trackFilePath, (err) => {
					if (err) {
						console.error(`Error deleting file ${trackFilePath}:`, err);
					} else {
						console.log(`File ${trackFilePath} deleted successfully.`);
					}
				});

				resolve();
			} else {
				console.log("File written successfully:", trackFilePath);
				resolve();
			}
		});
		writer.on("error", (err) => {
			console.error("File write error:", err);
			reject(new Error("Download error"));
		});
	});

	return trackFileName;
}

// function from trackPath get the track duration
function getTrackDuration(filePath) {
	return new Promise((resolve, reject) => {
		parseFile(filePath)
			.then((metadata) => {
				const durationInSeconds = metadata.format.duration;
				if (!durationInSeconds) {
					return reject("Unable to retrieve duration from file metadata.");
				}
				const minutes = Math.floor(durationInSeconds / 60);
				const seconds = Math.floor(durationInSeconds % 60);
				resolve(`${minutes}:${seconds.toString().padStart(2, "0")}`);
			})
			.catch((err) => {
				reject(`Error retrieving metadata: ${err.message}`);
			});
	});
}

async function getArtistKey(artistName, user, isUserAuthor) {
	const [artist] = await sql`select artist_key from artists where name = ${artistName}`;

	if (artist) {
		return artist.artist_key;
	}

	// TODO add author image
	// TODO auto creating artist playlist
	const [newArtist] = await sql`insert into artists (name, fk_user_key, is_user) values (${artistName}, ${user.key}, ${isUserAuthor? 1 : 0}) returning artist_key`;

	return newArtist.artist_key;
}
