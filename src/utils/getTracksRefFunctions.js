import { sql } from "../../db.js";

export default {
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
	myAddedTracks: async () => await sql``,
	myRecentPlayedTracks: async () => await sql``,
	top50Tracks: async () => await sql``,
	top50ContryTracks: async (countyCode) => await sql``,
	myOnReapeatTracks: async () => await sql``,
};

const getDataFromSlug = (slug) => slug.split("_")[1];

const arrayColumn = (array, columnKey) => array.map((item) => item[columnKey]);
