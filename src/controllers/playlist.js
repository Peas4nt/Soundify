import { sql } from "../../db.js";
import getTracksRefFunctions from "../utils/getTracksRefFunctions.js";

// playlist creation
export const postData = async (req, res) => {
	try {
		const fileName = req.file?.filename ?? "";
		const { name, description } = req.body;

		const slug = makeSlug(name);
		// TODO check slug uniqueness

		const data = await sql`insert into playlists (name, description, image_path, slug, fk_user_keys) values (${name}, ${description}, ${fileName}, ${slug}, ${req.session.user.key})`;

		return res.status(200).send({ status: "SUCCESSFUL", message: "Playlist created." });
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
function checkSlugInDB() {}
// TODO playlist editing
// TODO playlist deletion

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
		// TODO add playlist owner check

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
