import { sql } from "../../db.js";
import geoip from "geoip-lite";

export const postLike = async (req, res) => {
	try {
		let { key } = req.body;
		key = parseInt(key);
		
		const [{ liked_tracks }] = await sql`select liked_tracks from users where user_key = ${req.session.user.key}`;

		if (liked_tracks.includes(key)) {
			const index = liked_tracks.indexOf(key);
			liked_tracks.splice(index, 1);
		} else {
			liked_tracks.push(key);
		}
	
		await sql`update users set liked_tracks = ${liked_tracks} where user_key = ${req.session.user.key}`;

		return res.status(200).send({ status: "OK", message: "Like status updated."});
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Track liking failed" });
	}
};

export const postGetTrack = async (req, res) => { 
	try {
		const clientIp = (process.env.DEV == 1)? "8.8.8.8" : req.headers["x-forwarded-for"];
		
		const geo = geoip.lookup(clientIp);
		
		let track_key = req.params.key;
		let playlist_key = req.body.playlist_key;

		track_key = parseInt(track_key);
		playlist_key = parseInt(playlist_key);

		const [track] = await sql`SELECT 
		t.name, a.name artist_name, a.artist_key, ${process.env.TRACK_PATH} || t.track_path track_path,
		case when t.image_path LIKE 'https%' then t.image_path
		else ${process.env.IMAGE_PATH} || t.image_path end image_path,
		case when t.fk_user_key = ${req.session.user.key} then 1 else 0 end is_your_track
		FROM tracks t
		join artists a on a.artist_key = t.fk_artist_key
		WHERE t.track_key=${track_key}`;

		await sql`UPDATE tracks SET listen_count=listen_count+1 where track_key = ${track_key}`;

		await sql`INSERT INTO 
		tracks_log (fk_user_key, fk_playlist_key, fk_track_key, country_code) 
		VALUES(${req.session.user.key}, ${playlist_key}, ${track_key}, ${geo.country});`

		return res.status(200).send({ status: "OK", data: track });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Track liking failed" });
	}
 }