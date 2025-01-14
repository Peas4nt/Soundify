import path from "path";
import { sql } from "../../db.js";
import getTracksRefFunctions from "../utils/getTracksRefFunctions.js";
import { validationResult } from "express-validator";
import { fileURLToPath } from "url";
import fs from "fs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// playlist creation and editing
export const postData = async (req, res) => {
	try {
		const fileName = req.file?.filename ?? "";
		const { name, description } = req.body;

		// validate playlist
		const errors = validationResult(req);
		if (!errors.isEmpty()) {
			const errorsMsg = errors
				.array()
				.map((e) => e.msg)
				.join(" <br/>");

			if (fileName) {
				const filePath = path.join(__dirname, "../", "../", process.env.IMAGE_FOLDER_PATH, fileName);

				fs.unlink(filePath, (err) => {
					if (err) {
						console.error(`Error deleting file ${filePath}:`, err);
					} else {
						console.log(`File ${filePath} deleted successfully.`);
					}
				});
			}

			return res.status(200).send({ status: "ERROR", message: errorsMsg });
		}

		// validate slug
		const slug = makeSlug(name);
		const checkSlugUniqueness = await sql`select 1 from playlists where slug = ${slug}`;
		if (checkSlugUniqueness.length > 0) return res.status(200).send({ status: "ERROR", message: "This name is already in use please choose another name" });

		const [{ playlist_key }] =
			await sql`insert into playlists (name, description, image_path, slug, fk_user_keys) values (${name}, ${description}, ${fileName}, ${slug}, ${req.session.user.key}) returning playlist_key`;

		const [playlist] = await sql`select
			playlist_key, name,
			case when ref_data_func is null then ${process.env.IMAGE_PATH} || image_path else ${process.env.DEFAULT_PATH} || image_path end image_path,
			tracks, slug
			from playlists
			where playlist_key = ${playlist_key}`;

		return res.status(200).send({ status: "SUCCESSFUL", message: "Playlist created.", data: playlist });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Playlist creation failed, try later." });
	}
};

function makeSlug(title) {
	return title
		.toLowerCase()
		.trim()
		.replace(/[\s\-_]+/g, "-")
		.replace(/[^\w\-]+/g, "")
		.replace(/^-+|-+$/g, "");
}

export const putData = async (req, res) => {
	try {
		let fileName = req.file?.filename ?? "";
		let { key, name, description, private_all_see } = req.body;
		key = parseInt(key);

		// validate playlist
		const errors = validationResult(req);
		if (!errors.isEmpty()) {
			const errorsMsg = errors
				.array()
				.map((e) => e.msg)
				.join(" <br/>");

			if (fileName) {
				const filePath = path.join(__dirname, "../", "../", process.env.IMAGE_FOLDER_PATH, fileName);

				fs.unlink(filePath, (err) => {
					if (err) {
						console.error(`Error deleting file ${filePath}:`, err);
					} else {
						console.log(`File ${filePath} deleted successfully.`);
					}
				});
			}
			
			return res.status(200).send({ status: "ERROR", message: errorsMsg });
		}

		// validate slug
		const slug = makeSlug(name);
		const checkSlugUniqueness = await sql`select 1 from playlists where slug = ${slug} and playlist_key != ${key}`;
		if (checkSlugUniqueness.length > 0) return res.status(200).send({ status: "ERROR", message: "This name is already in use please choose another name" });

		// get playlist old data
		const [{ image_path }] = await sql`
		SELECT 
		image_path
		FROM playlists 
		WHERE playlist_key = ${key}`;

		if (fileName) {
			if (image_path) {
				const filePath = path.join(__dirname, "../", "../", process.env.IMAGE_FOLDER_PATH, image_path);

				fs.unlink(filePath, (err) => {
					if (err) {
						console.error(`Error deleting file ${filePath}:`, err);
					} else {
						console.log(`File ${filePath} deleted successfully.`);
					}
				});
			}
		} else fileName = image_path;

		await sql`
			UPDATE playlists 
			SET name = ${name},
				description = ${description},
				private_all_see = ${private_all_see ? 1 : 0},
				dt_modified = now(),
				slug = ${slug},
				image_path = ${fileName}
			WHERE playlist_key = ${key};`;

		const [playlist] = await sql`select name, description, ${process.env.IMAGE_PATH} || image_path image_path, slug from playlists where playlist_key = ${key}`;

		return res.status(200).send({ status: "SUCCESSFUL", message: "Playlist edited.", data: playlist });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Playlist editing failed, try later." });
	}
};

export const deleteData = async (req, res) => {
	try {
		let { key } = req.body;
		key = parseInt(key);

		console.log("Delete playlist: ", key);

		await sql`DELETE FROM playlists WHERE playlist_key= ${key};`;

		res.status(200).send({ status: "SUCCESSFUL", message: "Playlist deleted" });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Playlist deletion failed, try later." });
	}
};

export const postLike = async (req, res) => {
	try {
		let { key } = req.body;
		key = parseInt(key);

		const [{ liked_playlists }] = await sql`select liked_playlists from users where user_key = ${req.session.user.key}`;

		if (liked_playlists.includes(key)) {
			const index = liked_playlists.indexOf(key);
			liked_playlists.splice(index, 1);
		} else {
			liked_playlists.push(key);
		}

		await sql`update users set liked_playlists = ${liked_playlists} where user_key = ${req.session.user.key}`;

		const [playlist] = await sql`select playlist_key, name, ${process.env.IMAGE_PATH} || image_path image_path, tracks, slug from playlists where playlist_key = ${key}`;

		return res.status(200).send({ status: "OK", message: "Like status updated.", data: playlist });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Playlist liking failed" });
	}
};

export const postAddTrackToPlaylists = async (req, res) => {
	try {
		let { track_key, playlist_key } = req.body;
		track_key = parseInt(track_key);

		const [{ tracks }] = await sql`select tracks from playlists where playlist_key = ${playlist_key}`;

		if (tracks.includes(track_key)) {
			const index = tracks.indexOf(track_key);
			tracks.splice(index, 1);
		} else {
			tracks.push(track_key);
		}

		await sql`update playlists set tracks = ${tracks} where playlist_key = ${playlist_key}`;

		return res.status(200).send({ status: "OK", message: "Playlist tracks status updated." });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Track adding fail" });
	}
};

export const postGetPlaylistTracks = async (req, res) => {
	try {
		let slug = req.params.slug;

		const [playlist] = await sql`
		SELECT 
		playlist_key, name, slug, tracks, ref_data_func
		FROM playlists 
		WHERE slug=${slug}
		or (
			ref_data_func IS NOT NULL 
			AND slug LIKE ${slug.split("_")[0] + "%"}
		);`;

		if (playlist.ref_data_func) {
			if (typeof getTracksRefFunctions[playlist.ref_data_func] === "function") {
				playlist.tracks = await getTracksRefFunctions[playlist.ref_data_func](req, slug);
				playlist.slug = slug;
			} else return res.status(400).send({ status: "ERROR", message: "Playlist getting error" });
		} else {
			playlist.tracks.reverse();
		}

		return res.status(200).send({ status: "OK", data: playlist });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Playlist getting error" });
	}
};

export const postGetPlaylist = async (req, res) => {
	try {
		let { key } = req.body;
		key = parseInt(key);

		const [playlist] = await sql`
		SELECT 
		playlist_key, name, description, ${process.env.IMAGE_PATH} || image_path image_path, private_all_see
		FROM playlists 
		WHERE playlist_key = ${key}`;

		return res.status(200).send({ status: "OK", data: playlist });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Playlist getting error" });
	}
};
