import { sql } from "../../db.js";

export default {
	// return user liked tracks
	likedTracks: async (req, slug) => {
		let data = getDataFromSlug(slug);
		console.log(slug.split("_"));
		if (data == "") return [];

		data = parseInt(data);

		const result = await sql`
			select liked_tracks from users where user_key = ${data}
    `;

		if (result.length == 0) return [];

		const [{ liked_tracks }] = result;
		liked_tracks.reverse();

		return liked_tracks;
	},
	// return user uploaded tracks
	myTracks: async (req, slug) => {

		const [{ track_keys }] = await sql`
		with user_tracks as (
			select track_key from tracks where fk_user_key = ${req.session.user.key}
			order by dt_created desc
		)
		select json_agg (track_key) AS track_keys from user_tracks
		`;

		return track_keys;
	},
	// return user recently listed tracks
	recentlyPlayed: async (req, slug) => {
		let data = getDataFromSlug(slug);
		console.log(slug.split("_"));
		if (data == "") return [];

		data = parseInt(data);

		const [{ track_keys }] = await sql`
		with recent_tracks as (
			select distinct on (fk_track_key) fk_track_key, dt_created
			from tracks_log
			where fk_user_key = ${data}
			order by fk_track_key, dt_created desc
		),
		tracks_arr as (
			select distinct * from recent_tracks order by dt_created desc limit 50
		)
		select json_agg(fk_track_key) track_keys from tracks_arr
		`;

		return track_keys;
	},
	recentlyAdded: async (req, slug) => {
		const [{ track_keys }] = await sql`
		with track_keys as ( 
			select track_key 
			from tracks
			order by dt_created desc
			limit 50
		)
		select json_agg(track_key) track_keys from track_keys
		`;

		return track_keys;
	},
	top50Tracks: async () => await sql``,
	top50ContryTracks: async (countyCode) => await sql``,
	myOnReapeatTracks: async () => await sql``,
};

const getDataFromSlug = (slug) => slug.split("_")[1];

const arrayColumn = (array, columnKey) => array.map((item) => item[columnKey]);
