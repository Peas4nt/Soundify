import { sql } from "../../db.js";
import getTracksRefFunctions from "../utils/getTracksRefFunctions.js";

export const getPage = async (req, res) => {
	const [likes] = await sql`select
		u.user_key,
		coalesce(
			jsonb_object_agg(
						p.playlist_key, 
						jsonb_build_object(
								'image_path',  ${process.env.IMAGE_PATH} || p.image_path, 
								'tracks', p.tracks
						)
				) FILTER (WHERE p.playlist_key IS NOT NULL), 
				'{}'::jsonb )AS liked_playlists,
			u.liked_tracks 
			from users u
	left join playlists p ON p.playlist_key = any (SELECT jsonb_array_elements_text(u.liked_playlists)::int)
	where u.user_key = ${req.session.user.key}
	group by u.user_key, u.liked_tracks`;

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
		select p.playlist_key, p.name, p.slug,
		case when p.ref_data_func IS NOT NULL then ${process.env.DEFAULT_PATH} else ${process.env.IMAGE_PATH} end || p.image_path image_path, 
		0 is_your_playlist
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

	const [recentPlayedTrack] = await sql`
	select 
	t.playlist_slug, 
	t.fk_track_key track_key 
	from tracks_log t
	join playlists p on p.playlist_key = t.fk_playlist_key
	where t.fk_user_key = ${req.session.user.key}
	order by t.dt_created desc
	limit 1
	`;

	const [userData] = await sql`
	SELECT is_sidebar_closed, volume_value,  shuffle_value, repeat_value
	FROM users
	WHERE user_key = ${req.session.user.key};
	`;

	userData.is_sidebar_closed = !!userData.is_sidebar_closed;
	userData.shuffle_value = !!userData.shuffle_value;
	userData.repeat_value = !!userData.repeat_value;

	return res.render("common", {
		viewPath: "main",
		user: req.session.user,
		userData: JSON.stringify(userData),
		likedTracks: JSON.stringify(likedTracks),
		likedPlaylist: JSON.stringify(likedPlaylist),
		userPlaylists: JSON.stringify(userPlaylists),
		allUserPlaylistsStr: JSON.stringify(allUserPlaylists),
		allUserPlaylists,
		recentPlayedTrack,
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

		// getting system playlists
		const systemPlaylists = await sql`
		select
		playlist_key,
		name, 
		case when slug like '%\\_%' escape '\\' then slug || ${req.session.user.key} else slug end, 
		image_path,
		0 is_your_playlist
		from playlists 
		where ref_data_func is not null
		order by dt_created desc
		`;

		// getting user recent listened playlists
		const recentListenedPlaylists = await sql`
		WITH recent_tracks AS (
    SELECT DISTINCT ON (fk_playlist_key)
        fk_playlist_key,
        dt_created
    FROM tracks_log
    WHERE fk_user_key = ${req.session.user.key} ORDER BY fk_playlist_key, dt_created DESC
		)
		SELECT 
				p.playlist_key,
				p.name,
				CASE 
						WHEN p.slug LIKE '%\\_%' ESCAPE '\\' THEN p.slug || ${req.session.user.key}
						ELSE p.slug
				END AS slug,
				case when p.ref_data_func is null then ${process.env.IMAGE_PATH} || p.image_path else ${process.env.DEFAULT_PATH} || p.image_path end image_path,
				case when p.fk_user_keys = ${req.session.user.key} then 1 else 0 end is_your_playlist
		FROM playlists p
		JOIN (SELECT fk_playlist_key FROM recent_tracks ORDER BY dt_created desc LIMIT 10) t
		ON p.playlist_key = t.fk_playlist_key
		ORDER BY t.fk_playlist_key DESC
		`;

		// getting recent added playlists
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

		// getting most popular playlists
		const mostPopularPlaylists = await sql`
		with popular_playlists as (
			select
			p.playlist_key,
			p.name, 
			p.slug, 
			${process.env.IMAGE_PATH} || p.image_path image_path,
			case when p.fk_user_keys = ${req.session.user.key} then 1 else 0 end is_your_playlist,
			count(tl.tracks_log_key)
			from playlists p
			join tracks_log tl on tl.fk_playlist_key = p.playlist_key
			where ref_data_func is null
			and tl.dt_created > now() - interval  '30 days'
			group by p.playlist_key, p.name, p.slug, p.image_path, p.fk_user_keys
			limit 10
		)
		select * from popular_playlists order by count desc`;

		return await pageRender(res, "pages/main", {
			recentAddedPlaylists,
			systemPlaylists,
			recentListenedPlaylists,
			mostPopularPlaylists,
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

		const tracks = await sql`
		select t.track_key, t.fk_artist_key, a.name artist, t.name, t.listen_count, t.duration, t.dt_created,
		${process.env.TRACK_PATH} || t.track_path track_url,
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
		const [settings] =
			await sql`SELECT username, ${process.env.IMAGE_PATH} || image_path image_path, private_profile, private_liked_tracks, private_recent_track, private_show_my_playlits, private_show_recent_played_playlists 
		FROM users
		WHERE user_key=${req.session.user.key};`;

		settings.private_profile = !!settings.private_profile;
		settings.private_liked_tracks = !!settings.private_liked_tracks;
		settings.private_recent_track = !!settings.private_recent_track;
		settings.private_show_my_playlits = !!settings.private_show_my_playlits;
		settings.private_show_recent_played_playlists = !!settings.private_show_recent_played_playlists;

		return await pageRender(res, "pages/settings", { settings });
	},
	profile: async (req, res, slug) => {
		const isYourProfile = !slug;
		const key = isYourProfile ? req.session.user.key : parseInt(slug);
		
		const [profile] = await sql`SELECT user_key, username,${process.env.IMAGE_PATH} || image_path image_path, private_profile, private_liked_tracks, private_recent_track, private_show_my_playlits, private_show_recent_played_playlists FROM users WHERE user_key=${key};`;

		const [likedTracks] = await sql`
		select name, ${process.env.DEFAULT_PATH} || image_path image_path, slug || ${key} slug from playlists 
		where slug = 'likedtracks_'`;
		const [recentTracks] = await sql`
		select name, ${process.env.DEFAULT_PATH} || image_path image_path, slug || ${key} slug from playlists 
		where slug = 'recentlyplayed_'`;

		const myPlaylists = await sql`
		with popular_playlists as (
			select
			p.playlist_key,
			p.name, 
			p.slug, 
			${process.env.IMAGE_PATH} || p.image_path image_path,
			case when p.fk_user_keys = ${req.session.user.key} then 1 else 0 end is_your_playlist,
			count(tl.tracks_log_key)
			from playlists p
			join tracks_log tl on tl.fk_playlist_key = p.playlist_key
			where ref_data_func is null
			and p.fk_user_keys = ${key}
			and tl.dt_created >= now() - interval  '30 days'
			group by p.playlist_key, p.name, p.slug, p.image_path, p.fk_user_keys
			limit 10
		)
		select * from popular_playlists order by count desc`;

		const myRecentPlaylists = await sql`
		with popular_playlists as (
			select
			p.playlist_key,
			p.name, 
			p.slug, 
			${process.env.IMAGE_PATH} || p.image_path image_path,
			case when p.fk_user_keys = ${req.session.user.key} then 1 else 0 end is_your_playlist,
			count(tl.tracks_log_key)
			from playlists p
			join tracks_log tl on tl.fk_playlist_key = p.playlist_key
			where ref_data_func is null
			and tl.fk_user_key = ${key}
			and tl.dt_created >= now() - interval  '30 days'
			group by p.playlist_key, p.name, p.slug, p.image_path, p.fk_user_keys
			limit 10
		)
		select * from popular_playlists order by count desc`;


		return await pageRender(res, "pages/profile", {
			isYourProfile,
			profile,
			likedTracks,
			recentTracks,
			myPlaylists,
			myRecentPlaylists
		 });
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
