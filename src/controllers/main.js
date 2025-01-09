import { sql } from "../../db.js";
import getTracksRefFunctions from "../utils/getTracksRefFunctions.js";

export const getPage = async (req, res) => {
	const [likes] = await sql`select
		u.user_key,
		jsonb_object_agg(
					p.playlist_key, 
					jsonb_build_object(
							'image_path', ${process.env.IMAGE_PATH} || p.image_path, 
							'tracks', p.tracks
					)
			) AS liked_playlists,
			u.liked_tracks 
			from users u
	join playlists p ON p.playlist_key = any (SELECT jsonb_array_elements_text(u.liked_playlists)::int)
	where user_key = ${req.session.user.key}
	group by u.user_key, u.liked_tracks `;

	const likedTracks = likes?.liked_tracks ?? [];
	const likedPlaylist = likes?.liked_playlists ?? [];

	const userPlaylists = await sql`select playlist_key, name, tracks, ${process.env.IMAGE_PATH} || image_path image_path 
	from playlists
	where fk_user_keys = ${req.session.user.key}
	order by dt_created desc`;

	const allUserPlaylists = await sql`
	with owned_playlists as (
		select playlist_key, name, slug, ${process.env.IMAGE_PATH} || image_path image_path, 1 is_your_playlist
		from playlists 
		where fk_user_keys = ${req.session.user.key}
	),
	liked_playlists as (
		select p.playlist_key, p.name, p.slug, ${process.env.IMAGE_PATH} || p.image_path image_path, 0 is_your_playlist
		from playlists p
		join users u on u.user_key = ${req.session.user.key}
		where p.playlist_key = any (SELECT jsonb_array_elements_text(u.liked_playlists)::int)
	),
	result as (
		select * from 
		owned_playlists 
		union
		select * from 
		liked_playlists
	)
	select *
	from result
	order by is_your_playlist desc`;

	return res.render("common", {
		viewPath: "main",
		user: req.session.user,
		likedTracks: JSON.stringify(likedTracks),
		likedPlaylist: JSON.stringify(likedPlaylist),
		userPlaylists: JSON.stringify(userPlaylists),
		allUserPlaylistsStr: JSON.stringify(allUserPlaylists),
		allUserPlaylists,
	});
};

// page render function return a html with rendered content
const pageRender = (res, path, obj) => {
	return new Promise((resolve, reject) => {
		res.render(path, obj, (err, html) => {
			if (err) reject(err);
			else resolve({ template: html });
		});
	});
};

// page functions
const getPageHTML = {
	main: async (req, res, slug) => {
		if (slug) return { template: "page not exists" };

		const recentAddedPlaylists = await sql`
		select
		playlist_key,
		name, 
		slug, 
		image_path,
		case when fk_user_keys = ${req.session.user.key} then 1 else 0 end is_your_playlist
		from playlists 
		where private_all_see = 1 and ref_data_func IS NULL
		order by dt_created desc
		limit 10`;

		return await pageRender(res, "pages/main", {
			recentAddedPlaylists,
		});
	},
	playlist: async (req, res, slug) => {
		if (!slug) return await getPageHTML.error(req, res, slug);
		console.log("Load playlist: " + slug.split("_")[0]);

		const [playlist] = await sql`select p.slug, p.name, p.description, u.username, u.user_key, 
		case when ref_data_func IS NOT NULL then ${process.env.DEFAULT_PATH} else ${process.env.IMAGE_PATH} end || p.image_path image_path, 
		ref_data_func, tracks
		from playlists p
		left join users u on p.fk_user_keys = u.user_key
		where 
    p.slug = ${slug}
    or (
        ref_data_func IS NOT NULL 
        AND p.slug LIKE ${slug.split("_")[0] + "%"}
    );
		`;

		if (!playlist) return await getPageHTML.error(req, res, slug);

		let tracksKey = [];
		console.log(playlist.ref_data_func);

		if (playlist.ref_data_func) {
			if (typeof getTracksRefFunctions[playlist.ref_data_func] === "function") {
				tracksKey = await getTracksRefFunctions[playlist.ref_data_func](req, slug);
				playlist.slug = slug;
			} else return await getPageHTML.error(req, res, slug);
		} else {
			playlist.tracks.reverse();
			tracksKey = playlist.tracks;
		}

		if (tracksKey.length == 0) return await getPageHTML.error(req, res, slug);

		const tracks = await sql`
		select t.track_key, t.fk_artist_key, a.name artist, t.name, t.listen_count, t.duration, t.dt_created,
		case when t.image_path LIKE 'https%' then t.image_path
		else ${process.env.IMAGE_PATH} || t.image_path end image_path,
		case when t.fk_user_key = ${req.session.user.key} then 1 else 0 end is_your_track
		from tracks t
		join artists a on a.artist_key = t.fk_artist_key
		where t.track_key = any(${tracksKey})
		ORDER BY ARRAY_POSITION(${tracksKey}, t.track_key);`;

		return await pageRender(res, "pages/playlist", {
			playlist,
			tracks,
		});
	},
	settings: async (req, res, slug) => {
		return await pageRender(res, "pages/settings", { data: "settings" });
	},
	profile: async (req, res, slug) => {
		return await pageRender(res, "pages/profile", { data: "profile" });
	},
	uploadtrack: async (req, res, slug) => {
		return await pageRender(res, "pages/uploadtrack", { data: "uploadtrack" });
	},
	error: async (req, res, slug) => {
		return await pageRender(res, "pages/error", { data: "Error 404 this page doesn't exist" });
	},
};

export const getTemplate = async (req, res) => {
	const page = req.params.page ?? "main";
	const slug = req.params.slug;

	console.log("page: ", page, " ", slug);

	let data = {};

	try {
		if (typeof getPageHTML[page] === "function") {
			data = await getPageHTML[page](req, res, slug);
		} else {
			data = await getPageHTML["error"](req, res, slug);
		}
		return res.status(200).send({ data: data.template });
	} catch (err) {
		console.error("Error rendering page:", err);
		return await getPageHTML["error"](req, res, slug);
	}
};
