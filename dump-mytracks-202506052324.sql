--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)
-- Dumped by pg_dump version 16.9

-- Started on 2025-06-05 23:24:45

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.tracks DROP CONSTRAINT tracks_pkey;
ALTER TABLE ONLY public.tracks_log DROP CONSTRAINT tracks_log_pkey;
ALTER TABLE ONLY public.playlists DROP CONSTRAINT playlists_pkey;
ALTER TABLE ONLY public.logs DROP CONSTRAINT logs_pkey;
ALTER TABLE ONLY public.artists DROP CONSTRAINT artists_pkey;
ALTER TABLE public.users ALTER COLUMN user_key DROP DEFAULT;
ALTER TABLE public.tracks_log ALTER COLUMN tracks_log_key DROP DEFAULT;
ALTER TABLE public.tracks ALTER COLUMN track_key DROP DEFAULT;
ALTER TABLE public.playlists ALTER COLUMN playlist_key DROP DEFAULT;
ALTER TABLE public.logs ALTER COLUMN log_key DROP DEFAULT;
ALTER TABLE public.artists ALTER COLUMN artist_key DROP DEFAULT;
DROP SEQUENCE public.users_user_key_seq;
DROP TABLE public.users;
DROP SEQUENCE public.tracks_track_key_seq;
DROP SEQUENCE public.tracks_log_tracks_log_key_seq;
DROP TABLE public.tracks_log;
DROP TABLE public.tracks;
DROP SEQUENCE public.playlists_playlist_key_seq;
DROP TABLE public.playlists;
DROP SEQUENCE public.logs_log_key_seq;
DROP TABLE public.logs;
DROP SEQUENCE public.artists_artist_key_seq;
DROP TABLE public.artists;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16399)
-- Name: artists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artists (
    artist_key integer NOT NULL,
    fk_user_key bigint NOT NULL,
    name character varying(255) NOT NULL,
    image_path character varying(255),
    dt_created timestamp without time zone DEFAULT now() NOT NULL,
    dt_modified timestamp without time zone DEFAULT now() NOT NULL,
    is_user smallint DEFAULT 0 NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 16398)
-- Name: artists_artist_key_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.artists_artist_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3475 (class 0 OID 0)
-- Dependencies: 217
-- Name: artists_artist_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.artists_artist_key_seq OWNED BY public.artists.artist_key;


--
-- TOC entry 222 (class 1259 OID 16417)
-- Name: logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.logs (
    log_key integer NOT NULL,
    code character varying(255) NOT NULL,
    text text NOT NULL,
    fk_user_key bigint NOT NULL,
    iserror smallint NOT NULL,
    dt_created date NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16416)
-- Name: logs_log_key_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.logs_log_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3476 (class 0 OID 0)
-- Dependencies: 221
-- Name: logs_log_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.logs_log_key_seq OWNED BY public.logs.log_key;


--
-- TOC entry 220 (class 1259 OID 16408)
-- Name: playlists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playlists (
    playlist_key integer NOT NULL,
    name character varying(255),
    description text,
    tracks jsonb DEFAULT '[]'::jsonb NOT NULL,
    ref_data_func character varying(255),
    fk_artist_keys bigint,
    fk_user_keys bigint NOT NULL,
    private_all_see smallint DEFAULT 1 NOT NULL,
    dt_modified timestamp without time zone DEFAULT now() NOT NULL,
    dt_created timestamp without time zone DEFAULT now() NOT NULL,
    image_path character varying,
    slug character varying
);


--
-- TOC entry 219 (class 1259 OID 16407)
-- Name: playlists_playlist_key_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playlists_playlist_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3477 (class 0 OID 0)
-- Dependencies: 219
-- Name: playlists_playlist_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playlists_playlist_key_seq OWNED BY public.playlists.playlist_key;


--
-- TOC entry 226 (class 1259 OID 16435)
-- Name: tracks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tracks (
    track_key integer NOT NULL,
    name character varying(255) NOT NULL,
    fk_artist_key bigint NOT NULL,
    fk_user_key bigint NOT NULL,
    duration character varying(255) NOT NULL,
    image_path character varying(255) NOT NULL,
    track_path character varying(255) NOT NULL,
    listen_count bigint NOT NULL,
    dt_created timestamp without time zone DEFAULT now() NOT NULL,
    dt_modified timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 16392)
-- Name: tracks_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tracks_log (
    tracks_log_key integer NOT NULL,
    fk_user_key bigint NOT NULL,
    fk_playlist_key bigint NOT NULL,
    fk_track_key bigint NOT NULL,
    country_code character varying(10) NOT NULL,
    dt_created timestamp without time zone DEFAULT now() NOT NULL,
    playlist_slug character varying NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 16391)
-- Name: tracks_log_tracks_log_key_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tracks_log_tracks_log_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3478 (class 0 OID 0)
-- Dependencies: 215
-- Name: tracks_log_tracks_log_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tracks_log_tracks_log_key_seq OWNED BY public.tracks_log.tracks_log_key;


--
-- TOC entry 225 (class 1259 OID 16434)
-- Name: tracks_track_key_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tracks_track_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3479 (class 0 OID 0)
-- Dependencies: 225
-- Name: tracks_track_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tracks_track_key_seq OWNED BY public.tracks.track_key;


--
-- TOC entry 224 (class 1259 OID 16426)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_key integer NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    image_path character varying(255),
    liked_tracks jsonb DEFAULT '[]'::jsonb NOT NULL,
    liked_playlists jsonb DEFAULT '[]'::jsonb NOT NULL,
    dt_created timestamp without time zone DEFAULT now() NOT NULL,
    dt_modified timestamp without time zone DEFAULT now() NOT NULL,
    is_sidebar_closed smallint DEFAULT 0 NOT NULL,
    volume_value numeric(10,2) DEFAULT 0.2 NOT NULL,
    private_profile smallint DEFAULT 0 NOT NULL,
    private_liked_tracks smallint DEFAULT 0 NOT NULL,
    private_recent_track smallint DEFAULT 0 NOT NULL,
    shuffle_value smallint DEFAULT 0 NOT NULL,
    repeat_value smallint DEFAULT 0 NOT NULL,
    email character varying NOT NULL,
    private_show_my_playlits smallint DEFAULT 1 NOT NULL,
    private_show_recent_played_playlists smallint DEFAULT 1 NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 16425)
-- Name: users_user_key_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_key_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3480 (class 0 OID 0)
-- Dependencies: 223
-- Name: users_user_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_key_seq OWNED BY public.users.user_key;


--
-- TOC entry 3276 (class 2604 OID 16402)
-- Name: artists artist_key; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists ALTER COLUMN artist_key SET DEFAULT nextval('public.artists_artist_key_seq'::regclass);


--
-- TOC entry 3285 (class 2604 OID 16420)
-- Name: logs log_key; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logs ALTER COLUMN log_key SET DEFAULT nextval('public.logs_log_key_seq'::regclass);


--
-- TOC entry 3280 (class 2604 OID 16411)
-- Name: playlists playlist_key; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists ALTER COLUMN playlist_key SET DEFAULT nextval('public.playlists_playlist_key_seq'::regclass);


--
-- TOC entry 3300 (class 2604 OID 16438)
-- Name: tracks track_key; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracks ALTER COLUMN track_key SET DEFAULT nextval('public.tracks_track_key_seq'::regclass);


--
-- TOC entry 3274 (class 2604 OID 16395)
-- Name: tracks_log tracks_log_key; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracks_log ALTER COLUMN tracks_log_key SET DEFAULT nextval('public.tracks_log_tracks_log_key_seq'::regclass);


--
-- TOC entry 3286 (class 2604 OID 16429)
-- Name: users user_key; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_key SET DEFAULT nextval('public.users_user_key_seq'::regclass);


--
-- TOC entry 3461 (class 0 OID 16399)
-- Dependencies: 218
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.artists VALUES (2, 8, 'Joji', NULL, '2024-12-10 00:39:40.233574', '2024-12-10 00:39:40.233574', 0);
INSERT INTO public.artists VALUES (3, 8, 'EKKSTACY', NULL, '2024-12-10 00:42:34.242588', '2024-12-10 00:42:34.242588', 0);
INSERT INTO public.artists VALUES (4, 8, 'Richy Mitch & The Coal Miners', NULL, '2024-12-10 00:52:45.602438', '2024-12-10 00:52:45.602438', 0);
INSERT INTO public.artists VALUES (5, 8, 'Damian Malik', NULL, '2024-12-10 00:59:28.463656', '2024-12-10 00:59:28.463656', 0);
INSERT INTO public.artists VALUES (6, 10, 'Arcane, League of Legends Music & Royal & the Serpent', NULL, '2024-12-16 01:31:22.592335', '2024-12-16 01:31:22.592335', 0);
INSERT INTO public.artists VALUES (7, 10, 'Arcane, League of Legends Music & Marcus King', NULL, '2024-12-16 01:31:34.705336', '2024-12-16 01:31:34.705336', 0);
INSERT INTO public.artists VALUES (8, 10, 'Raja Kumari & Stefflon Don', NULL, '2024-12-16 01:31:44.907451', '2024-12-16 01:31:44.907451', 0);
INSERT INTO public.artists VALUES (9, 10, 'Arcane, League of Legends Music & FEVER 333', NULL, '2024-12-16 01:32:22.914414', '2024-12-16 01:32:22.914414', 0);
INSERT INTO public.artists VALUES (10, 10, 'Arcane, League of Legends Music & Freya Ridings', NULL, '2024-12-16 01:32:34.448157', '2024-12-16 01:32:34.448157', 0);
INSERT INTO public.artists VALUES (11, 10, 'Connor Kauffman', NULL, '2024-12-16 01:32:53.600789', '2024-12-16 01:32:53.600789', 0);
INSERT INTO public.artists VALUES (12, 10, 'Mitchel Dae', NULL, '2024-12-16 01:33:32.991188', '2024-12-16 01:33:32.991188', 0);
INSERT INTO public.artists VALUES (14, 11, 'Artemas', NULL, '2025-01-10 01:26:13.118558', '2025-01-10 01:26:13.118558', 0);
INSERT INTO public.artists VALUES (15, 8, 'peas4nt', NULL, '2025-01-13 23:38:34.849097', '2025-01-13 23:38:34.849097', 0);
INSERT INTO public.artists VALUES (19, 14, 'BbyGirl', NULL, '2025-01-14 19:09:18.769925', '2025-01-14 19:09:18.769925', 1);
INSERT INTO public.artists VALUES (20, 14, 'Adaś', NULL, '2025-01-14 19:12:20.163317', '2025-01-14 19:12:20.163317', 1);
INSERT INTO public.artists VALUES (21, 14, 'Lemaier', NULL, '2025-01-14 19:13:23.311426', '2025-01-14 19:13:23.311426', 1);
INSERT INTO public.artists VALUES (23, 14, 'ПОЛМАТЕРИ & нексюша', NULL, '2025-01-14 19:14:46.065281', '2025-01-14 19:14:46.065281', 1);
INSERT INTO public.artists VALUES (22, 10, 'err', NULL, '2025-01-14 19:14:05.868438', '2025-01-14 19:14:05.868438', 1);
INSERT INTO public.artists VALUES (24, 10, 'err', NULL, '2025-01-15 01:00:55.126401', '2025-01-15 01:00:55.126401', 1);
INSERT INTO public.artists VALUES (25, 10, 'err', NULL, '2025-01-15 01:01:11.124632', '2025-01-15 01:01:11.124632', 1);
INSERT INTO public.artists VALUES (26, 10, 'err', NULL, '2025-01-15 01:01:25.782497', '2025-01-15 01:01:25.782497', 1);
INSERT INTO public.artists VALUES (27, 10, 'err', NULL, '2025-01-15 01:01:44.635091', '2025-01-15 01:01:44.635091', 1);
INSERT INTO public.artists VALUES (28, 10, 'err', NULL, '2025-01-15 01:08:05.596929', '2025-01-15 01:08:05.596929', 1);
INSERT INTO public.artists VALUES (29, 10, 'Pinegrove', NULL, '2025-02-07 06:53:09.82624', '2025-02-07 06:53:09.82624', 1);
INSERT INTO public.artists VALUES (30, 16, 'Arctic Monkeys', NULL, '2025-02-07 08:29:17.917751', '2025-02-07 08:29:17.917751', 1);
INSERT INTO public.artists VALUES (31, 10, 'Chri$tian Gate$', NULL, '2025-02-12 07:32:24.072956', '2025-02-12 07:32:24.072956', 1);
INSERT INTO public.artists VALUES (32, 10, 'MORGENSHTERN', NULL, '2025-04-14 09:23:11.220618', '2025-04-14 09:23:11.220618', 1);
INSERT INTO public.artists VALUES (33, 10, 'girl in red', NULL, '2025-04-14 09:27:37.348298', '2025-04-14 09:27:37.348298', 1);
INSERT INTO public.artists VALUES (34, 10, 'Ashtraylol', NULL, '2025-04-14 09:57:21.759885', '2025-04-14 09:57:21.759885', 1);
INSERT INTO public.artists VALUES (35, 18, 'XXXTENTACION', NULL, '2025-04-14 11:32:49.983636', '2025-04-14 11:32:49.983636', 1);
INSERT INTO public.artists VALUES (36, 18, 'SALES', NULL, '2025-04-14 11:33:55.569103', '2025-04-14 11:33:55.569103', 1);
INSERT INTO public.artists VALUES (37, 19, 'admin2', NULL, '2025-04-14 12:40:28.787554', '2025-04-14 12:40:28.787554', 1);
INSERT INTO public.artists VALUES (38, 11, 'BoyWithUke', NULL, '2025-06-05 16:16:20.709919', '2025-06-05 16:16:20.709919', 1);
INSERT INTO public.artists VALUES (39, 11, 'Rocdefini', NULL, '2025-06-05 16:34:10.299775', '2025-06-05 16:34:10.299775', 1);
INSERT INTO public.artists VALUES (40, 11, 'Jace June', NULL, '2025-06-05 19:52:40.820389', '2025-06-05 19:52:40.820389', 1);


--
-- TOC entry 3465 (class 0 OID 16417)
-- Dependencies: 222
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3463 (class 0 OID 16408)
-- Dependencies: 220
-- Data for Name: playlists; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.playlists VALUES (27, 'Cool playlist', '', '[70, 63, 65, 64]', NULL, NULL, 10, 1, '2025-01-15 00:44:04.088593', '2025-01-15 00:44:04.088593', '1736901844084-187.jpg', 'cool-playlist');
INSERT INTO public.playlists VALUES (42, 'My favorite playlist', '123321', '[89, 90, 82, 83, 85, 86, 87, 88]', NULL, NULL, 11, 1, '2025-06-05 19:55:47.953093', '2025-06-05 19:55:47.953093', '1749153347948-204.jpg', 'my-favorite-playlist');
INSERT INTO public.playlists VALUES (24, 'My playlist', 'test', '[54, 52, 50, 51, 45, 44]', NULL, NULL, 8, 1, '2025-01-13 23:41:36.410742', '2025-01-13 23:41:36.410742', '1736811696393-513.png', 'my-playlist');
INSERT INTO public.playlists VALUES (10, 'Arcane', 'description test', '[47, 48, 49, 46]', NULL, NULL, 10, 1, '2024-12-16 01:26:47.798259', '2024-12-16 01:26:47.798259', '1734312407968-828.jpg', 'arcane');
INSERT INTO public.playlists VALUES (16, 'LikedTracks', 'Favorite tracks', '[]', 'likedTracks', NULL, 0, 1, '2025-01-07 03:33:03.572751', '2025-01-07 03:33:03.572751', 'heart.png', 'likedtracks_');
INSERT INTO public.playlists VALUES (33, 'test', '', '[]', NULL, NULL, 16, 1, '2025-02-07 08:32:17.990861', '2025-02-07 08:32:17.990861', '', 'test');
INSERT INTO public.playlists VALUES (26, 'SbornikHydshihPesenInTheWorld', '', '[57, 56, 65, 63, 61, 62]', NULL, NULL, 14, 1, '2025-01-14 18:46:17.411978', '2025-01-14 18:43:34.75435', '1736880214747-540.jpg', 'sbornikhydshihpesenintheworld');
INSERT INTO public.playlists VALUES (19, 'Recently played', 'Your recently listened tracks', '[]', 'recentlyPlayed', NULL, 0, 1, '2025-01-10 00:40:34.178637', '2025-01-10 00:40:34.178637', 'refresh.png', 'recentlyplayed_');
INSERT INTO public.playlists VALUES (20, 'Recently added', 'Recently added tracks', '[]', 'recentlyAdded', NULL, 0, 1, '2025-01-10 00:40:34.178637', '2025-01-10 00:40:34.178637', 'refresh.png', 'recentlyadded');
INSERT INTO public.playlists VALUES (17, 'My Tracks', 'Your uploaded tracks', '[]', 'myTracks', NULL, 0, 1, '2025-01-07 03:33:03.572751', '2025-01-07 03:33:03.572751', 'track2.png', 'mytracks');
INSERT INTO public.playlists VALUES (35, 'qweqwe', '', '[67]', NULL, NULL, 10, 0, '2025-02-12 07:36:30.749221', '2025-02-12 07:33:11.830444', '', 'qweqwe');
INSERT INTO public.playlists VALUES (29, 'Sad playlist', '', '[69, 68, 67, 66, 64]', NULL, NULL, 10, 1, '2025-01-15 00:46:23.436298', '2025-01-15 00:46:23.436298', '1736901983435-855.jpg', 'sad-playlist');
INSERT INTO public.playlists VALUES (8, 'First playlist', '', '[]', NULL, NULL, 9, 1, '2025-01-15 01:04:49.352217', '2024-12-10 01:09:25.823', '1736903089347-654.jpg', 'first-playlist');
INSERT INTO public.playlists VALUES (38, '123123', '', '[]', NULL, NULL, 19, 1, '2025-04-14 12:38:33.356074', '2025-04-14 12:38:33.356074', '', '123123');
INSERT INTO public.playlists VALUES (28, 'Amazing playlist', '', '[52, 67]', NULL, NULL, 10, 1, '2025-01-15 00:44:25.730891', '2025-01-15 00:44:25.730891', '1736901865729-793.jpg', 'amazing-playlist');
INSERT INTO public.playlists VALUES (30, 'Playlist example', '', '[68]', NULL, NULL, 10, 1, '2025-01-15 00:47:23.645119', '2025-01-15 00:47:23.645119', '1736902043642-833.jpg', 'playlist-example');
INSERT INTO public.playlists VALUES (37, 'admin2', '', '[64, 66]', NULL, NULL, 19, 1, '2025-04-14 12:38:05.835932', '2025-04-14 12:38:05.835932', '1744634285829-601.png', 'admin2');
INSERT INTO public.playlists VALUES (39, 'Kabanchik', 'only kabanchik', '[70]', NULL, NULL, 11, 1, '2025-04-22 23:01:13.329786', '2025-04-22 22:21:54.5094', '1745362873325-412.jpg', 'kabanchik');


--
-- TOC entry 3469 (class 0 OID 16435)
-- Dependencies: 226
-- Data for Name: tracks; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tracks VALUES (88, 'Revenge', 35, 11, '2:02', 'https://is1-ssl.mzstatic.com/image/thumb/Features115/v4/2d/fc/65/2dfc6540-f90e-c244-4942-1fa0d3d88a72/mzl.hvlfukta.jpg/800x800cc.jpg', 'xxxtentacion-revenge.mp3', 2, '2025-06-05 19:50:00.606462', '2025-06-05 19:50:00.606462');
INSERT INTO public.tracks VALUES (75, 'We Fell in Love in October', 33, 10, '3:07', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages211/v4/89/f2/ed/89f2ed84-7765-4d98-d01a-3385677f2dc0/ami-identity-b1d035a2d097d1a60dd6785d5d820ba8-2025-02-28T18-02-39.974Z_cropped.png/800x800cc.jpg', 'girl_in_red-we_fell_in_love_in_october.mp3', 1, '2025-04-14 09:27:37.34972', '2025-04-14 09:27:37.34972');
INSERT INTO public.tracks VALUES (63, 'Мама удалила роблокс (feat. Gulyashik & Qurorr)', 21, 14, '3:04', 'https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/89/3b/08/893b0897-75fa-1560-0595-e92269264cae/2_001_Lemaier_feat_Gulyashik_Qurorr-Mama_udalila_robloks.jpg/400x400cc.jpg', 'lemaier-мама_удалила_роблокс_(feat._gulyashik_&_qurorr).mp3', 64, '2025-01-14 19:13:23.312511', '2025-01-14 19:13:23.312511');
INSERT INTO public.tracks VALUES (57, 'Я помню (feat. маз корж)', 17, 14, '5:07', 'https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/4c/e0/af/4ce0af12-2409-4ee6-4ae6-85deb794f789/cover.jpg/400x400cc.jpg', 'mazellovvv-я_помню_(feat._маз_корж).mp3', 3, '2025-01-14 18:52:50.671322', '2025-01-14 18:52:50.671322');
INSERT INTO public.tracks VALUES (71, 'Need 2', 29, 10, '3:11', 'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/8d/4b/42/8d4b4265-1194-2756-89a3-fc11c2e17263/pr_source.png/800x800cc.jpg', 'pinegrove-need_2.mp3', 5, '2025-02-07 06:53:09.8271', '2025-02-07 06:53:09.8271');
INSERT INTO public.tracks VALUES (47, 'Hellfire (from the series Arcane League of Legends)', 9, 10, '2:44', 'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/54/cf/11/54cf11ab-ac8b-587c-d98f-ac491277ae97/00198704145971_Cover.jpg/400x400cc.jpg', 'arcane,_league_of_legends_music_&_fever_333-hellfire_(from_the_series_arcane_league_of_legends).mp3', 58, '2025-01-03 13:22:24.401611', '2025-01-03 13:22:24.401611');
INSERT INTO public.tracks VALUES (60, 'Кабанчик', 16, 14, '5:07', 'https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/fe/e1/b7/fee1b736-0d76-6627-00d2-847dcf1d1af7/cover.jpg/400x400cc.jpg', 'в''ячеслав_кукоба-кабанчик.mp3', 6, '2025-01-14 19:02:02.30462', '2025-01-14 19:02:02.30462');
INSERT INTO public.tracks VALUES (61, 'Jealous Girl - Sped Up', 19, 14, '2:33', 'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/96/78/a5/9678a5a1-5b37-3026-e2de-6c14c5eb9939/5063341819408_cover.jpg/400x400cc.jpg', 'bbygirl-jealous_girl_-_sped_up.mp3', 10, '2025-01-14 19:09:18.772748', '2025-01-14 19:09:18.772748');
INSERT INTO public.tracks VALUES (62, 'dessous', 20, 14, '2:07', 'https://is1-ssl.mzstatic.com/image/thumb/Features122/v4/4e/c8/77/4ec87707-0f54-4d96-dfdd-0c2a6fec7fd4/mzl.lvawwsat.png/800x800cc.jpg', 'adaś-dessous.mp3', 11, '2025-01-14 19:12:20.164101', '2025-01-14 19:12:20.164101');
INSERT INTO public.tracks VALUES (79, 'HEARTEATER', 35, 18, '2:16', 'https://is1-ssl.mzstatic.com/image/thumb/Features115/v4/2d/fc/65/2dfc6540-f90e-c244-4942-1fa0d3d88a72/mzl.hvlfukta.jpg/800x800cc.jpg', 'xxxtentacion-hearteater.mp3', 2, '2025-04-14 11:32:49.984639', '2025-04-14 11:32:49.984639');
INSERT INTO public.tracks VALUES (83, 'bad idea!', 33, 11, '3:46', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages211/v4/89/f2/ed/89f2ed84-7765-4d98-d01a-3385677f2dc0/ami-identity-b1d035a2d097d1a60dd6785d5d820ba8-2025-02-28T18-02-39.974Z_cropped.png/800x800cc.jpg', 'girl_in_red-bad_idea!.mp3', 4, '2025-06-05 16:17:35.779452', '2025-06-05 16:17:35.779452');
INSERT INTO public.tracks VALUES (80, 'Pope Is a Rockstar', 36, 18, '3:03', 'https://is1-ssl.mzstatic.com/image/thumb/Features115/v4/25/7c/b6/257cb6a2-86b7-2d0a-a976-36a130f80498/pr_source.png/800x800cc.jpg', 'sales-pope_is_a_rockstar.mp3', 0, '2025-04-14 11:33:55.57006', '2025-04-14 11:33:55.57006');
INSERT INTO public.tracks VALUES (64, 'When the Sun Goes Down', 22, 10, '3:22', 'https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/d9/a6/06/d9a60642-3a9a-c289-326d-9af3928c4784/pr_source.png/800x800cc.jpg', 'arctic_monkeys-when_the_sun_goes_down.mp3', 179, '2025-01-14 19:14:05.86929', '2025-01-14 19:14:05.86929');
INSERT INTO public.tracks VALUES (85, 'Shy', 38, 11, '2:47', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages221/v4/09/e2/a7/09e2a7c1-d8d2-d9a1-fefd-00c06ac277d5/file_cropped.png/800x800cc.jpg', 'boywithuke-shy.mp3', 9, '2025-06-05 16:20:16.394249', '2025-06-05 16:20:16.394249');
INSERT INTO public.tracks VALUES (46, 'Sucker (from the series Arcane League of Legends)', 7, 10, '3:44', 'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/54/cf/11/54cf11ab-ac8b-587c-d98f-ac491277ae97/00198704145971_Cover.jpg/400x400cc.jpg', 'arcane,_league_of_legends_music_&_marcus_king-sucker_(from_the_series_arcane_league_of_legends).mp3', 209, '2024-12-24 18:52:20.877877', '2024-12-24 18:52:20.877877');
INSERT INTO public.tracks VALUES (65, 'мамкин бизнесмен', 23, 14, '2:54', 'https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/52/a2/52/52a2522c-40e3-31d8-10d0-cdef16afd843/pr_source.png/800x800cc.jpg', 'полматери_&_нексюша-мамкин_бизнесмен.mp3', 58, '2025-01-14 19:14:46.066375', '2025-01-14 19:14:46.066375');
INSERT INTO public.tracks VALUES (51, 'Evergreen', 4, 10, '1:27', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages126/v4/fe/c1/df/fec1df3b-2bbc-f614-7b27-236374fef489/f7c5d7f9-bf85-4596-b11f-67f2c4c81732_ami-identity-63a28db6bab105bd7964fcdd544dff3e-2023-02-02T22-11-56.763Z_cropped.png/800x800cc.jpg', 'richy_mitch_&_the_coal_miners-evergreen.mp3', 56, '2025-01-03 13:23:54.518443', '2025-01-03 13:23:54.518443');
INSERT INTO public.tracks VALUES (89, 'Come Home', 40, 11, '2:48', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages116/v4/d3/d1/01/d3d101a8-d3fe-52ff-9e2e-55c59bab7d60/b7ae5153-bd1b-4dec-b055-6ac12cae22b6_ami-identity-4990bb0705d4f2bc7c96c8290a3cd8b7-2023-12-22T20-22-21.630Z_cropped.png/800x800cc.jpg', 'jace_june-come_home.mp3', 1, '2025-06-05 19:52:40.821528', '2025-06-05 19:52:40.821528');
INSERT INTO public.tracks VALUES (90, 'Triumph', 35, 11, '2:46', 'https://is1-ssl.mzstatic.com/image/thumb/Features115/v4/2d/fc/65/2dfc6540-f90e-c244-4942-1fa0d3d88a72/mzl.hvlfukta.jpg/800x800cc.jpg', 'xxxtentacion-triumph.mp3', 0, '2025-06-05 19:55:03.772097', '2025-06-05 19:55:03.772097');
INSERT INTO public.tracks VALUES (68, 'Better People To Leave On Read', 26, 10, '2:11', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages211/v4/a8/ff/df/a8ffdfab-5069-8754-915c-e67ddcf7e964/ami-identity-9e9c9579ccf851d36baee5bace2fdafe-2025-01-03T04-22-33.267Z_cropped.png/800x800cc.jpg', 'emei-better_people_to_leave_on_read.mp3', 128, '2025-01-15 01:01:25.783662', '2025-01-15 01:01:25.783662');
INSERT INTO public.tracks VALUES (66, 'I Won''t Beg for You', 24, 10, '2:03', 'https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/87/57/07/875707ef-f8f7-a33f-76b6-f190220baebf/pr_source.png/800x800cc.jpg', 'chri$tian_gate$-i_won''t_beg_for_you.mp3', 131, '2025-01-15 01:00:55.127684', '2025-01-15 01:00:55.127684');
INSERT INTO public.tracks VALUES (72, 'Dancing Shoes', 30, 16, '2:21', 'https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/d9/a6/06/d9a60642-3a9a-c289-326d-9af3928c4784/pr_source.png/800x800cc.jpg', 'arctic_monkeys-dancing_shoes.mp3', 6, '2025-02-07 08:29:17.919729', '2025-02-07 08:29:17.919729');
INSERT INTO public.tracks VALUES (69, 'did i tell u that i miss u (Slowed)', 27, 10, '1:56', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages126/v4/93/52/6b/93526bf9-22a3-9971-7e9c-fce53a3f974b/eb0e8abd-5069-48e1-8939-d4e2c7571b5b_ami-identity-6762801afb0c7d7d93fbcc8570f3e605-2023-06-15T19-28-40.919Z_cropped.png/800x800cc.jpg', 'adore-did_i_tell_u_that_i_miss_u_(slowed).mp3', 130, '2025-01-15 01:01:44.635926', '2025-01-15 01:01:44.635926');
INSERT INTO public.tracks VALUES (55, 'console.log(''HACKING'')', 15, 8, '1:01', 'peas4nt-console.log(''hacking'').image.jpg', 'peas4nt-console.log(''hacking'').mp3', 10, '2025-01-13 23:38:34.968302', '2025-01-13 23:38:34.968302');
INSERT INTO public.tracks VALUES (52, 'Die For You', 2, 10, '3:31', 'https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/ff/19/c1/ff19c1c0-bd5f-b5e6-3073-fcf2dc107f6c/pr_source.png/800x800cc.jpg', 'joji-die_for_you.mp3', 116, '2025-01-07 00:50:24.471833', '2025-01-07 00:50:24.471833');
INSERT INTO public.tracks VALUES (81, 'Shy', 37, 19, '2:47', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages221/v4/09/e2/a7/09e2a7c1-d8d2-d9a1-fefd-00c06ac277d5/file_cropped.png/800x800cc.jpg', 'boywithuke-shy.mp3', 6, '2025-04-14 12:40:28.78894', '2025-04-14 12:40:28.78894');
INSERT INTO public.tracks VALUES (45, 'Parasite', 11, 10, '2:26', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages221/v4/a4/e8/fd/a4e8fd79-dbcb-008f-cf91-23c996dbcc59/320b38d0-9c82-4e7e-836f-74b1482348bf_ami-identity-b2770079949bd5a591b8e718cecd9195-2024-09-21T17-46-07.749Z_cropped.png/800x800cc.jpg', 'connor_kauffman-parasite.mp3', 69, '2024-12-24 18:52:04.938955', '2024-12-24 18:52:04.938955');
INSERT INTO public.tracks VALUES (48, 'Renegade (We Never Run) [from the series Arcane League of Legends] [feat. Jarina De Marco]', 8, 10, '2:41', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages126/v4/09/06/08/09060834-32ef-fd0e-e8e0-378a0c00fef2/2f80b39f-679b-435b-a2ca-596cab82ffb5_file_cropped.png/800x800cc.jpg', 'raja_kumari_&_stefflon_don-renegade_(we_never_run)_[from_the_series_arcane_league_of_legends]_[feat._jarina_de_marco].mp3', 38, '2025-01-03 13:23:06.828083', '2025-01-03 13:23:06.828083');
INSERT INTO public.tracks VALUES (76, 'ПОВОД', 32, 10, '2:33', 'https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/1a/78/88/1a78885a-3459-5d94-c7ea-ea8de147447a/pr_source.png/800x800cc.jpg', 'morgenshtern-повод.mp3', 2, '2025-04-14 09:56:23.733338', '2025-04-14 09:56:23.733338');
INSERT INTO public.tracks VALUES (50, 'then i met her', 3, 10, '2:18', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages221/v4/95/13/3a/95133a8b-05b6-43dd-e768-9fe2ca3488cc/363eb719-327e-4613-8629-786a47873abb_ami-identity-29f67417e0b9c49b40ad3e3f03dd4351-2024-05-21T02-33-49.560Z_cropped.png/800x800cc.jpg', 'ekkstacy-then_i_met_her.mp3', 37, '2025-01-03 13:23:41.263579', '2025-01-03 13:23:41.263579');
INSERT INTO public.tracks VALUES (86, 'Haha, Hi', 38, 11, '3:34', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages221/v4/09/e2/a7/09e2a7c1-d8d2-d9a1-fefd-00c06ac277d5/file_cropped.png/800x800cc.jpg', 'boywithuke-haha,_hi.mp3', 6, '2025-06-05 16:20:26.893341', '2025-06-05 16:20:26.893341');
INSERT INTO public.tracks VALUES (44, 'Innocent', 12, 10, '3:45', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages221/v4/cd/ee/42/cdee42ed-e9e7-cabf-cff2-118ec9965769/file_cropped.png/800x800cc.jpg', 'mitchel_dae-innocent.mp3', 40, '2024-12-24 18:51:34.341599', '2024-12-24 18:51:34.341599');
INSERT INTO public.tracks VALUES (54, 'i like the way you kiss me', 14, 8, '2:22', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages211/v4/0f/6b/33/0f6b33fe-64bd-7ef7-910c-633fbe06e37c/ami-identity-b4cdf97096d02ef0fc800697291f3a02-2024-10-14T13-11-07.528Z_cropped.png/800x800cc.jpg', 'artemas-i_like_the_way_you_kiss_me.mp3', 113, '2025-01-13 22:57:19.078029', '2025-01-13 22:57:19.078029');
INSERT INTO public.tracks VALUES (67, 'meant to be', 25, 10, '2:50', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages221/v4/9f/06/fd/9f06fd7e-6028-990f-d65c-537764501872/a0ebf372-3896-4c78-84de-0d88ea7fc6d7_ami-identity-ca582c39fdb45287725a2cdb50e0e9f7-2024-07-24T03-47-46.618Z_cropped.png/800x800cc.jpg', 'bbno$-meant_to_be.mp3', 124, '2025-01-15 01:01:11.125363', '2025-01-15 01:01:11.125363');
INSERT INTO public.tracks VALUES (84, 'LoveSick', 38, 11, '2:26', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages221/v4/09/e2/a7/09e2a7c1-d8d2-d9a1-fefd-00c06ac277d5/file_cropped.png/800x800cc.jpg', 'boywithuke-lovesick.mp3', 19, '2025-06-05 16:19:59.296006', '2025-06-05 16:19:59.296006');
INSERT INTO public.tracks VALUES (70, 'Кабанчик', 28, 10, '2:45', 'https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/fe/e1/b7/fee1b736-0d76-6627-00d2-847dcf1d1af7/cover.jpg/400x400cc.jpg', 'в''ячеслав_кукоба-кабанчик.mp3', 111, '2025-01-15 01:08:05.597581', '2025-01-15 01:08:05.597581');
INSERT INTO public.tracks VALUES (49, 'Wasteland (from the series Arcane League of Legends)', 6, 10, '2:41', 'https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/54/cf/11/54cf11ab-ac8b-587c-d98f-ac491277ae97/00198704145971_Cover.jpg/400x400cc.jpg', 'arcane,_league_of_legends_music_&_royal_&_the_serpent-wasteland_(from_the_series_arcane_league_of_legends).mp3', 47, '2025-01-03 13:23:18.144595', '2025-01-03 13:23:18.144595');
INSERT INTO public.tracks VALUES (87, 'For You', 39, 11, '1:41', 'https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/9e/b2/3b/9eb23b72-774f-a81c-3493-d08b67ad4a04/artwork.jpg/400x400cc.jpg', 'rocdefini-for_you.mp3', 5, '2025-06-05 16:34:10.357715', '2025-06-05 16:34:10.357715');
INSERT INTO public.tracks VALUES (73, 'I Won''t Beg for You', 31, 10, '2:03', 'https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/87/57/07/875707ef-f8f7-a33f-76b6-f190220baebf/pr_source.png/800x800cc.jpg', 'chri$tian_gate$-i_won''t_beg_for_you.mp3', 10, '2025-02-12 07:32:24.074069', '2025-02-12 07:32:24.074069');
INSERT INTO public.tracks VALUES (77, 'КРАСНЫЙ ФЛАГ', 32, 10, '2:26', 'https://is1-ssl.mzstatic.com/image/thumb/Features125/v4/1a/78/88/1a78885a-3459-5d94-c7ea-ea8de147447a/pr_source.png/800x800cc.jpg', 'morgenshtern-красный_флаг.mp3', 2, '2025-04-14 09:56:49.410088', '2025-04-14 09:56:49.410088');
INSERT INTO public.tracks VALUES (82, 'IDGAF (feat. blackbear)', 38, 11, '2:26', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages221/v4/09/e2/a7/09e2a7c1-d8d2-d9a1-fefd-00c06ac277d5/file_cropped.png/800x800cc.jpg', 'boywithuke-idgaf_(feat._blackbear).mp3', 7, '2025-06-05 16:16:20.766447', '2025-06-05 16:16:20.766447');
INSERT INTO public.tracks VALUES (78, 'Haunt U & Ex Bitch (Remix)', 34, 10, '2:01', 'https://is1-ssl.mzstatic.com/image/thumb/AMCArtistImages116/v4/b3/9a/92/b39a92df-faf4-1f79-f487-83c2696b867f/745fc743-38eb-44f4-a708-6c3b5a58b389_file_cropped.png/800x800cc.jpg', 'ashtraylol-haunt_u_&_ex_bitch_(remix).mp3', 1, '2025-04-14 09:57:21.760815', '2025-04-14 09:57:21.760815');


--
-- TOC entry 3459 (class 0 OID 16392)
-- Dependencies: 216
-- Data for Name: tracks_log; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tracks_log VALUES (280, 10, 17, 52, 'US', '2025-01-13 01:34:01.795401', 'mytracks');
INSERT INTO public.tracks_log VALUES (281, 10, 16, 52, 'US', '2025-01-13 01:34:11.232001', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (282, 10, 16, 52, 'US', '2025-01-13 01:34:14.074812', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (283, 10, 17, 52, 'US', '2025-01-13 01:34:22.485238', 'mytracks');
INSERT INTO public.tracks_log VALUES (284, 10, 17, 52, 'US', '2025-01-13 01:34:26.878414', 'mytracks');
INSERT INTO public.tracks_log VALUES (285, 10, 10, 46, 'US', '2025-01-13 01:35:08.69186', 'arcane');
INSERT INTO public.tracks_log VALUES (286, 10, 20, 53, 'US', '2025-01-13 01:36:21.177095', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (287, 10, 20, 53, 'US', '2025-01-13 01:43:03.881028', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (288, 10, 20, 53, 'US', '2025-01-13 01:44:55.409372', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (289, 10, 20, 53, 'US', '2025-01-13 01:47:34.195208', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (290, 10, 20, 52, 'US', '2025-01-13 01:47:34.410503', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (291, 10, 20, 52, 'US', '2025-01-13 01:47:59.137466', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (292, 10, 20, 53, 'US', '2025-01-13 01:48:04.182207', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (293, 10, 20, 52, 'US', '2025-01-13 01:48:04.386797', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (294, 10, 20, 52, 'US', '2025-01-13 01:48:16.875157', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (295, 10, 20, 52, 'US', '2025-01-13 02:00:52.516012', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (296, 10, 20, 51, 'US', '2025-01-13 02:00:54.532164', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (297, 10, 20, 51, 'US', '2025-01-13 02:01:17.102526', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (298, 10, 20, 50, 'US', '2025-01-13 02:01:27.762436', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (299, 10, 20, 50, 'US', '2025-01-13 02:02:52.033802', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (300, 10, 20, 50, 'US', '2025-01-13 02:04:50.536779', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (301, 10, 20, 50, 'US', '2025-01-13 02:06:22.20547', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (302, 10, 20, 50, 'US', '2025-01-13 02:13:09.957861', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (303, 10, 20, 50, 'US', '2025-01-13 02:13:22.309042', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (304, 10, 20, 50, 'US', '2025-01-13 02:13:54.768857', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (305, 10, 20, 50, 'US', '2025-01-13 02:14:10.124424', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (306, 10, 20, 50, 'US', '2025-01-13 02:14:47.082321', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (307, 10, 20, 50, 'US', '2025-01-13 02:14:57.544866', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (308, 10, 20, 50, 'US', '2025-01-13 02:15:05.574373', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (309, 10, 20, 50, 'US', '2025-01-13 02:15:39.317238', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (310, 10, 20, 50, 'US', '2025-01-13 02:20:12.82234', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (311, 10, 14, 45, 'US', '2025-01-13 02:20:16.404794', 'heart-2');
INSERT INTO public.tracks_log VALUES (312, 10, 14, 45, 'US', '2025-01-13 02:20:36.624917', 'heart-2');
INSERT INTO public.tracks_log VALUES (313, 10, 14, 45, 'US', '2025-01-13 02:21:41.678165', 'heart-2');
INSERT INTO public.tracks_log VALUES (314, 10, 14, 45, 'US', '2025-01-13 02:49:51.003754', 'heart-2');
INSERT INTO public.tracks_log VALUES (315, 10, 14, 45, 'US', '2025-01-13 02:51:18.575876', 'heart-2');
INSERT INTO public.tracks_log VALUES (316, 10, 14, 45, 'US', '2025-01-13 02:51:22.354698', 'heart-2');
INSERT INTO public.tracks_log VALUES (317, 10, 14, 45, 'US', '2025-01-13 02:51:58.282875', 'heart-2');
INSERT INTO public.tracks_log VALUES (318, 10, 14, 45, 'US', '2025-01-13 02:52:31.977821', 'heart-2');
INSERT INTO public.tracks_log VALUES (319, 10, 14, 45, 'US', '2025-01-13 02:54:11.578529', 'heart-2');
INSERT INTO public.tracks_log VALUES (320, 10, 14, 45, 'US', '2025-01-13 02:54:26.063579', 'heart-2');
INSERT INTO public.tracks_log VALUES (321, 10, 14, 45, 'US', '2025-01-13 02:59:23.591278', 'heart-2');
INSERT INTO public.tracks_log VALUES (322, 10, 14, 45, 'US', '2025-01-13 03:05:49.621077', 'heart-2');
INSERT INTO public.tracks_log VALUES (323, 10, 14, 45, 'US', '2025-01-13 03:07:20.20227', 'heart-2');
INSERT INTO public.tracks_log VALUES (324, 10, 14, 45, 'US', '2025-01-13 03:09:13.946112', 'heart-2');
INSERT INTO public.tracks_log VALUES (325, 10, 14, 45, 'US', '2025-01-13 03:09:30.875922', 'heart-2');
INSERT INTO public.tracks_log VALUES (326, 10, 14, 45, 'US', '2025-01-13 03:10:50.792358', 'heart-2');
INSERT INTO public.tracks_log VALUES (327, 10, 14, 45, 'US', '2025-01-13 03:11:45.682943', 'heart-2');
INSERT INTO public.tracks_log VALUES (328, 10, 14, 45, 'US', '2025-01-13 03:11:57.932255', 'heart-2');
INSERT INTO public.tracks_log VALUES (329, 10, 14, 45, 'US', '2025-01-13 03:11:59.877354', 'heart-2');
INSERT INTO public.tracks_log VALUES (330, 10, 14, 45, 'US', '2025-01-13 03:12:00.764964', 'heart-2');
INSERT INTO public.tracks_log VALUES (331, 10, 14, 45, 'US', '2025-01-13 03:12:01.595232', 'heart-2');
INSERT INTO public.tracks_log VALUES (332, 10, 14, 45, 'US', '2025-01-13 03:12:02.453992', 'heart-2');
INSERT INTO public.tracks_log VALUES (333, 10, 14, 45, 'US', '2025-01-13 03:12:03.31991', 'heart-2');
INSERT INTO public.tracks_log VALUES (334, 10, 14, 45, 'US', '2025-01-13 03:12:03.908703', 'heart-2');
INSERT INTO public.tracks_log VALUES (335, 10, 14, 45, 'US', '2025-01-13 03:12:04.546944', 'heart-2');
INSERT INTO public.tracks_log VALUES (336, 10, 14, 45, 'US', '2025-01-13 03:16:25.098327', 'heart-2');
INSERT INTO public.tracks_log VALUES (337, 10, 14, 45, 'US', '2025-01-13 03:16:27.553934', 'heart-2');
INSERT INTO public.tracks_log VALUES (338, 10, 14, 45, 'US', '2025-01-13 03:16:29.111306', 'heart-2');
INSERT INTO public.tracks_log VALUES (339, 10, 14, 45, 'US', '2025-01-13 03:19:53.807632', 'heart-2');
INSERT INTO public.tracks_log VALUES (340, 10, 14, 45, 'US', '2025-01-13 03:20:58.077154', 'heart-2');
INSERT INTO public.tracks_log VALUES (341, 10, 14, 45, 'US', '2025-01-13 03:21:19.242587', 'heart-2');
INSERT INTO public.tracks_log VALUES (342, 10, 10, 46, 'US', '2025-01-13 03:26:22.96274', 'arcane');
INSERT INTO public.tracks_log VALUES (343, 10, 10, 48, 'US', '2025-01-13 03:30:41.084197', 'arcane');
INSERT INTO public.tracks_log VALUES (344, 10, 10, 46, 'US', '2025-01-13 03:30:42.244241', 'arcane');
INSERT INTO public.tracks_log VALUES (345, 10, 10, 49, 'US', '2025-01-13 03:30:46.007089', 'arcane');
INSERT INTO public.tracks_log VALUES (346, 10, 10, 48, 'US', '2025-01-13 03:33:27.366724', 'arcane');
INSERT INTO public.tracks_log VALUES (347, 10, 10, 48, 'US', '2025-01-13 03:35:19.654682', 'arcane');
INSERT INTO public.tracks_log VALUES (348, 10, 10, 48, 'US', '2025-01-13 03:35:56.875244', 'arcane');
INSERT INTO public.tracks_log VALUES (349, 8, 10, 46, 'US', '2025-01-13 03:37:22.878768', 'arcane');
INSERT INTO public.tracks_log VALUES (350, 8, 10, 46, 'US', '2025-01-13 03:38:11.911131', 'arcane');
INSERT INTO public.tracks_log VALUES (351, 8, 10, 46, 'US', '2025-01-13 03:38:54.728033', 'arcane');
INSERT INTO public.tracks_log VALUES (352, 8, 10, 49, 'US', '2025-01-13 03:38:56.324548', 'arcane');
INSERT INTO public.tracks_log VALUES (353, 8, 10, 48, 'US', '2025-01-13 03:41:37.753007', 'arcane');
INSERT INTO public.tracks_log VALUES (354, 8, 10, 47, 'US', '2025-01-13 03:44:19.402045', 'arcane');
INSERT INTO public.tracks_log VALUES (355, 8, 10, 46, 'US', '2025-01-13 03:47:04.433981', 'arcane');
INSERT INTO public.tracks_log VALUES (356, 8, 10, 47, 'US', '2025-01-13 03:47:23.978265', 'arcane');
INSERT INTO public.tracks_log VALUES (357, 8, 10, 46, 'US', '2025-01-13 03:47:29.735505', 'arcane');
INSERT INTO public.tracks_log VALUES (358, 8, 20, 53, 'US', '2025-01-13 03:47:34.747414', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (359, 8, 20, 52, 'US', '2025-01-13 03:47:35.042381', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (360, 8, 20, 52, 'US', '2025-01-13 03:51:02.836814', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (361, 8, 20, 52, 'US', '2025-01-13 04:03:40.816838', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (362, 8, 20, 52, 'US', '2025-01-13 04:03:43.354984', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (363, 8, 20, 52, 'US', '2025-01-13 04:12:09.941389', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (364, 8, 20, 52, 'US', '2025-01-13 04:12:11.995752', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (365, 8, 20, 52, 'US', '2025-01-13 04:13:31.777147', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (366, 8, 20, 52, 'US', '2025-01-13 04:14:06.084731', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (367, 8, 20, 52, 'US', '2025-01-13 04:17:01.236444', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (368, 8, 20, 52, 'US', '2025-01-13 04:17:26.819783', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (369, 8, 20, 52, 'US', '2025-01-13 04:22:59.447661', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (370, 8, 20, 52, 'US', '2025-01-13 04:23:36.863916', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (371, 8, 20, 52, 'US', '2025-01-13 04:24:45.780135', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (372, 8, 20, 52, 'US', '2025-01-13 04:31:14.750547', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (373, 8, 20, 52, 'US', '2025-01-13 04:33:37.533807', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (374, 8, 20, 52, 'US', '2025-01-13 04:34:40.355088', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (375, 8, 20, 52, 'US', '2025-01-13 04:35:32.327026', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (376, 8, 20, 52, 'US', '2025-01-13 04:37:31.114415', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (377, 8, 20, 52, 'US', '2025-01-13 04:39:45.105588', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (378, 8, 20, 52, 'US', '2025-01-13 04:40:13.118463', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (379, 8, 20, 52, 'US', '2025-01-13 04:40:51.989465', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (380, 8, 20, 52, 'US', '2025-01-13 04:42:00.360158', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (381, 8, 20, 52, 'US', '2025-01-13 04:42:41.934807', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (382, 8, 20, 52, 'US', '2025-01-13 04:42:56.788377', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (383, 8, 20, 52, 'US', '2025-01-13 04:45:03.637735', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (384, 8, 20, 52, 'US', '2025-01-13 04:49:32.687967', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (385, 8, 20, 52, 'US', '2025-01-13 04:50:42.825278', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (386, 8, 20, 52, 'US', '2025-01-13 04:52:05.622293', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (387, 8, 20, 52, 'US', '2025-01-13 16:10:38.832546', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (392, 8, 20, 52, 'US', '2025-01-13 17:10:36.08709', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (393, 8, 20, 52, 'US', '2025-01-13 17:14:24.271994', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (394, 8, 20, 52, 'US', '2025-01-13 17:15:34.816984', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (395, 8, 10, 46, 'US', '2025-01-13 17:32:56.334608', 'arcane');
INSERT INTO public.tracks_log VALUES (396, 8, 10, 46, 'US', '2025-01-13 17:43:42.524042', 'arcane');
INSERT INTO public.tracks_log VALUES (397, 8, 10, 46, 'US', '2025-01-13 18:43:50.884622', 'arcane');
INSERT INTO public.tracks_log VALUES (398, 8, 10, 46, 'US', '2025-01-13 18:45:56.586943', 'arcane');
INSERT INTO public.tracks_log VALUES (399, 8, 10, 46, 'US', '2025-01-13 19:16:03.891542', 'arcane');
INSERT INTO public.tracks_log VALUES (400, 8, 10, 46, 'US', '2025-01-13 19:17:15.948317', 'arcane');
INSERT INTO public.tracks_log VALUES (401, 8, 10, 46, 'US', '2025-01-13 19:22:21.211786', 'arcane');
INSERT INTO public.tracks_log VALUES (402, 8, 10, 46, 'US', '2025-01-13 19:23:16.367812', 'arcane');
INSERT INTO public.tracks_log VALUES (403, 8, 10, 46, 'US', '2025-01-13 19:28:48.291119', 'arcane');
INSERT INTO public.tracks_log VALUES (404, 8, 10, 46, 'US', '2025-01-13 19:31:07.062631', 'arcane');
INSERT INTO public.tracks_log VALUES (405, 8, 10, 46, 'US', '2025-01-13 19:47:28.407937', 'arcane');
INSERT INTO public.tracks_log VALUES (406, 8, 10, 46, 'US', '2025-01-13 19:48:07.574108', 'arcane');
INSERT INTO public.tracks_log VALUES (407, 8, 10, 46, 'US', '2025-01-13 19:49:33.710439', 'arcane');
INSERT INTO public.tracks_log VALUES (408, 8, 10, 46, 'US', '2025-01-13 19:52:07.682238', 'arcane');
INSERT INTO public.tracks_log VALUES (409, 8, 10, 46, 'US', '2025-01-13 20:03:00.638081', 'arcane');
INSERT INTO public.tracks_log VALUES (410, 8, 10, 46, 'US', '2025-01-13 20:04:54.040282', 'arcane');
INSERT INTO public.tracks_log VALUES (411, 8, 10, 46, 'US', '2025-01-13 20:05:17.753291', 'arcane');
INSERT INTO public.tracks_log VALUES (412, 8, 10, 46, 'US', '2025-01-13 20:06:00.730493', 'arcane');
INSERT INTO public.tracks_log VALUES (413, 8, 10, 48, 'US', '2025-01-13 20:06:22.461913', 'arcane');
INSERT INTO public.tracks_log VALUES (414, 8, 10, 47, 'US', '2025-01-13 20:06:42.583585', 'arcane');
INSERT INTO public.tracks_log VALUES (415, 8, 10, 49, 'US', '2025-01-13 20:09:25.69024', 'arcane');
INSERT INTO public.tracks_log VALUES (416, 8, 10, 49, 'US', '2025-01-13 20:09:45.157909', 'arcane');
INSERT INTO public.tracks_log VALUES (417, 8, 10, 49, 'US', '2025-01-13 20:11:31.42491', 'arcane');
INSERT INTO public.tracks_log VALUES (418, 8, 10, 49, 'US', '2025-01-13 20:19:29.829599', 'arcane');
INSERT INTO public.tracks_log VALUES (419, 8, 10, 49, 'US', '2025-01-13 20:20:07.460936', 'arcane');
INSERT INTO public.tracks_log VALUES (420, 8, 10, 49, 'US', '2025-01-13 20:20:26.916538', 'arcane');
INSERT INTO public.tracks_log VALUES (421, 8, 20, 52, 'US', '2025-01-13 20:20:40.888375', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (422, 8, 20, 47, 'US', '2025-01-13 20:20:45.47701', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (423, 8, 20, 50, 'US', '2025-01-13 20:22:55.015307', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (424, 8, 20, 51, 'US', '2025-01-13 20:23:03.510699', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (425, 8, 20, 50, 'US', '2025-01-13 20:23:10.24734', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (426, 8, 20, 46, 'US', '2025-01-13 20:23:12.712814', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (427, 8, 20, 47, 'US', '2025-01-13 20:23:21.022742', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (428, 8, 20, 46, 'US', '2025-01-13 20:23:22.820138', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (429, 8, 20, 45, 'US', '2025-01-13 20:23:24.455079', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (430, 8, 20, 47, 'US', '2025-01-13 20:23:40.791593', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (431, 8, 20, 45, 'US', '2025-01-13 20:23:46.056218', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (432, 8, 20, 52, 'US', '2025-01-13 20:23:48.240261', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (433, 8, 20, 46, 'US', '2025-01-13 20:23:50.920327', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (434, 8, 20, 46, 'US', '2025-01-13 20:33:56.89004', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (435, 8, 20, 46, 'US', '2025-01-13 20:35:32.118114', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (436, 8, 20, 49, 'US', '2025-01-13 20:35:40.469007', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (437, 8, 20, 53, 'US', '2025-01-13 20:35:45.446898', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (438, 8, 20, 44, 'US', '2025-01-13 20:35:46.382794', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (439, 8, 20, 48, 'US', '2025-01-13 20:35:49.718289', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (440, 8, 20, 47, 'US', '2025-01-13 20:35:54.192561', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (441, 8, 20, 47, 'US', '2025-01-13 20:37:22.654019', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (442, 8, 20, 51, 'US', '2025-01-13 20:37:36.652621', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (443, 8, 20, 44, 'US', '2025-01-13 20:37:47.708782', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (444, 8, 20, 44, 'US', '2025-01-13 20:37:53.334298', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (445, 8, 20, 52, 'US', '2025-01-13 20:37:58.128821', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (446, 8, 20, 51, 'US', '2025-01-13 20:38:01.141739', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (447, 8, 20, 49, 'US', '2025-01-13 20:38:03.481904', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (448, 8, 20, 46, 'US', '2025-01-13 20:38:06.053298', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (449, 8, 20, 47, 'US', '2025-01-13 20:38:08.533086', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (450, 8, 20, 48, 'US', '2025-01-13 20:38:11.483317', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (451, 8, 20, 48, 'US', '2025-01-13 20:39:11.975746', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (452, 8, 20, 48, 'US', '2025-01-13 20:42:24.725114', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (453, 8, 20, 48, 'US', '2025-01-13 20:43:07.491444', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (454, 8, 20, 49, 'US', '2025-01-13 20:43:26.898246', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (455, 8, 20, 50, 'US', '2025-01-13 20:43:32.663932', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (456, 8, 20, 51, 'US', '2025-01-13 20:43:36.474223', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (457, 8, 20, 47, 'US', '2025-01-13 20:43:38.012946', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (458, 8, 20, 46, 'US', '2025-01-13 20:43:40.118159', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (459, 8, 20, 44, 'US', '2025-01-13 20:43:41.691611', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (460, 8, 20, 48, 'US', '2025-01-13 20:43:44.29896', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (461, 8, 20, 53, 'US', '2025-01-13 20:43:46.314572', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (462, 8, 20, 52, 'US', '2025-01-13 20:43:46.696311', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (463, 8, 20, 45, 'US', '2025-01-13 20:43:52.161715', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (464, 8, 20, 48, 'US', '2025-01-13 20:45:45.851637', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (465, 8, 20, 48, 'US', '2025-01-13 20:45:50.625599', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (466, 8, 20, 50, 'US', '2025-01-13 20:46:09.306711', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (467, 8, 20, 52, 'US', '2025-01-13 20:46:10.110505', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (468, 8, 20, 47, 'US', '2025-01-13 20:46:10.819281', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (469, 8, 20, 51, 'US', '2025-01-13 20:46:11.53717', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (470, 8, 20, 53, 'US', '2025-01-13 20:46:12.554997', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1564, 11, 29, 68, 'US', '2025-04-22 21:52:52.936242', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1570, 11, 29, 69, 'US', '2025-04-22 21:52:57.118889', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1576, 11, 29, 64, 'US', '2025-04-22 21:53:00.749277', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1582, 11, 29, 66, 'US', '2025-04-22 21:53:03.403542', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1588, 11, 29, 67, 'US', '2025-04-22 21:53:06.821117', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1594, 11, 29, 68, 'US', '2025-04-22 21:53:08.923587', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1600, 11, 29, 69, 'US', '2025-04-22 21:53:12.083732', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1606, 11, 29, 64, 'US', '2025-04-22 21:53:16.672672', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1612, 11, 29, 66, 'US', '2025-04-22 21:53:18.128698', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1618, 11, 29, 67, 'US', '2025-04-22 21:53:20.735294', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1624, 11, 29, 68, 'US', '2025-04-22 21:53:22.261907', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1630, 11, 29, 69, 'US', '2025-04-22 21:53:24.912635', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1636, 11, 29, 64, 'US', '2025-04-22 21:53:27.420134', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1642, 11, 29, 66, 'US', '2025-04-22 21:53:30.703703', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1648, 11, 29, 67, 'US', '2025-04-22 21:53:32.350761', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1654, 11, 29, 68, 'US', '2025-04-22 21:53:35.857749', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1660, 11, 29, 69, 'US', '2025-04-22 21:53:37.428145', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1666, 11, 29, 64, 'US', '2025-04-22 21:53:39.613999', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1672, 11, 29, 66, 'US', '2025-04-22 21:53:41.776236', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1678, 11, 29, 67, 'US', '2025-04-22 21:53:44.350009', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1684, 11, 29, 68, 'US', '2025-04-22 21:53:46.871411', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1690, 11, 29, 69, 'US', '2025-04-22 21:53:48.660621', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1696, 11, 29, 64, 'US', '2025-04-22 21:53:51.131323', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1702, 11, 29, 66, 'US', '2025-04-22 21:53:52.956336', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1708, 11, 29, 67, 'US', '2025-04-22 21:53:56.275022', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1714, 11, 29, 68, 'US', '2025-04-22 21:53:58.101838', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1720, 11, 29, 69, 'US', '2025-04-22 21:54:00.849273', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1726, 11, 29, 64, 'US', '2025-04-22 21:54:02.30071', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1732, 11, 29, 66, 'US', '2025-04-22 21:54:06.544014', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1738, 11, 29, 67, 'US', '2025-04-22 21:54:08.978723', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1744, 11, 29, 68, 'US', '2025-04-22 21:54:12.000645', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1750, 11, 29, 69, 'US', '2025-04-22 21:54:15.164076', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1753, 11, 29, 66, 'US', '2025-04-22 21:57:27.075583', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1762, 11, 20, 55, 'US', '2025-04-22 22:06:11.875457', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1782, 11, 39, 70, 'US', '2025-04-22 22:32:41.484534', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1791, 11, 39, 70, 'US', '2025-04-22 23:00:40.151472', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1792, 11, 39, 70, 'US', '2025-04-22 23:02:21.405392', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1806, 11, 39, 70, 'US', '2025-06-05 15:51:28.369651', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1809, 11, 39, 70, 'US', '2025-06-05 15:54:46.358403', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1822, 11, 17, 84, 'US', '2025-06-05 16:26:58.516916', 'mytracks');
INSERT INTO public.tracks_log VALUES (1825, 11, 17, 83, 'US', '2025-06-05 16:29:30.673872', 'mytracks');
INSERT INTO public.tracks_log VALUES (1841, 11, 17, 84, 'US', '2025-06-05 17:07:57.322221', 'mytracks');
INSERT INTO public.tracks_log VALUES (1843, 11, 17, 84, 'US', '2025-06-05 17:11:49.686735', 'mytracks');
INSERT INTO public.tracks_log VALUES (1858, 11, 17, 84, 'US', '2025-06-05 18:17:30.860979', 'mytracks');
INSERT INTO public.tracks_log VALUES (471, 8, 20, 49, 'US', '2025-01-13 20:46:12.938123', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (472, 8, 20, 45, 'US', '2025-01-13 20:46:14.529043', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (473, 8, 20, 44, 'US', '2025-01-13 20:46:15.49964', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (474, 8, 20, 46, 'US', '2025-01-13 20:46:18.152258', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (475, 8, 20, 45, 'US', '2025-01-13 20:46:21.35098', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (476, 8, 20, 46, 'US', '2025-01-13 20:46:27.934792', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (477, 8, 20, 47, 'US', '2025-01-13 20:46:30.140976', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (478, 8, 20, 47, 'US', '2025-01-13 20:47:30.423879', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (479, 8, 20, 47, 'US', '2025-01-13 20:50:51.355763', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (480, 8, 20, 47, 'US', '2025-01-13 20:50:56.666727', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (481, 8, 20, 47, 'US', '2025-01-13 20:51:00.86356', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (482, 8, 20, 46, 'US', '2025-01-13 22:00:27.858807', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (483, 8, 20, 46, 'US', '2025-01-13 22:00:30.316089', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (484, 8, 20, 46, 'US', '2025-01-13 22:50:38.429037', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (485, 8, 20, 46, 'US', '2025-01-13 22:51:35.903674', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (486, 8, 20, 46, 'US', '2025-01-13 22:53:04.289818', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (487, 8, 20, 46, 'US', '2025-01-13 23:02:24.083357', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (488, 8, 16, 47, 'US', '2025-01-13 23:02:33.446498', 'likedtracks_8');
INSERT INTO public.tracks_log VALUES (489, 8, 20, 54, 'US', '2025-01-13 23:02:34.408708', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (490, 8, 20, 52, 'US', '2025-01-13 23:04:57.314562', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (491, 8, 20, 47, 'US', '2025-01-13 23:07:16.671766', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (492, 8, 20, 52, 'US', '2025-01-13 23:07:18.236318', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (493, 8, 20, 54, 'US', '2025-01-13 23:07:21.565473', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (494, 8, 20, 44, 'US', '2025-01-13 23:07:24.647193', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (495, 8, 20, 49, 'US', '2025-01-13 23:07:27.117081', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (496, 8, 20, 46, 'US', '2025-01-13 23:07:29.249364', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (497, 8, 20, 46, 'US', '2025-01-13 23:11:14.772011', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (498, 8, 20, 46, 'US', '2025-01-13 23:27:38.5256', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (499, 8, 20, 46, 'US', '2025-01-13 23:28:41.103825', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (500, 8, 20, 46, 'US', '2025-01-13 23:32:37.11239', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (501, 8, 20, 46, 'US', '2025-01-13 23:33:54.702546', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (502, 8, 20, 46, 'US', '2025-01-13 23:36:41.236923', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (503, 8, 20, 46, 'US', '2025-01-13 23:37:41.61637', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (504, 8, 20, 46, 'US', '2025-01-13 23:38:15.675174', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (505, 8, 17, 55, 'US', '2025-01-13 23:38:44.531547', 'mytracks');
INSERT INTO public.tracks_log VALUES (506, 8, 17, 55, 'US', '2025-01-13 23:39:56.167768', 'mytracks');
INSERT INTO public.tracks_log VALUES (507, 8, 17, 55, 'US', '2025-01-13 23:40:05.225315', 'mytracks');
INSERT INTO public.tracks_log VALUES (508, 8, 17, 55, 'US', '2025-01-13 23:40:18.051278', 'mytracks');
INSERT INTO public.tracks_log VALUES (509, 8, 17, 55, 'US', '2025-01-13 23:40:18.875354', 'mytracks');
INSERT INTO public.tracks_log VALUES (510, 8, 17, 55, 'US', '2025-01-13 23:42:14.727196', 'mytracks');
INSERT INTO public.tracks_log VALUES (511, 8, 17, 54, 'US', '2025-01-13 23:42:15.111899', 'mytracks');
INSERT INTO public.tracks_log VALUES (512, 8, 24, 44, 'US', '2025-01-13 23:43:27.925239', 'my-playlist');
INSERT INTO public.tracks_log VALUES (513, 8, 24, 54, 'US', '2025-01-13 23:43:34.59655', 'my-playlist');
INSERT INTO public.tracks_log VALUES (514, 8, 24, 44, 'US', '2025-01-14 06:27:23.113277', 'my-playlist');
INSERT INTO public.tracks_log VALUES (515, 8, 24, 45, 'US', '2025-01-14 06:27:33.621541', 'my-playlist');
INSERT INTO public.tracks_log VALUES (516, 8, 24, 45, 'US', '2025-01-14 07:08:35.797992', 'my-playlist');
INSERT INTO public.tracks_log VALUES (517, 11, 10, 46, 'US', '2025-01-14 07:12:15.173184', 'arcane');
INSERT INTO public.tracks_log VALUES (518, 11, 10, 46, 'US', '2025-01-14 07:12:44.368953', 'arcane');
INSERT INTO public.tracks_log VALUES (519, 11, 10, 46, 'US', '2025-01-14 07:14:04.667236', 'arcane');
INSERT INTO public.tracks_log VALUES (520, 11, 10, 46, 'US', '2025-01-14 07:24:12.070837', 'arcane');
INSERT INTO public.tracks_log VALUES (521, 11, 10, 46, 'US', '2025-01-14 07:24:15.74012', 'arcane');
INSERT INTO public.tracks_log VALUES (522, 11, 10, 46, 'US', '2025-01-14 07:29:52.612006', 'arcane');
INSERT INTO public.tracks_log VALUES (523, 11, 10, 46, 'US', '2025-01-14 07:30:07.569536', 'arcane');
INSERT INTO public.tracks_log VALUES (524, 11, 10, 46, 'US', '2025-01-14 07:30:38.02611', 'arcane');
INSERT INTO public.tracks_log VALUES (525, 11, 10, 46, 'US', '2025-01-14 07:35:47.956131', 'arcane');
INSERT INTO public.tracks_log VALUES (526, 11, 10, 46, 'US', '2025-01-14 07:35:56.53604', 'arcane');
INSERT INTO public.tracks_log VALUES (527, 11, 10, 46, 'US', '2025-01-14 07:46:49.931407', 'arcane');
INSERT INTO public.tracks_log VALUES (528, 11, 10, 46, 'US', '2025-01-14 07:47:12.99204', 'arcane');
INSERT INTO public.tracks_log VALUES (529, 11, 10, 46, 'US', '2025-01-14 07:47:21.322288', 'arcane');
INSERT INTO public.tracks_log VALUES (530, 11, 10, 46, 'US', '2025-01-14 07:47:36.14576', 'arcane');
INSERT INTO public.tracks_log VALUES (531, 11, 10, 46, 'US', '2025-01-14 07:48:09.755167', 'arcane');
INSERT INTO public.tracks_log VALUES (532, 11, 10, 46, 'US', '2025-01-14 07:50:16.792368', 'arcane');
INSERT INTO public.tracks_log VALUES (533, 11, 10, 46, 'US', '2025-01-14 07:51:46.99892', 'arcane');
INSERT INTO public.tracks_log VALUES (534, 11, 10, 46, 'US', '2025-01-14 07:54:38.568465', 'arcane');
INSERT INTO public.tracks_log VALUES (535, 11, 10, 46, 'US', '2025-01-14 07:56:39.475736', 'arcane');
INSERT INTO public.tracks_log VALUES (536, 11, 10, 46, 'US', '2025-01-14 07:56:47.044671', 'arcane');
INSERT INTO public.tracks_log VALUES (537, 11, 10, 46, 'US', '2025-01-14 07:57:00.099768', 'arcane');
INSERT INTO public.tracks_log VALUES (538, 11, 10, 46, 'US', '2025-01-14 08:00:31.597565', 'arcane');
INSERT INTO public.tracks_log VALUES (539, 11, 10, 46, 'US', '2025-01-14 08:02:23.685457', 'arcane');
INSERT INTO public.tracks_log VALUES (540, 11, 10, 46, 'US', '2025-01-14 08:02:25.930626', 'arcane');
INSERT INTO public.tracks_log VALUES (541, 11, 10, 46, 'US', '2025-01-14 08:03:25.551076', 'arcane');
INSERT INTO public.tracks_log VALUES (542, 11, 10, 46, 'US', '2025-01-14 08:08:14.979792', 'arcane');
INSERT INTO public.tracks_log VALUES (543, 11, 10, 46, 'US', '2025-01-14 08:08:25.455037', 'arcane');
INSERT INTO public.tracks_log VALUES (544, 11, 10, 46, 'US', '2025-01-14 08:13:13.759237', 'arcane');
INSERT INTO public.tracks_log VALUES (545, 11, 10, 46, 'US', '2025-01-14 08:15:07.72077', 'arcane');
INSERT INTO public.tracks_log VALUES (546, 11, 10, 46, 'US', '2025-01-14 08:17:05.810225', 'arcane');
INSERT INTO public.tracks_log VALUES (547, 11, 10, 46, 'US', '2025-01-14 08:17:11.475442', 'arcane');
INSERT INTO public.tracks_log VALUES (548, 11, 10, 46, 'US', '2025-01-14 08:17:18.192425', 'arcane');
INSERT INTO public.tracks_log VALUES (549, 11, 10, 46, 'US', '2025-01-14 08:17:42.780486', 'arcane');
INSERT INTO public.tracks_log VALUES (550, 11, 10, 46, 'US', '2025-01-14 08:30:15.705798', 'arcane');
INSERT INTO public.tracks_log VALUES (551, 11, 10, 46, 'US', '2025-01-14 08:30:38.935668', 'arcane');
INSERT INTO public.tracks_log VALUES (552, 11, 10, 46, 'US', '2025-01-14 08:32:33.826855', 'arcane');
INSERT INTO public.tracks_log VALUES (553, 11, 10, 46, 'US', '2025-01-14 08:33:09.709523', 'arcane');
INSERT INTO public.tracks_log VALUES (554, 11, 10, 46, 'US', '2025-01-14 08:33:28.545138', 'arcane');
INSERT INTO public.tracks_log VALUES (555, 11, 10, 46, 'US', '2025-01-14 08:34:10.88252', 'arcane');
INSERT INTO public.tracks_log VALUES (556, 11, 10, 46, 'US', '2025-01-14 08:35:24.605076', 'arcane');
INSERT INTO public.tracks_log VALUES (557, 11, 10, 46, 'US', '2025-01-14 08:35:45.759458', 'arcane');
INSERT INTO public.tracks_log VALUES (558, 11, 10, 46, 'US', '2025-01-14 08:35:56.21458', 'arcane');
INSERT INTO public.tracks_log VALUES (559, 11, 10, 46, 'US', '2025-01-14 08:36:20.952841', 'arcane');
INSERT INTO public.tracks_log VALUES (560, 11, 10, 46, 'US', '2025-01-14 08:36:36.606186', 'arcane');
INSERT INTO public.tracks_log VALUES (561, 11, 10, 46, 'US', '2025-01-14 08:38:48.450017', 'arcane');
INSERT INTO public.tracks_log VALUES (562, 11, 10, 46, 'US', '2025-01-14 08:38:51.204471', 'arcane');
INSERT INTO public.tracks_log VALUES (563, 11, 10, 46, 'US', '2025-01-14 08:38:55.93128', 'arcane');
INSERT INTO public.tracks_log VALUES (564, 11, 10, 46, 'US', '2025-01-14 08:39:06.79071', 'arcane');
INSERT INTO public.tracks_log VALUES (565, 11, 10, 46, 'US', '2025-01-14 08:39:19.301767', 'arcane');
INSERT INTO public.tracks_log VALUES (566, 11, 10, 46, 'US', '2025-01-14 08:39:46.761029', 'arcane');
INSERT INTO public.tracks_log VALUES (1565, 11, 29, 69, 'US', '2025-04-22 21:52:53.84959', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1571, 11, 29, 64, 'US', '2025-04-22 21:52:57.322736', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1577, 11, 29, 66, 'US', '2025-04-22 21:53:01.127422', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1583, 11, 29, 67, 'US', '2025-04-22 21:53:04.183711', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1589, 11, 29, 68, 'US', '2025-04-22 21:53:07.064099', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1595, 11, 29, 69, 'US', '2025-04-22 21:53:09.546971', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1601, 11, 29, 64, 'US', '2025-04-22 21:53:12.409039', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1607, 11, 29, 66, 'US', '2025-04-22 21:53:16.957978', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1613, 11, 29, 67, 'US', '2025-04-22 21:53:18.540088', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1619, 11, 29, 68, 'US', '2025-04-22 21:53:20.985308', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1625, 11, 29, 69, 'US', '2025-04-22 21:53:22.468098', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1631, 11, 29, 64, 'US', '2025-04-22 21:53:25.343885', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1637, 11, 29, 66, 'US', '2025-04-22 21:53:27.87137', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1643, 11, 29, 67, 'US', '2025-04-22 21:53:31.080708', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1649, 11, 29, 68, 'US', '2025-04-22 21:53:32.630374', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1655, 11, 29, 69, 'US', '2025-04-22 21:53:36.287824', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1661, 11, 29, 64, 'US', '2025-04-22 21:53:37.641844', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1667, 11, 29, 66, 'US', '2025-04-22 21:53:40.265704', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1673, 11, 29, 67, 'US', '2025-04-22 21:53:41.995307', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1679, 11, 29, 68, 'US', '2025-04-22 21:53:44.926529', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1685, 11, 29, 69, 'US', '2025-04-22 21:53:47.116933', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1691, 11, 29, 64, 'US', '2025-04-22 21:53:49.017886', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1697, 11, 29, 66, 'US', '2025-04-22 21:53:51.32551', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1703, 11, 29, 67, 'US', '2025-04-22 21:53:53.483157', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1709, 11, 29, 68, 'US', '2025-04-22 21:53:56.539232', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1715, 11, 29, 69, 'US', '2025-04-22 21:53:58.384879', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1721, 11, 29, 64, 'US', '2025-04-22 21:54:01.080572', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1727, 11, 29, 66, 'US', '2025-04-22 21:54:02.636618', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1733, 11, 29, 67, 'US', '2025-04-22 21:54:07.05474', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1739, 11, 29, 68, 'US', '2025-04-22 21:54:09.869649', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1745, 11, 29, 69, 'US', '2025-04-22 21:54:12.240039', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1754, 11, 29, 67, 'US', '2025-04-22 21:59:21.687717', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1757, 11, 29, 64, 'US', '2025-04-22 22:05:22.773998', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1765, 11, 20, 70, 'US', '2025-04-22 22:06:22.016327', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1768, 11, 20, 69, 'US', '2025-04-22 22:11:55.9611', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1771, 11, 20, 68, 'US', '2025-04-22 22:16:42.360113', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1783, 11, 39, 70, 'US', '2025-04-22 22:34:30.777384', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1786, 11, 39, 70, 'US', '2025-04-22 22:35:08.076064', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1793, 11, 39, 70, 'US', '2025-04-26 20:05:32.160577', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1794, 20, 24, 52, 'US', '2025-04-26 20:07:20.013602', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1795, 20, 10, 46, 'US', '2025-04-26 20:09:34.785959', 'arcane');
INSERT INTO public.tracks_log VALUES (1807, 11, 39, 70, 'US', '2025-06-05 15:54:41.985091', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1810, 11, 39, 70, 'US', '2025-06-05 15:54:48.282353', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1826, 11, 17, 82, 'US', '2025-06-05 16:33:30.598628', 'mytracks');
INSERT INTO public.tracks_log VALUES (1827, 11, 16, 54, 'US', '2025-06-05 16:34:15.309793', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (1828, 11, 17, 87, 'US', '2025-06-05 16:34:16.987213', 'mytracks');
INSERT INTO public.tracks_log VALUES (1835, 11, 17, 86, 'US', '2025-06-05 16:54:56.415675', 'mytracks');
INSERT INTO public.tracks_log VALUES (1846, 11, 17, 84, 'US', '2025-06-05 17:20:10.60038', 'mytracks');
INSERT INTO public.tracks_log VALUES (1859, 11, 17, 84, 'US', '2025-06-05 18:17:51.626228', 'mytracks');
INSERT INTO public.tracks_log VALUES (567, 11, 10, 46, 'US', '2025-01-14 08:39:53.972596', 'arcane');
INSERT INTO public.tracks_log VALUES (568, 11, 10, 46, 'US', '2025-01-14 08:39:57.754567', 'arcane');
INSERT INTO public.tracks_log VALUES (569, 11, 10, 46, 'US', '2025-01-14 08:41:59.546894', 'arcane');
INSERT INTO public.tracks_log VALUES (570, 11, 10, 46, 'US', '2025-01-14 08:45:03.763407', 'arcane');
INSERT INTO public.tracks_log VALUES (571, 11, 10, 46, 'US', '2025-01-14 08:46:37.652689', 'arcane');
INSERT INTO public.tracks_log VALUES (572, 11, 10, 46, 'US', '2025-01-14 08:46:48.755272', 'arcane');
INSERT INTO public.tracks_log VALUES (573, 11, 10, 46, 'US', '2025-01-14 08:47:08.666554', 'arcane');
INSERT INTO public.tracks_log VALUES (574, 11, 10, 46, 'US', '2025-01-14 08:48:01.091968', 'arcane');
INSERT INTO public.tracks_log VALUES (575, 11, 10, 46, 'US', '2025-01-14 08:48:15.024635', 'arcane');
INSERT INTO public.tracks_log VALUES (576, 11, 10, 46, 'US', '2025-01-14 08:48:45.930005', 'arcane');
INSERT INTO public.tracks_log VALUES (577, 11, 10, 46, 'US', '2025-01-14 08:49:15.337868', 'arcane');
INSERT INTO public.tracks_log VALUES (578, 11, 10, 46, 'US', '2025-01-14 08:49:22.145088', 'arcane');
INSERT INTO public.tracks_log VALUES (579, 11, 10, 46, 'US', '2025-01-14 08:50:09.889813', 'arcane');
INSERT INTO public.tracks_log VALUES (580, 11, 10, 46, 'US', '2025-01-14 08:51:28.574435', 'arcane');
INSERT INTO public.tracks_log VALUES (581, 11, 10, 46, 'US', '2025-01-14 08:52:56.552142', 'arcane');
INSERT INTO public.tracks_log VALUES (582, 11, 10, 46, 'US', '2025-01-14 08:53:12.017249', 'arcane');
INSERT INTO public.tracks_log VALUES (583, 11, 10, 46, 'US', '2025-01-14 09:04:37.819397', 'arcane');
INSERT INTO public.tracks_log VALUES (584, 11, 10, 46, 'US', '2025-01-14 09:25:27.008226', 'arcane');
INSERT INTO public.tracks_log VALUES (585, 11, 10, 46, 'US', '2025-01-14 09:26:03.754834', 'arcane');
INSERT INTO public.tracks_log VALUES (586, 11, 10, 46, 'US', '2025-01-14 09:26:29.641924', 'arcane');
INSERT INTO public.tracks_log VALUES (587, 11, 10, 46, 'US', '2025-01-14 09:26:51.709233', 'arcane');
INSERT INTO public.tracks_log VALUES (588, 11, 10, 46, 'US', '2025-01-14 09:27:22.649045', 'arcane');
INSERT INTO public.tracks_log VALUES (589, 11, 10, 46, 'US', '2025-01-14 09:28:12.555121', 'arcane');
INSERT INTO public.tracks_log VALUES (590, 11, 10, 46, 'US', '2025-01-14 09:28:49.456085', 'arcane');
INSERT INTO public.tracks_log VALUES (591, 11, 10, 46, 'US', '2025-01-14 09:29:41.809471', 'arcane');
INSERT INTO public.tracks_log VALUES (592, 11, 10, 46, 'US', '2025-01-14 09:29:51.918825', 'arcane');
INSERT INTO public.tracks_log VALUES (593, 11, 10, 46, 'US', '2025-01-14 09:30:12.436119', 'arcane');
INSERT INTO public.tracks_log VALUES (594, 11, 10, 46, 'US', '2025-01-14 09:31:08.031604', 'arcane');
INSERT INTO public.tracks_log VALUES (595, 11, 10, 46, 'US', '2025-01-14 09:31:22.064346', 'arcane');
INSERT INTO public.tracks_log VALUES (596, 11, 10, 46, 'US', '2025-01-14 09:32:31.632823', 'arcane');
INSERT INTO public.tracks_log VALUES (597, 11, 10, 46, 'US', '2025-01-14 09:34:48.022339', 'arcane');
INSERT INTO public.tracks_log VALUES (598, 11, 10, 46, 'US', '2025-01-14 09:35:04.187154', 'arcane');
INSERT INTO public.tracks_log VALUES (599, 11, 10, 46, 'US', '2025-01-14 09:36:22.352035', 'arcane');
INSERT INTO public.tracks_log VALUES (600, 11, 10, 46, 'US', '2025-01-14 09:38:33.880477', 'arcane');
INSERT INTO public.tracks_log VALUES (601, 11, 10, 46, 'US', '2025-01-14 09:56:12.114761', 'arcane');
INSERT INTO public.tracks_log VALUES (602, 11, 10, 46, 'US', '2025-01-14 10:14:55.219235', 'arcane');
INSERT INTO public.tracks_log VALUES (603, 11, 10, 46, 'US', '2025-01-14 10:17:08.480615', 'arcane');
INSERT INTO public.tracks_log VALUES (604, 11, 10, 46, 'US', '2025-01-14 10:22:15.944103', 'arcane');
INSERT INTO public.tracks_log VALUES (605, 11, 10, 46, 'US', '2025-01-14 10:22:25.870525', 'arcane');
INSERT INTO public.tracks_log VALUES (606, 11, 10, 46, 'US', '2025-01-14 10:23:39.76392', 'arcane');
INSERT INTO public.tracks_log VALUES (607, 11, 10, 46, 'US', '2025-01-14 10:24:37.581109', 'arcane');
INSERT INTO public.tracks_log VALUES (608, 11, 10, 46, 'US', '2025-01-14 10:27:52.371144', 'arcane');
INSERT INTO public.tracks_log VALUES (609, 11, 10, 48, 'US', '2025-01-14 12:09:57.301579', 'arcane');
INSERT INTO public.tracks_log VALUES (610, 11, 10, 47, 'US', '2025-01-14 12:09:57.891192', 'arcane');
INSERT INTO public.tracks_log VALUES (611, 11, 10, 48, 'US', '2025-01-14 12:10:03.432919', 'arcane');
INSERT INTO public.tracks_log VALUES (612, 11, 10, 47, 'US', '2025-01-14 12:10:04.897345', 'arcane');
INSERT INTO public.tracks_log VALUES (613, 11, 10, 46, 'US', '2025-01-14 12:10:05.598229', 'arcane');
INSERT INTO public.tracks_log VALUES (614, 11, 10, 49, 'US', '2025-01-14 12:15:48.879443', 'arcane');
INSERT INTO public.tracks_log VALUES (615, 11, 10, 48, 'US', '2025-01-14 12:15:51.150332', 'arcane');
INSERT INTO public.tracks_log VALUES (616, 11, 10, 47, 'US', '2025-01-14 12:15:52.112348', 'arcane');
INSERT INTO public.tracks_log VALUES (617, 11, 24, 44, 'US', '2025-01-14 12:16:00.288223', 'my-playlist');
INSERT INTO public.tracks_log VALUES (618, 11, 24, 45, 'US', '2025-01-14 12:16:45.745669', 'my-playlist');
INSERT INTO public.tracks_log VALUES (619, 11, 24, 51, 'US', '2025-01-14 12:16:46.82337', 'my-playlist');
INSERT INTO public.tracks_log VALUES (620, 11, 24, 50, 'US', '2025-01-14 12:18:14.162096', 'my-playlist');
INSERT INTO public.tracks_log VALUES (621, 11, 24, 54, 'US', '2025-01-14 12:37:58.671376', 'my-playlist');
INSERT INTO public.tracks_log VALUES (622, 11, 24, 44, 'US', '2025-01-14 12:39:24.514482', 'my-playlist');
INSERT INTO public.tracks_log VALUES (623, 11, 24, 45, 'US', '2025-01-14 12:40:08.139491', 'my-playlist');
INSERT INTO public.tracks_log VALUES (624, 11, 24, 51, 'US', '2025-01-14 12:42:34.851888', 'my-playlist');
INSERT INTO public.tracks_log VALUES (625, 11, 24, 50, 'US', '2025-01-14 12:44:02.215355', 'my-playlist');
INSERT INTO public.tracks_log VALUES (626, 11, 24, 52, 'US', '2025-01-14 12:46:20.880092', 'my-playlist');
INSERT INTO public.tracks_log VALUES (627, 11, 24, 54, 'US', '2025-01-14 12:49:52.96272', 'my-playlist');
INSERT INTO public.tracks_log VALUES (628, 11, 24, 44, 'US', '2025-01-14 12:52:15.895189', 'my-playlist');
INSERT INTO public.tracks_log VALUES (629, 11, 24, 45, 'US', '2025-01-14 12:56:02.079642', 'my-playlist');
INSERT INTO public.tracks_log VALUES (630, 11, 24, 45, 'US', '2025-01-14 12:57:54.20382', 'my-playlist');
INSERT INTO public.tracks_log VALUES (631, 11, 24, 51, 'US', '2025-01-14 13:00:24.888285', 'my-playlist');
INSERT INTO public.tracks_log VALUES (632, 11, 24, 50, 'US', '2025-01-14 13:01:52.291978', 'my-playlist');
INSERT INTO public.tracks_log VALUES (633, 11, 24, 52, 'US', '2025-01-14 13:04:10.938866', 'my-playlist');
INSERT INTO public.tracks_log VALUES (634, 11, 24, 54, 'US', '2025-01-14 13:07:42.987939', 'my-playlist');
INSERT INTO public.tracks_log VALUES (635, 11, 24, 44, 'US', '2025-01-14 13:10:05.947586', 'my-playlist');
INSERT INTO public.tracks_log VALUES (638, 11, 24, 45, 'US', '2025-01-14 13:13:52.066507', 'my-playlist');
INSERT INTO public.tracks_log VALUES (639, 10, 10, 48, 'US', '2025-01-14 13:15:23.463344', 'arcane');
INSERT INTO public.tracks_log VALUES (640, 10, 24, 44, 'US', '2025-01-14 13:15:29.882737', 'my-playlist');
INSERT INTO public.tracks_log VALUES (641, 10, 24, 50, 'US', '2025-01-14 13:15:35.848492', 'my-playlist');
INSERT INTO public.tracks_log VALUES (642, 10, 24, 50, 'US', '2025-01-14 13:16:08.250367', 'my-playlist');
INSERT INTO public.tracks_log VALUES (643, 10, 16, 52, 'US', '2025-01-14 13:17:15.281343', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (644, 10, 16, 52, 'US', '2025-01-14 13:17:22.840196', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (645, 10, 16, 52, 'US', '2025-01-14 13:17:26.481578', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (646, 10, 14, 45, 'US', '2025-01-14 13:17:31.322507', 'heart-2');
INSERT INTO public.tracks_log VALUES (647, 10, 14, 49, 'US', '2025-01-14 13:17:36.957406', 'heart-2');
INSERT INTO public.tracks_log VALUES (648, 13, 24, 44, 'US', '2025-01-14 13:19:17.327536', 'my-playlist');
INSERT INTO public.tracks_log VALUES (649, 13, 24, 52, 'US', '2025-01-14 13:21:20.503396', 'my-playlist');
INSERT INTO public.tracks_log VALUES (650, 11, 20, 55, 'US', '2025-01-14 13:26:16.194182', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (651, 11, 20, 54, 'US', '2025-01-14 13:26:16.676397', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (652, 11, 20, 54, 'US', '2025-01-14 14:12:19.023279', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (653, 11, 20, 54, 'US', '2025-01-14 14:13:15.100847', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (654, 11, 20, 54, 'US', '2025-01-14 14:14:32.040878', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (655, 11, 20, 54, 'US', '2025-01-14 14:15:11.661293', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (656, 11, 20, 54, 'US', '2025-01-14 14:15:48.553583', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (657, 11, 20, 54, 'US', '2025-01-14 14:18:53.800704', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (658, 11, 20, 54, 'US', '2025-01-14 14:19:29.511247', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (659, 11, 20, 54, 'US', '2025-01-14 14:19:56.323135', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (660, 11, 20, 54, 'US', '2025-01-14 14:21:31.036248', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (661, 11, 20, 54, 'US', '2025-01-14 14:23:00.996387', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (662, 11, 20, 54, 'US', '2025-01-14 14:24:19.897109', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (663, 11, 20, 54, 'US', '2025-01-14 14:25:09.096655', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (664, 11, 20, 54, 'US', '2025-01-14 14:26:30.652392', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (665, 11, 20, 54, 'US', '2025-01-14 14:31:28.456145', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (666, 11, 20, 54, 'US', '2025-01-14 14:31:44.421062', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (667, 11, 20, 54, 'US', '2025-01-14 14:33:37.950843', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (668, 11, 20, 54, 'US', '2025-01-14 14:43:56.2356', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (669, 11, 20, 54, 'US', '2025-01-14 14:44:52.437722', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (670, 11, 20, 54, 'US', '2025-01-14 14:45:28.339584', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (671, 11, 20, 54, 'US', '2025-01-14 14:48:18.852632', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (672, 11, 20, 54, 'US', '2025-01-14 14:50:15.240649', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (673, 11, 20, 54, 'US', '2025-01-14 14:51:44.75442', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (674, 11, 20, 54, 'US', '2025-01-14 14:52:19.105666', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (675, 11, 20, 54, 'US', '2025-01-14 14:53:13.763281', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (676, 11, 20, 54, 'US', '2025-01-14 14:55:01.967437', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (677, 10, 14, 49, 'US', '2025-01-14 14:55:28.510627', 'heart-2');
INSERT INTO public.tracks_log VALUES (678, 11, 20, 54, 'US', '2025-01-14 14:57:28.398456', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (679, 11, 20, 54, 'US', '2025-01-14 15:01:12.98171', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (680, 11, 20, 54, 'US', '2025-01-14 15:02:35.834195', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (681, 11, 20, 54, 'US', '2025-01-14 15:12:38.535113', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (682, 11, 20, 54, 'US', '2025-01-14 15:14:01.332948', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (683, 11, 20, 54, 'US', '2025-01-14 15:15:34.503836', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (684, 11, 20, 54, 'US', '2025-01-14 15:38:47.002223', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (685, 11, 20, 54, 'US', '2025-01-14 15:40:39.319987', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (686, 11, 20, 54, 'US', '2025-01-14 15:43:09.640664', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (687, 11, 20, 54, 'US', '2025-01-14 15:46:34.857354', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (688, 11, 20, 54, 'US', '2025-01-14 15:47:44.836268', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (689, 11, 20, 54, 'US', '2025-01-14 15:48:39.394383', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (690, 11, 20, 54, 'US', '2025-01-14 15:49:24.68088', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (691, 11, 20, 54, 'US', '2025-01-14 15:51:49.320917', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (692, 11, 20, 54, 'US', '2025-01-14 15:52:56.36941', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (693, 11, 20, 54, 'US', '2025-01-14 15:53:07.277355', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (694, 11, 20, 54, 'US', '2025-01-14 15:53:38.178486', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (695, 11, 20, 54, 'US', '2025-01-14 15:54:26.63242', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (696, 11, 20, 54, 'US', '2025-01-14 15:55:19.628977', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (697, 11, 20, 54, 'US', '2025-01-14 15:56:45.077999', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (698, 11, 20, 54, 'US', '2025-01-14 15:58:00.298869', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (699, 11, 20, 54, 'US', '2025-01-14 15:59:43.60131', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (700, 11, 20, 54, 'US', '2025-01-14 16:01:22.802558', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (701, 11, 20, 54, 'US', '2025-01-14 16:03:21.38612', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (702, 11, 20, 54, 'US', '2025-01-14 16:03:29.65724', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (703, 11, 20, 54, 'US', '2025-01-14 16:07:37.164308', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (704, 11, 20, 54, 'US', '2025-01-14 16:08:58.379574', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (705, 11, 20, 54, 'US', '2025-01-14 16:13:43.822047', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (706, 11, 20, 54, 'US', '2025-01-14 16:13:58.94852', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (707, 11, 20, 54, 'US', '2025-01-14 16:56:26.254537', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (708, 11, 20, 54, 'US', '2025-01-14 16:56:30.117087', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (709, 11, 20, 54, 'US', '2025-01-14 16:56:32.541534', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (710, 11, 20, 54, 'US', '2025-01-14 16:56:39.287785', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (711, 11, 20, 54, 'US', '2025-01-14 16:56:56.98004', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (712, 11, 20, 54, 'US', '2025-01-14 16:58:32.869702', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (713, 11, 20, 54, 'US', '2025-01-14 17:04:36.92482', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (714, 11, 20, 54, 'US', '2025-01-14 17:19:27.311407', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (715, 11, 20, 54, 'US', '2025-01-14 17:19:51.988308', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (716, 11, 20, 54, 'US', '2025-01-14 17:22:22.372422', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (717, 11, 20, 54, 'US', '2025-01-14 17:22:35.100032', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (718, 11, 20, 54, 'US', '2025-01-14 17:27:14.516305', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (719, 11, 20, 54, 'US', '2025-01-14 17:27:22.566991', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (720, 11, 20, 54, 'US', '2025-01-14 17:29:30.763896', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (721, 11, 20, 54, 'US', '2025-01-14 17:30:03.380663', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (722, 11, 16, 54, 'US', '2025-01-14 17:31:38.623943', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (723, 11, 16, 54, 'US', '2025-01-14 18:13:57.823769', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (724, 11, 16, 54, 'US', '2025-01-14 18:14:27.979481', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (725, 11, 16, 54, 'US', '2025-01-14 18:14:53.773718', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (726, 11, 16, 54, 'US', '2025-01-14 18:15:33.673141', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (727, 11, 16, 54, 'US', '2025-01-14 18:16:30.22369', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (728, 11, 16, 54, 'US', '2025-01-14 18:18:30.993076', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (729, 11, 16, 54, 'US', '2025-01-14 18:18:33.882237', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (730, 11, 16, 54, 'US', '2025-01-14 18:18:34.565924', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (731, 11, 16, 54, 'US', '2025-01-14 18:24:35.054562', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (732, 11, 16, 54, 'US', '2025-01-14 18:25:23.936376', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (733, 11, 16, 54, 'US', '2025-01-14 18:25:31.740621', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (734, 11, 16, 54, 'US', '2025-01-14 18:26:19.094003', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (735, 11, 16, 54, 'US', '2025-01-14 18:28:15.454015', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (736, 11, 16, 54, 'US', '2025-01-14 18:29:47.114771', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (737, 11, 25, 54, 'US', '2025-01-14 18:30:54.357144', 'car-playlist');
INSERT INTO public.tracks_log VALUES (738, 11, 25, 54, 'US', '2025-01-14 18:31:16.467817', 'car-playlist');
INSERT INTO public.tracks_log VALUES (739, 11, 25, 54, 'US', '2025-01-14 18:31:20.095888', 'car-playlist');
INSERT INTO public.tracks_log VALUES (740, 11, 25, 54, 'US', '2025-01-14 18:33:01.49825', 'car-playlist');
INSERT INTO public.tracks_log VALUES (741, 11, 25, 54, 'US', '2025-01-14 18:33:07.209439', 'car-playlist');
INSERT INTO public.tracks_log VALUES (742, 11, 25, 54, 'US', '2025-01-14 18:33:42.088035', 'car-playlist');
INSERT INTO public.tracks_log VALUES (743, 11, 25, 54, 'US', '2025-01-14 18:34:03.93773', 'car-playlist');
INSERT INTO public.tracks_log VALUES (744, 11, 25, 54, 'US', '2025-01-14 18:34:24.875092', 'car-playlist');
INSERT INTO public.tracks_log VALUES (745, 14, 24, 44, 'US', '2025-01-14 18:41:08.00037', 'my-playlist');
INSERT INTO public.tracks_log VALUES (746, 14, 24, 45, 'US', '2025-01-14 18:41:37.177703', 'my-playlist');
INSERT INTO public.tracks_log VALUES (747, 10, 14, 49, 'US', '2025-01-14 18:41:48.638163', 'heart-2');
INSERT INTO public.tracks_log VALUES (748, 10, 25, 54, 'US', '2025-01-14 18:41:51.405107', 'car-playlist');
INSERT INTO public.tracks_log VALUES (749, 14, 24, 45, 'US', '2025-01-14 18:42:24.184833', 'my-playlist');
INSERT INTO public.tracks_log VALUES (750, 14, 24, 45, 'US', '2025-01-14 18:45:10.707846', 'my-playlist');
INSERT INTO public.tracks_log VALUES (751, 14, 24, 45, 'US', '2025-01-14 18:45:12.966775', 'my-playlist');
INSERT INTO public.tracks_log VALUES (752, 14, 24, 45, 'US', '2025-01-14 18:45:13.897564', 'my-playlist');
INSERT INTO public.tracks_log VALUES (753, 14, 24, 45, 'US', '2025-01-14 18:45:14.708099', 'my-playlist');
INSERT INTO public.tracks_log VALUES (754, 14, 24, 45, 'US', '2025-01-14 18:45:15.443515', 'my-playlist');
INSERT INTO public.tracks_log VALUES (755, 14, 24, 45, 'US', '2025-01-14 18:45:16.033436', 'my-playlist');
INSERT INTO public.tracks_log VALUES (756, 14, 17, 56, 'US', '2025-01-14 18:48:30.851929', 'mytracks');
INSERT INTO public.tracks_log VALUES (757, 14, 17, 56, 'US', '2025-01-14 18:53:07.464728', 'mytracks');
INSERT INTO public.tracks_log VALUES (758, 14, 17, 56, 'US', '2025-01-14 18:53:12.792083', 'mytracks');
INSERT INTO public.tracks_log VALUES (759, 14, 17, 56, 'US', '2025-01-14 18:53:13.009136', 'mytracks');
INSERT INTO public.tracks_log VALUES (760, 14, 17, 56, 'US', '2025-01-14 18:53:14.711132', 'mytracks');
INSERT INTO public.tracks_log VALUES (761, 14, 17, 57, 'US', '2025-01-14 18:53:15.764082', 'mytracks');
INSERT INTO public.tracks_log VALUES (762, 14, 17, 57, 'US', '2025-01-14 18:57:19.398101', 'mytracks');
INSERT INTO public.tracks_log VALUES (763, 14, 17, 58, 'US', '2025-01-14 18:57:20.418518', 'mytracks');
INSERT INTO public.tracks_log VALUES (764, 14, 17, 58, 'US', '2025-01-14 18:58:25.829347', 'mytracks');
INSERT INTO public.tracks_log VALUES (765, 14, 17, 58, 'US', '2025-01-14 18:59:07.284158', 'mytracks');
INSERT INTO public.tracks_log VALUES (766, 14, 17, 58, 'US', '2025-01-14 18:59:10.535277', 'mytracks');
INSERT INTO public.tracks_log VALUES (767, 14, 17, 59, 'US', '2025-01-14 19:00:28.798695', 'mytracks');
INSERT INTO public.tracks_log VALUES (768, 14, 17, 60, 'US', '2025-01-14 19:02:23.28607', 'mytracks');
INSERT INTO public.tracks_log VALUES (769, 14, 17, 60, 'US', '2025-01-14 19:04:53.45871', 'mytracks');
INSERT INTO public.tracks_log VALUES (770, 14, 17, 60, 'US', '2025-01-14 19:09:07.935505', 'mytracks');
INSERT INTO public.tracks_log VALUES (771, 14, 17, 60, 'US', '2025-01-14 19:09:31.975175', 'mytracks');
INSERT INTO public.tracks_log VALUES (772, 14, 17, 61, 'US', '2025-01-14 19:09:32.464924', 'mytracks');
INSERT INTO public.tracks_log VALUES (773, 10, 25, 54, 'US', '2025-01-14 19:11:15.464522', 'car-playlist');
INSERT INTO public.tracks_log VALUES (774, 10, 25, 54, 'US', '2025-01-14 19:11:20.836524', 'car-playlist');
INSERT INTO public.tracks_log VALUES (775, 14, 17, 60, 'US', '2025-01-14 19:12:07.645393', 'mytracks');
INSERT INTO public.tracks_log VALUES (776, 14, 17, 60, 'US', '2025-01-14 19:12:39.988478', 'mytracks');
INSERT INTO public.tracks_log VALUES (777, 14, 17, 62, 'US', '2025-01-14 19:12:40.570649', 'mytracks');
INSERT INTO public.tracks_log VALUES (778, 14, 17, 62, 'US', '2025-01-14 19:13:28.862176', 'mytracks');
INSERT INTO public.tracks_log VALUES (779, 14, 17, 63, 'US', '2025-01-14 19:13:29.881949', 'mytracks');
INSERT INTO public.tracks_log VALUES (780, 14, 17, 63, 'US', '2025-01-14 19:14:50.959339', 'mytracks');
INSERT INTO public.tracks_log VALUES (781, 14, 17, 65, 'US', '2025-01-14 19:14:52.304295', 'mytracks');
INSERT INTO public.tracks_log VALUES (782, 10, 25, 54, 'US', '2025-01-14 19:15:10.655938', 'car-playlist');
INSERT INTO public.tracks_log VALUES (783, 10, 25, 54, 'US', '2025-01-14 19:15:22.411341', 'car-playlist');
INSERT INTO public.tracks_log VALUES (784, 10, 26, 61, 'US', '2025-01-14 19:15:47.776812', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (785, 10, 26, 63, 'US', '2025-01-14 19:15:51.340967', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (786, 14, 17, 62, 'US', '2025-01-14 19:15:59.274101', 'mytracks');
INSERT INTO public.tracks_log VALUES (787, 10, 26, 65, 'US', '2025-01-14 19:18:56.354863', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (788, 10, 26, 65, 'US', '2025-01-14 19:19:30.155561', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (789, 10, 26, 65, 'US', '2025-01-14 19:21:53.265028', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (790, 10, 26, 65, 'US', '2025-01-14 19:22:01.638815', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (791, 10, 20, 65, 'US', '2025-01-14 19:22:21.552451', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (792, 10, 20, 63, 'US', '2025-01-14 19:22:28.765264', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (793, 10, 26, 63, 'US', '2025-01-14 21:24:22.220298', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (794, 10, 26, 65, 'US', '2025-01-14 21:36:41.755185', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (795, 10, 26, 62, 'US', '2025-01-14 21:36:49.842403', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (796, 10, 26, 63, 'US', '2025-01-14 21:37:07.830778', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (797, 10, 26, 61, 'US', '2025-01-14 21:37:09.636588', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (798, 10, 26, 57, 'US', '2025-01-14 21:37:11.98444', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (799, 10, 26, 56, 'US', '2025-01-14 21:37:16.121193', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (800, 10, 26, 65, 'US', '2025-01-14 21:38:42.103577', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (801, 10, 26, 61, 'US', '2025-01-14 21:38:53.233628', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (802, 10, 26, 63, 'US', '2025-01-14 21:38:55.849817', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (803, 10, 26, 65, 'US', '2025-01-14 21:38:57.061119', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (804, 10, 26, 62, 'US', '2025-01-14 21:38:58.110083', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (805, 10, 26, 62, 'US', '2025-01-14 21:39:12.525222', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (806, 10, 25, 54, 'US', '2025-01-14 21:39:43.478231', 'car-playlist');
INSERT INTO public.tracks_log VALUES (807, 10, 26, 63, 'US', '2025-01-14 21:40:35.182172', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (808, 10, 26, 65, 'US', '2025-01-14 21:40:37.339362', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (809, 10, 26, 63, 'US', '2025-01-14 21:40:39.726972', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (810, 10, 17, 64, 'US', '2025-01-14 22:26:03.684473', 'mytracks');
INSERT INTO public.tracks_log VALUES (811, 10, 20, 65, 'US', '2025-01-14 22:29:38.451938', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (812, 10, 20, 63, 'US', '2025-01-14 22:32:33.264807', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (813, 10, 20, 55, 'US', '2025-01-14 22:35:37.727192', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (814, 10, 20, 50, 'US', '2025-01-14 22:35:37.810288', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (815, 10, 20, 62, 'US', '2025-01-14 22:37:57.411694', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (816, 10, 20, 54, 'US', '2025-01-14 22:40:06.596001', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (817, 10, 20, 51, 'US', '2025-01-14 22:42:29.323299', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (818, 10, 20, 51, 'US', '2025-01-14 22:42:52.807893', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (819, 10, 20, 50, 'US', '2025-01-14 22:42:54.563532', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (820, 10, 20, 49, 'US', '2025-01-14 22:45:13.455852', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (821, 10, 20, 48, 'US', '2025-01-14 22:47:55.360494', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (822, 10, 20, 47, 'US', '2025-01-14 22:50:37.662872', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (823, 10, 20, 46, 'US', '2025-01-14 22:53:23.224725', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (824, 10, 20, 45, 'US', '2025-01-14 22:57:08.28953', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (825, 10, 20, 44, 'US', '2025-01-14 22:59:35.08619', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (826, 10, 20, 65, 'US', '2025-01-14 23:03:21.618226', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (827, 10, 20, 64, 'US', '2025-01-14 23:06:16.418315', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (828, 10, 20, 64, 'US', '2025-01-14 23:07:59.19618', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (829, 10, 20, 63, 'US', '2025-01-14 23:08:14.149109', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (830, 10, 20, 63, 'US', '2025-01-15 00:47:56.857132', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (831, 10, 20, 63, 'US', '2025-01-15 00:48:02.385558', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (832, 10, 20, 63, 'US', '2025-01-15 00:48:03.577509', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (833, 10, 20, 63, 'US', '2025-01-15 00:48:04.842748', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (834, 10, 20, 63, 'US', '2025-01-15 00:48:19.511087', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (835, 10, 20, 63, 'US', '2025-01-15 00:48:50.809354', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (836, 10, 20, 63, 'US', '2025-01-15 00:48:54.406091', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (837, 10, 20, 63, 'US', '2025-01-15 00:48:55.619573', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (838, 10, 17, 69, 'US', '2025-01-15 01:01:55.392323', 'mytracks');
INSERT INTO public.tracks_log VALUES (839, 10, 17, 68, 'US', '2025-01-15 01:02:05.851706', 'mytracks');
INSERT INTO public.tracks_log VALUES (840, 10, 17, 67, 'US', '2025-01-15 01:02:09.124989', 'mytracks');
INSERT INTO public.tracks_log VALUES (841, 10, 17, 66, 'US', '2025-01-15 01:02:12.106667', 'mytracks');
INSERT INTO public.tracks_log VALUES (842, 10, 17, 64, 'US', '2025-01-15 01:02:14.896996', 'mytracks');
INSERT INTO public.tracks_log VALUES (843, 10, 17, 52, 'US', '2025-01-15 01:02:15.959979', 'mytracks');
INSERT INTO public.tracks_log VALUES (844, 10, 17, 64, 'US', '2025-01-15 01:02:20.017445', 'mytracks');
INSERT INTO public.tracks_log VALUES (845, 10, 29, 64, 'US', '2025-01-15 01:02:44.519954', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (846, 10, 29, 66, 'US', '2025-01-15 01:02:47.666245', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (847, 10, 29, 67, 'US', '2025-01-15 01:02:48.016666', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (848, 10, 29, 68, 'US', '2025-01-15 01:02:48.500461', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (849, 10, 29, 69, 'US', '2025-01-15 01:02:48.940174', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (850, 10, 29, 64, 'US', '2025-01-15 01:02:49.406951', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (851, 10, 29, 66, 'US', '2025-01-15 01:02:49.870471', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (852, 10, 29, 67, 'US', '2025-01-15 01:02:50.333758', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (853, 10, 29, 68, 'US', '2025-01-15 01:02:50.880659', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (854, 10, 29, 69, 'US', '2025-01-15 01:02:51.356407', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (855, 10, 29, 64, 'US', '2025-01-15 01:02:51.801277', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (856, 10, 29, 66, 'US', '2025-01-15 01:02:52.216161', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (857, 10, 29, 67, 'US', '2025-01-15 01:02:52.717962', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (858, 10, 29, 68, 'US', '2025-01-15 01:02:53.152484', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (859, 10, 29, 69, 'US', '2025-01-15 01:02:53.670197', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (860, 10, 29, 64, 'US', '2025-01-15 01:02:54.16717', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (861, 10, 29, 66, 'US', '2025-01-15 01:02:54.618814', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (862, 10, 29, 67, 'US', '2025-01-15 01:02:55.070693', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (863, 10, 29, 68, 'US', '2025-01-15 01:02:55.466904', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (864, 10, 29, 66, 'US', '2025-01-15 01:02:56.259728', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (865, 10, 29, 66, 'US', '2025-01-15 01:02:56.391188', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (866, 10, 29, 66, 'US', '2025-01-15 01:02:56.536369', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (867, 10, 29, 66, 'US', '2025-01-15 01:02:56.67838', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (868, 10, 29, 66, 'US', '2025-01-15 01:02:56.804388', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (869, 10, 29, 64, 'US', '2025-01-15 01:02:57.08746', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (870, 10, 29, 64, 'US', '2025-01-15 01:02:57.252845', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (871, 10, 29, 64, 'US', '2025-01-15 01:02:57.397412', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (872, 10, 29, 64, 'US', '2025-01-15 01:02:57.535046', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (873, 10, 29, 64, 'US', '2025-01-15 01:02:57.676605', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (874, 10, 29, 68, 'US', '2025-01-15 01:02:58.129099', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (875, 10, 29, 68, 'US', '2025-01-15 01:02:58.296521', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (876, 10, 29, 68, 'US', '2025-01-15 01:02:58.464835', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (877, 10, 29, 68, 'US', '2025-01-15 01:02:58.603803', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (878, 10, 29, 69, 'US', '2025-01-15 01:02:58.974365', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (879, 10, 29, 69, 'US', '2025-01-15 01:02:59.104151', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (880, 10, 29, 69, 'US', '2025-01-15 01:02:59.25187', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (881, 10, 29, 64, 'US', '2025-01-15 01:03:06.620659', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (882, 10, 29, 64, 'US', '2025-01-15 01:03:19.606316', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (883, 10, 20, 63, 'US', '2025-01-15 01:03:22.755351', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (884, 10, 29, 64, 'US', '2025-01-15 01:03:30.912631', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (885, 10, 29, 64, 'US', '2025-01-15 01:03:33.506681', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (886, 10, 29, 64, 'US', '2025-01-15 01:03:54.508546', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (887, 10, 29, 64, 'US', '2025-01-15 01:05:06.88608', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (888, 10, 17, 68, 'US', '2025-01-15 01:05:27.337752', 'mytracks');
INSERT INTO public.tracks_log VALUES (889, 10, 30, 68, 'US', '2025-01-15 01:05:32.092507', 'playlist-example');
INSERT INTO public.tracks_log VALUES (890, 10, 27, 66, 'US', '2025-01-15 01:05:35.003829', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (891, 10, 28, 67, 'US', '2025-01-15 01:05:38.655772', 'amazing-playlist');
INSERT INTO public.tracks_log VALUES (892, 10, 28, 67, 'US', '2025-01-15 01:07:47.344287', 'amazing-playlist');
INSERT INTO public.tracks_log VALUES (893, 10, 17, 70, 'US', '2025-01-15 01:08:08.610197', 'mytracks');
INSERT INTO public.tracks_log VALUES (894, 10, 17, 69, 'US', '2025-01-15 01:10:54.81055', 'mytracks');
INSERT INTO public.tracks_log VALUES (895, 10, 17, 68, 'US', '2025-01-15 01:12:51.197147', 'mytracks');
INSERT INTO public.tracks_log VALUES (896, 10, 17, 70, 'US', '2025-01-15 01:12:53.363872', 'mytracks');
INSERT INTO public.tracks_log VALUES (897, 10, 17, 70, 'US', '2025-01-15 01:15:25.454914', 'mytracks');
INSERT INTO public.tracks_log VALUES (898, 10, 20, 63, 'US', '2025-01-15 01:15:27.472622', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (899, 10, 20, 63, 'US', '2025-01-15 01:15:29.450242', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (900, 10, 20, 63, 'US', '2025-01-15 01:15:37.275918', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (901, 10, 20, 63, 'US', '2025-01-15 01:15:42.939313', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (902, 10, 19, 70, 'US', '2025-01-15 01:15:44.202397', 'recentlyplayed_10');
INSERT INTO public.tracks_log VALUES (903, 10, 19, 70, 'US', '2025-01-15 01:15:59.672986', 'recentlyplayed_10');
INSERT INTO public.tracks_log VALUES (904, 10, 19, 63, 'US', '2025-01-15 01:18:49.087424', 'recentlyplayed_10');
INSERT INTO public.tracks_log VALUES (905, 10, 16, 63, 'US', '2025-01-15 01:19:13.072146', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (906, 10, 16, 65, 'US', '2025-01-15 01:21:56.361311', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (907, 10, 16, 70, 'US', '2025-01-15 01:24:51.121105', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (908, 10, 16, 63, 'US', '2025-01-15 01:27:37.053286', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (909, 10, 16, 65, 'US', '2025-01-15 01:30:41.497392', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (910, 10, 27, 65, 'US', '2025-01-15 01:32:35.902508', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (911, 10, 27, 70, 'US', '2025-01-15 01:32:38.176991', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (912, 10, 27, 65, 'US', '2025-01-15 01:35:24.258932', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (913, 10, 27, 63, 'US', '2025-01-15 01:38:19.03742', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (914, 10, 27, 63, 'US', '2025-01-15 01:39:00.272429', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (915, 10, 27, 63, 'US', '2025-01-15 01:42:56.481756', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (916, 10, 27, 70, 'US', '2025-01-15 01:42:58.472821', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (917, 10, 27, 65, 'US', '2025-01-15 01:45:44.396537', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (918, 10, 27, 65, 'US', '2025-01-15 01:46:26.886393', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (919, 10, 27, 65, 'US', '2025-01-15 01:57:51.796889', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (920, 10, 27, 63, 'US', '2025-01-15 01:57:55.129126', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (921, 10, 27, 70, 'US', '2025-01-15 01:57:56.200524', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (922, 10, 27, 65, 'US', '2025-01-15 02:00:42.202107', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (923, 10, 27, 65, 'US', '2025-01-15 02:01:53.731242', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (924, 10, 27, 63, 'US', '2025-01-15 02:01:56.930788', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (925, 10, 27, 70, 'US', '2025-01-15 02:01:58.677822', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (926, 10, 27, 65, 'US', '2025-01-15 02:04:44.583848', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (927, 10, 27, 70, 'US', '2025-01-15 02:05:38.423703', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (928, 10, 27, 65, 'US', '2025-01-15 02:08:24.348245', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (929, 10, 27, 63, 'US', '2025-01-15 02:11:19.109804', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (930, 10, 27, 70, 'US', '2025-01-15 02:14:23.543755', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (931, 10, 27, 65, 'US', '2025-01-15 02:17:09.471116', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (932, 10, 27, 63, 'US', '2025-01-15 02:20:04.237754', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (933, 10, 27, 70, 'US', '2025-01-15 02:22:07.259213', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (934, 10, 27, 65, 'US', '2025-01-15 02:22:07.867369', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (935, 10, 26, 62, 'US', '2025-01-15 02:22:10.310125', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (936, 10, 29, 64, 'US', '2025-01-15 02:22:15.009043', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (937, 10, 29, 66, 'US', '2025-01-15 02:22:16.702233', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (938, 10, 29, 67, 'US', '2025-01-15 02:22:17.484365', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (939, 10, 29, 68, 'US', '2025-01-15 02:22:18.359669', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (940, 10, 29, 69, 'US', '2025-01-15 02:22:19.126487', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (941, 10, 29, 64, 'US', '2025-01-15 02:22:20.251858', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (942, 10, 29, 66, 'US', '2025-01-15 02:25:42.798179', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (943, 10, 29, 67, 'US', '2025-01-15 02:27:46.996396', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (944, 10, 29, 68, 'US', '2025-01-15 02:30:40.56393', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (945, 10, 29, 69, 'US', '2025-01-15 02:32:54.771469', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (946, 10, 29, 64, 'US', '2025-01-15 02:34:55.586034', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (947, 10, 27, 64, 'US', '2025-01-15 02:36:05.707139', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (948, 10, 27, 65, 'US', '2025-01-15 02:40:07.050724', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (949, 10, 27, 63, 'US', '2025-01-15 02:43:01.836717', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (950, 10, 27, 70, 'US', '2025-01-15 02:46:05.995966', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (951, 10, 27, 64, 'US', '2025-01-15 02:48:51.9176', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (952, 10, 27, 65, 'US', '2025-01-15 02:52:14.192203', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (953, 10, 27, 63, 'US', '2025-01-15 02:55:08.950304', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (954, 10, 27, 70, 'US', '2025-01-15 02:58:14.761528', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (955, 10, 27, 64, 'US', '2025-01-15 03:01:00.716294', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (956, 10, 27, 65, 'US', '2025-01-15 03:04:23.272939', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (957, 10, 27, 63, 'US', '2025-01-15 03:07:18.048286', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (958, 10, 27, 70, 'US', '2025-01-15 03:10:22.497149', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (959, 10, 27, 64, 'US', '2025-01-15 03:13:08.424783', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (960, 10, 27, 65, 'US', '2025-01-15 03:16:30.98414', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (961, 10, 27, 63, 'US', '2025-01-15 03:19:25.767413', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (962, 10, 27, 70, 'US', '2025-01-15 03:22:30.224768', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (963, 10, 27, 64, 'US', '2025-01-15 03:25:16.154847', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (964, 10, 27, 65, 'US', '2025-01-15 03:28:38.726993', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (965, 10, 27, 63, 'US', '2025-01-15 03:31:33.489755', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (966, 10, 27, 70, 'US', '2025-01-15 03:34:37.936913', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (967, 10, 27, 64, 'US', '2025-01-15 03:37:23.870678', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (968, 10, 27, 65, 'US', '2025-01-15 03:40:46.429658', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (969, 10, 27, 63, 'US', '2025-01-15 03:43:41.182746', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (970, 10, 27, 70, 'US', '2025-01-15 03:46:45.627925', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (971, 10, 27, 64, 'US', '2025-01-15 03:49:31.564005', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (972, 10, 27, 65, 'US', '2025-01-15 03:52:54.138173', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (973, 10, 27, 63, 'US', '2025-01-15 03:55:48.905001', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (974, 10, 24, 44, 'US', '2025-01-15 03:57:26.253133', 'my-playlist');
INSERT INTO public.tracks_log VALUES (975, 10, 29, 64, 'US', '2025-01-15 03:57:36.545108', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (976, 10, 27, 70, 'US', '2025-01-15 03:57:44.424422', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (977, 10, 27, 64, 'US', '2025-01-15 04:00:30.349458', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (978, 10, 27, 65, 'US', '2025-01-15 04:03:53.086586', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (979, 10, 27, 63, 'US', '2025-01-15 04:06:47.848801', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (980, 10, 27, 70, 'US', '2025-01-15 04:09:52.292869', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (981, 10, 27, 64, 'US', '2025-01-15 04:12:38.223685', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (982, 10, 27, 65, 'US', '2025-01-15 04:16:00.787122', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (983, 10, 27, 63, 'US', '2025-01-15 04:18:55.561383', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (984, 10, 27, 70, 'US', '2025-01-15 04:22:00.017838', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (985, 10, 27, 64, 'US', '2025-01-15 04:24:45.990893', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (986, 10, 27, 65, 'US', '2025-01-15 04:28:08.612296', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (987, 10, 27, 63, 'US', '2025-01-15 04:35:34.367384', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (988, 10, 27, 70, 'US', '2025-01-15 04:35:35.55216', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (989, 10, 27, 64, 'US', '2025-01-15 04:38:21.488431', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (990, 10, 27, 65, 'US', '2025-01-15 04:41:44.050026', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (991, 11, 25, 54, 'US', '2025-01-15 04:43:26.834074', 'car-playlist');
INSERT INTO public.tracks_log VALUES (992, 11, 27, 64, 'US', '2025-01-15 04:43:56.883339', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (993, 11, 27, 70, 'US', '2025-01-15 04:43:57.703386', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (994, 11, 27, 64, 'US', '2025-01-15 04:46:43.648204', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (995, 11, 27, 65, 'US', '2025-01-15 04:50:06.208374', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (996, 11, 27, 63, 'US', '2025-01-15 04:53:00.965196', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (997, 11, 27, 70, 'US', '2025-01-15 04:56:05.444414', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (998, 11, 27, 64, 'US', '2025-01-15 04:58:51.372471', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (999, 11, 27, 65, 'US', '2025-01-15 05:02:13.913866', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1000, 11, 30, 68, 'US', '2025-01-15 05:40:22.249898', 'playlist-example');
INSERT INTO public.tracks_log VALUES (1001, 10, 27, 65, 'US', '2025-01-15 06:28:59.065011', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1002, 10, 27, 70, 'US', '2025-01-15 06:29:15.466832', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1003, 10, 27, 70, 'US', '2025-01-15 06:30:02.810846', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1004, 11, 30, 68, 'US', '2025-01-15 16:51:15.176799', 'playlist-example');
INSERT INTO public.tracks_log VALUES (1005, 11, 30, 68, 'US', '2025-01-16 09:16:28.897681', 'playlist-example');
INSERT INTO public.tracks_log VALUES (1006, 11, 10, 46, 'US', '2025-01-16 09:16:46.560099', 'arcane');
INSERT INTO public.tracks_log VALUES (1007, 11, 27, 70, 'US', '2025-01-16 09:16:51.851395', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1008, 11, 27, 70, 'US', '2025-01-16 09:18:15.824293', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1009, 11, 27, 70, 'US', '2025-01-16 16:41:24.518487', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1010, 11, 27, 70, 'US', '2025-01-16 16:41:36.226652', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1011, 11, 27, 70, 'US', '2025-01-16 16:41:38.600074', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1012, 11, 27, 70, 'US', '2025-01-16 16:42:29.569874', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1013, 11, 27, 64, 'US', '2025-01-16 16:45:16.100516', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1014, 11, 27, 64, 'US', '2025-01-16 16:45:50.656641', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1015, 11, 29, 64, 'US', '2025-01-16 16:46:14.193285', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1016, 11, 24, 44, 'US', '2025-01-16 16:46:16.757386', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1017, 11, 24, 44, 'US', '2025-01-16 16:46:36.440985', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1018, 11, 24, 44, 'US', '2025-01-16 16:47:06.967894', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1019, 11, 24, 44, 'US', '2025-01-16 16:47:09.70075', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1020, 11, 24, 44, 'US', '2025-01-16 16:47:10.56368', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1021, 11, 24, 44, 'US', '2025-01-16 16:47:12.645029', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1022, 11, 24, 44, 'US', '2025-01-16 23:16:15.734656', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1023, 11, 27, 64, 'US', '2025-01-16 23:16:18.387505', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1024, 11, 27, 70, 'US', '2025-01-16 23:16:23.865874', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1025, 11, 27, 70, 'US', '2025-01-16 23:18:31.845103', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1026, 11, 27, 63, 'US', '2025-01-16 23:18:48.905166', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1027, 11, 27, 63, 'US', '2025-01-19 19:50:43.723515', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1028, 11, 27, 65, 'US', '2025-01-19 19:50:47.190162', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1029, 11, 27, 64, 'US', '2025-01-19 19:50:47.777428', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1030, 11, 27, 70, 'US', '2025-01-19 19:50:48.432706', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1031, 11, 27, 64, 'US', '2025-01-19 19:53:34.078751', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1032, 11, 27, 65, 'US', '2025-01-19 19:53:34.672538', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1033, 11, 27, 63, 'US', '2025-01-19 19:53:35.518217', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1034, 11, 27, 63, 'US', '2025-01-23 00:23:25.46414', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1035, 11, 27, 70, 'US', '2025-01-23 00:26:32.608614', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1036, 11, 27, 64, 'US', '2025-01-23 00:29:18.465612', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1037, 11, 27, 65, 'US', '2025-01-23 00:32:40.747449', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1038, 11, 27, 63, 'US', '2025-01-23 00:35:37.230439', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1039, 11, 25, 54, 'US', '2025-01-23 00:35:45.245608', 'car-playlist');
INSERT INTO public.tracks_log VALUES (1040, 11, 20, 69, 'US', '2025-01-23 00:35:51.84551', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1041, 11, 20, 68, 'US', '2025-01-23 00:37:51.457408', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1042, 11, 20, 67, 'US', '2025-01-23 00:40:03.491571', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1043, 11, 20, 66, 'US', '2025-01-23 00:42:54.625477', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1044, 11, 20, 65, 'US', '2025-01-23 00:45:00.193154', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1045, 11, 20, 65, 'US', '2025-01-23 12:06:05.295248', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1046, 11, 20, 65, 'US', '2025-01-23 13:03:38.383842', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1047, 11, 29, 64, 'US', '2025-01-23 13:03:41.526913', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1048, 11, 29, 64, 'US', '2025-01-23 13:39:15.363961', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1049, 11, 29, 67, 'US', '2025-01-23 13:41:27.579296', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1050, 11, 29, 64, 'US', '2025-01-23 13:41:30.625995', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1051, 11, 29, 64, 'US', '2025-01-23 13:41:49.870092', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1052, 11, 29, 64, 'US', '2025-01-23 13:42:40.954316', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1053, 11, 29, 64, 'US', '2025-01-23 14:07:26.832781', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1054, 11, 29, 64, 'US', '2025-01-23 17:30:09.321303', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1055, 10, 27, 70, 'US', '2025-01-23 17:32:16.603028', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1056, 10, 27, 70, 'US', '2025-01-23 17:32:33.025093', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1057, 10, 27, 70, 'US', '2025-01-23 17:33:40.592602', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1058, 10, 27, 70, 'US', '2025-01-23 17:33:44.897542', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1059, 10, 27, 70, 'US', '2025-01-23 17:34:05.081032', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1060, 10, 27, 70, 'US', '2025-01-25 18:27:19.539067', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1061, 10, 27, 70, 'US', '2025-01-25 18:29:45.593727', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1062, 10, 27, 70, 'US', '2025-01-25 18:31:26.84166', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1063, 10, 27, 70, 'US', '2025-01-29 13:28:35.116591', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1064, 10, 27, 70, 'US', '2025-02-06 00:03:06.275644', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1065, 10, 27, 70, 'US', '2025-02-06 00:03:40.185426', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1066, 10, 17, 69, 'US', '2025-02-06 00:04:27.826105', 'mytracks');
INSERT INTO public.tracks_log VALUES (1067, 10, 17, 69, 'US', '2025-02-06 00:05:53.737813', 'mytracks');
INSERT INTO public.tracks_log VALUES (1068, 10, 17, 69, 'US', '2025-02-06 00:06:13.304233', 'mytracks');
INSERT INTO public.tracks_log VALUES (1069, 10, 17, 69, 'US', '2025-02-06 00:06:26.599756', 'mytracks');
INSERT INTO public.tracks_log VALUES (1070, 10, 26, 65, 'US', '2025-02-06 00:06:28.639776', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1071, 10, 26, 63, 'US', '2025-02-06 00:06:32.84809', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1072, 10, 26, 63, 'US', '2025-02-06 00:08:26.970476', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1073, 10, 26, 61, 'US', '2025-02-06 00:08:36.946502', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1074, 10, 26, 62, 'US', '2025-02-06 00:08:38.511338', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1075, 10, 26, 65, 'US', '2025-02-06 00:08:39.797632', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1076, 10, 26, 63, 'US', '2025-02-06 00:08:41.865194', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1077, 10, 17, 70, 'US', '2025-02-06 00:08:53.408435', 'mytracks');
INSERT INTO public.tracks_log VALUES (1078, 10, 17, 44, 'US', '2025-02-06 00:09:03.442896', 'mytracks');
INSERT INTO public.tracks_log VALUES (1079, 10, 17, 70, 'US', '2025-02-06 00:09:04.295028', 'mytracks');
INSERT INTO public.tracks_log VALUES (1080, 10, 17, 70, 'US', '2025-02-06 00:09:05.816358', 'mytracks');
INSERT INTO public.tracks_log VALUES (1081, 10, 17, 70, 'US', '2025-02-06 00:09:06.779309', 'mytracks');
INSERT INTO public.tracks_log VALUES (1082, 10, 17, 68, 'US', '2025-02-06 00:09:08.209077', 'mytracks');
INSERT INTO public.tracks_log VALUES (1083, 10, 17, 67, 'US', '2025-02-06 00:09:11.537152', 'mytracks');
INSERT INTO public.tracks_log VALUES (1084, 10, 17, 66, 'US', '2025-02-06 00:09:17.333429', 'mytracks');
INSERT INTO public.tracks_log VALUES (1085, 10, 17, 45, 'US', '2025-02-06 00:09:19.371241', 'mytracks');
INSERT INTO public.tracks_log VALUES (1086, 10, 17, 49, 'US', '2025-02-06 00:09:19.891854', 'mytracks');
INSERT INTO public.tracks_log VALUES (1087, 10, 17, 46, 'US', '2025-02-06 00:09:20.610085', 'mytracks');
INSERT INTO public.tracks_log VALUES (1088, 10, 17, 50, 'US', '2025-02-06 00:09:21.219578', 'mytracks');
INSERT INTO public.tracks_log VALUES (1089, 10, 17, 46, 'US', '2025-02-06 00:09:21.634283', 'mytracks');
INSERT INTO public.tracks_log VALUES (1090, 10, 17, 44, 'US', '2025-02-06 00:09:22.220761', 'mytracks');
INSERT INTO public.tracks_log VALUES (1091, 10, 17, 45, 'US', '2025-02-06 00:09:22.908329', 'mytracks');
INSERT INTO public.tracks_log VALUES (1092, 10, 28, 67, 'US', '2025-02-06 00:09:24.633471', 'amazing-playlist');
INSERT INTO public.tracks_log VALUES (1093, 10, 28, 67, 'US', '2025-02-06 00:09:47.066777', 'amazing-playlist');
INSERT INTO public.tracks_log VALUES (1094, 10, 28, 67, 'US', '2025-02-06 00:10:02.364325', 'amazing-playlist');
INSERT INTO public.tracks_log VALUES (1095, 10, 24, 44, 'US', '2025-02-06 00:10:22.055245', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1096, 10, 24, 44, 'US', '2025-02-06 00:10:34.787597', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1097, 10, 24, 45, 'US', '2025-02-06 00:10:39.623587', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1098, 10, 30, 68, 'US', '2025-02-06 00:11:22.37077', 'playlist-example');
INSERT INTO public.tracks_log VALUES (1099, 10, 30, 68, 'US', '2025-02-06 00:11:26.417848', 'playlist-example');
INSERT INTO public.tracks_log VALUES (1100, 10, 16, 65, 'US', '2025-02-06 00:11:27.319571', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1101, 10, 16, 70, 'US', '2025-02-06 00:11:27.826336', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1102, 10, 16, 63, 'US', '2025-02-06 00:11:28.128427', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1103, 10, 16, 70, 'US', '2025-02-06 00:11:28.43807', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1104, 10, 16, 65, 'US', '2025-02-06 00:11:28.573173', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1105, 10, 16, 70, 'US', '2025-02-06 00:11:28.885589', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1106, 10, 16, 63, 'US', '2025-02-06 00:11:29.09845', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1107, 10, 16, 70, 'US', '2025-02-06 00:11:29.34047', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1108, 10, 16, 65, 'US', '2025-02-06 00:11:29.56071', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1109, 10, 16, 70, 'US', '2025-02-06 00:11:29.747095', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1110, 10, 16, 63, 'US', '2025-02-06 00:11:29.960087', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1111, 10, 16, 70, 'US', '2025-02-06 00:11:30.227528', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1112, 10, 16, 65, 'US', '2025-02-06 00:11:30.435756', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1113, 10, 16, 65, 'US', '2025-02-06 00:11:31.07566', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1114, 10, 16, 70, 'US', '2025-02-06 00:11:31.314284', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1115, 10, 16, 63, 'US', '2025-02-06 00:11:31.503316', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1116, 10, 16, 70, 'US', '2025-02-06 00:11:31.719618', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1117, 10, 16, 65, 'US', '2025-02-06 00:11:31.887695', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1118, 10, 16, 63, 'US', '2025-02-06 00:11:33.125527', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1119, 10, 16, 70, 'US', '2025-02-06 00:11:33.291489', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1120, 10, 16, 63, 'US', '2025-02-06 00:11:33.998158', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1121, 10, 16, 65, 'US', '2025-02-06 00:11:34.117934', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1122, 10, 16, 70, 'US', '2025-02-06 00:11:35.086392', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1123, 10, 16, 63, 'US', '2025-02-06 00:11:36.198872', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1124, 10, 16, 65, 'US', '2025-02-06 00:11:36.37464', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1125, 10, 16, 70, 'US', '2025-02-06 00:11:36.598092', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1126, 10, 16, 63, 'US', '2025-02-06 00:11:36.684252', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1127, 10, 16, 65, 'US', '2025-02-06 00:11:37.465882', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1128, 10, 16, 63, 'US', '2025-02-06 00:11:37.833991', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1129, 10, 20, 70, 'US', '2025-02-06 00:12:16.272538', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1130, 10, 20, 70, 'US', '2025-02-06 00:35:32.151675', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1131, 10, 17, 70, 'US', '2025-02-06 00:35:36.243194', 'mytracks');
INSERT INTO public.tracks_log VALUES (1132, 10, 17, 69, 'US', '2025-02-06 00:40:09.802882', 'mytracks');
INSERT INTO public.tracks_log VALUES (1133, 10, 17, 69, 'US', '2025-02-06 06:32:34.35341', 'mytracks');
INSERT INTO public.tracks_log VALUES (1134, 10, 17, 69, 'US', '2025-02-06 21:55:26.909533', 'mytracks');
INSERT INTO public.tracks_log VALUES (1135, 10, 17, 69, 'US', '2025-02-06 22:12:30.703638', 'mytracks');
INSERT INTO public.tracks_log VALUES (1136, 10, 17, 70, 'US', '2025-02-06 22:18:55.207262', 'mytracks');
INSERT INTO public.tracks_log VALUES (1137, 10, 17, 69, 'US', '2025-02-06 22:21:42.488195', 'mytracks');
INSERT INTO public.tracks_log VALUES (1138, 10, 17, 69, 'US', '2025-02-06 22:38:53.980345', 'mytracks');
INSERT INTO public.tracks_log VALUES (1139, 10, 28, 67, 'US', '2025-02-06 22:43:45.509402', 'amazing-playlist');
INSERT INTO public.tracks_log VALUES (1140, 10, 28, 52, 'US', '2025-02-06 22:43:48.578879', 'amazing-playlist');
INSERT INTO public.tracks_log VALUES (1141, 10, 28, 52, 'US', '2025-02-06 22:47:50.701208', 'amazing-playlist');
INSERT INTO public.tracks_log VALUES (1142, 10, 28, 52, 'US', '2025-02-06 23:00:43.816315', 'amazing-playlist');
INSERT INTO public.tracks_log VALUES (1143, 10, 10, 46, 'US', '2025-02-06 23:03:26.06062', 'arcane');
INSERT INTO public.tracks_log VALUES (1144, 10, 24, 44, 'US', '2025-02-06 23:03:29.030005', 'my-playlist');
INSERT INTO public.tracks_log VALUES (1145, 10, 26, 62, 'US', '2025-02-06 23:03:34.598164', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1146, 10, 26, 61, 'US', '2025-02-06 23:24:54.845089', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1147, 10, 27, 64, 'US', '2025-02-06 23:25:16.876905', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1148, 10, 27, 64, 'US', '2025-02-06 23:26:31.130636', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1149, 10, 27, 64, 'US', '2025-02-07 06:47:33.755914', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1150, 10, 27, 64, 'US', '2025-02-07 06:52:45.728229', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1151, 16, 17, 72, 'US', '2025-02-07 08:29:23.853893', 'mytracks');
INSERT INTO public.tracks_log VALUES (1152, 16, 17, 72, 'US', '2025-02-07 08:31:22.420179', 'mytracks');
INSERT INTO public.tracks_log VALUES (1153, 16, 17, 72, 'US', '2025-02-07 08:32:06.065235', 'mytracks');
INSERT INTO public.tracks_log VALUES (1154, 16, 17, 72, 'US', '2025-02-07 08:32:08.29431', 'mytracks');
INSERT INTO public.tracks_log VALUES (1155, 16, 17, 72, 'US', '2025-02-07 08:32:20.742139', 'mytracks');
INSERT INTO public.tracks_log VALUES (1156, 16, 17, 72, 'US', '2025-02-07 08:32:26.688936', 'mytracks');
INSERT INTO public.tracks_log VALUES (1157, 10, 27, 64, 'US', '2025-02-07 08:38:01.761648', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1158, 10, 27, 64, 'US', '2025-02-07 08:42:42.332963', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1159, 10, 27, 64, 'US', '2025-02-12 07:30:57.9732', 'cool-playlist');
INSERT INTO public.tracks_log VALUES (1160, 10, 17, 73, 'US', '2025-02-12 07:32:31.184011', 'mytracks');
INSERT INTO public.tracks_log VALUES (1161, 10, 17, 51, 'US', '2025-02-12 07:32:40.669797', 'mytracks');
INSERT INTO public.tracks_log VALUES (1162, 10, 17, 51, 'US', '2025-02-12 07:33:30.273724', 'mytracks');
INSERT INTO public.tracks_log VALUES (1163, 10, 17, 51, 'US', '2025-02-12 07:36:38.686486', 'mytracks');
INSERT INTO public.tracks_log VALUES (1164, 10, 17, 51, 'US', '2025-02-15 16:05:44.713371', 'mytracks');
INSERT INTO public.tracks_log VALUES (1165, 17, 20, 73, 'US', '2025-03-15 13:22:31.527548', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1166, 17, 20, 73, 'US', '2025-03-15 13:22:54.063126', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1167, 10, 17, 51, 'US', '2025-04-14 08:59:45.613099', 'mytracks');
INSERT INTO public.tracks_log VALUES (1168, 10, 29, 64, 'US', '2025-04-14 09:00:23.786274', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1169, 10, 29, 64, 'US', '2025-04-14 09:00:41.809039', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1170, 10, 16, 67, 'US', '2025-04-14 09:00:43.709079', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1171, 10, 16, 70, 'US', '2025-04-14 09:00:49.729095', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1172, 10, 16, 65, 'US', '2025-04-14 09:01:08.007322', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1173, 10, 26, 61, 'US', '2025-04-14 09:04:34.759629', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1174, 10, 30, 68, 'US', '2025-04-14 09:05:37.242019', 'playlist-example');
INSERT INTO public.tracks_log VALUES (1175, 10, 17, 73, 'US', '2025-04-14 09:06:47.41087', 'mytracks');
INSERT INTO public.tracks_log VALUES (1176, 10, 17, 71, 'US', '2025-04-14 09:06:51.227364', 'mytracks');
INSERT INTO public.tracks_log VALUES (1177, 10, 17, 73, 'US', '2025-04-14 09:06:53.397134', 'mytracks');
INSERT INTO public.tracks_log VALUES (1178, 10, 17, 71, 'US', '2025-04-14 09:08:57.617783', 'mytracks');
INSERT INTO public.tracks_log VALUES (1179, 10, 17, 71, 'US', '2025-04-14 09:14:04.58591', 'mytracks');
INSERT INTO public.tracks_log VALUES (1180, 10, 30, 68, 'US', '2025-04-14 09:14:07.748223', 'playlist-example');
INSERT INTO public.tracks_log VALUES (1181, 10, 26, 62, 'US', '2025-04-14 09:14:09.162067', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1182, 10, 26, 61, 'US', '2025-04-14 09:15:51.241319', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1183, 10, 26, 61, 'US', '2025-04-14 09:22:26.047359', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1184, 10, 26, 63, 'US', '2025-04-14 09:22:32.682754', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1185, 10, 26, 65, 'US', '2025-04-14 09:22:40.220494', 'sbornikhydshihpesenintheworld');
INSERT INTO public.tracks_log VALUES (1186, 10, 17, 74, 'US', '2025-04-14 09:23:20.696782', 'mytracks');
INSERT INTO public.tracks_log VALUES (1187, 10, 17, 73, 'US', '2025-04-14 09:24:33.704521', 'mytracks');
INSERT INTO public.tracks_log VALUES (1188, 10, 17, 73, 'US', '2025-04-14 09:26:16.528273', 'mytracks');
INSERT INTO public.tracks_log VALUES (1189, 10, 17, 73, 'US', '2025-04-14 09:27:24.495891', 'mytracks');
INSERT INTO public.tracks_log VALUES (1190, 10, 17, 73, 'US', '2025-04-14 09:27:50.934454', 'mytracks');
INSERT INTO public.tracks_log VALUES (1191, 10, 17, 75, 'US', '2025-04-14 09:27:51.426193', 'mytracks');
INSERT INTO public.tracks_log VALUES (1192, 10, 17, 73, 'US', '2025-04-14 09:50:46.090446', 'mytracks');
INSERT INTO public.tracks_log VALUES (1193, 10, 17, 71, 'US', '2025-04-14 09:50:48.096941', 'mytracks');
INSERT INTO public.tracks_log VALUES (1194, 10, 17, 70, 'US', '2025-04-14 09:50:48.990189', 'mytracks');
INSERT INTO public.tracks_log VALUES (1195, 10, 17, 71, 'US', '2025-04-14 09:50:56.125829', 'mytracks');
INSERT INTO public.tracks_log VALUES (1196, 10, 17, 70, 'US', '2025-04-14 09:50:59.013181', 'mytracks');
INSERT INTO public.tracks_log VALUES (1197, 10, 17, 69, 'US', '2025-04-14 09:51:45.375531', 'mytracks');
INSERT INTO public.tracks_log VALUES (1198, 10, 17, 68, 'US', '2025-04-14 09:51:54.273697', 'mytracks');
INSERT INTO public.tracks_log VALUES (1199, 10, 17, 67, 'US', '2025-04-14 09:52:29.452663', 'mytracks');
INSERT INTO public.tracks_log VALUES (1200, 10, 17, 66, 'US', '2025-04-14 09:52:30.743362', 'mytracks');
INSERT INTO public.tracks_log VALUES (1201, 10, 17, 64, 'US', '2025-04-14 09:52:34.753884', 'mytracks');
INSERT INTO public.tracks_log VALUES (1202, 10, 16, 67, 'US', '2025-04-14 09:54:21.560236', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1203, 10, 16, 67, 'US', '2025-04-14 09:55:06.209519', 'likedtracks_10');
INSERT INTO public.tracks_log VALUES (1204, 10, 29, 64, 'US', '2025-04-14 09:55:49.819939', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1205, 10, 29, 66, 'US', '2025-04-14 09:55:55.318455', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1206, 10, 29, 67, 'US', '2025-04-14 09:55:56.465907', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1207, 10, 29, 68, 'US', '2025-04-14 09:55:57.964957', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1208, 10, 29, 69, 'US', '2025-04-14 09:55:59.739888', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1209, 10, 17, 76, 'US', '2025-04-14 09:56:27.293729', 'mytracks');
INSERT INTO public.tracks_log VALUES (1210, 10, 17, 76, 'US', '2025-04-14 09:56:56.476871', 'mytracks');
INSERT INTO public.tracks_log VALUES (1211, 10, 17, 77, 'US', '2025-04-14 09:56:56.988972', 'mytracks');
INSERT INTO public.tracks_log VALUES (1212, 10, 17, 77, 'US', '2025-04-14 09:57:29.205726', 'mytracks');
INSERT INTO public.tracks_log VALUES (1213, 10, 17, 78, 'US', '2025-04-14 09:57:29.7778', 'mytracks');
INSERT INTO public.tracks_log VALUES (1214, 10, 10, 46, 'US', '2025-04-14 09:58:55.338076', 'arcane');
INSERT INTO public.tracks_log VALUES (1215, 10, 29, 66, 'US', '2025-04-14 09:59:00.211235', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1216, 10, 29, 67, 'US', '2025-04-14 09:59:01.448338', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1217, 10, 29, 68, 'US', '2025-04-14 09:59:30.239224', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1218, 10, 29, 67, 'US', '2025-04-14 09:59:31.740444', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1219, 10, 29, 66, 'US', '2025-04-14 09:59:32.491208', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1220, 10, 29, 64, 'US', '2025-04-14 09:59:33.2627', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1221, 10, 29, 69, 'US', '2025-04-14 09:59:33.976783', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1222, 10, 29, 67, 'US', '2025-04-14 09:59:34.479313', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1223, 10, 29, 68, 'US', '2025-04-14 09:59:35.301698', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1224, 18, 29, 66, 'US', '2025-04-14 11:25:23.583577', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1225, 18, 29, 64, 'US', '2025-04-14 11:26:07.898689', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1226, 18, 29, 66, 'US', '2025-04-14 11:26:15.706515', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1227, 18, 29, 67, 'US', '2025-04-14 11:26:21.859865', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1228, 18, 29, 69, 'US', '2025-04-14 11:26:22.731451', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1229, 18, 29, 68, 'US', '2025-04-14 11:26:23.687649', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1230, 18, 29, 64, 'US', '2025-04-14 11:26:24.841566', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1231, 18, 29, 64, 'US', '2025-04-14 11:27:21.297297', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1232, 18, 16, 66, 'US', '2025-04-14 11:27:39.84379', 'likedtracks_18');
INSERT INTO public.tracks_log VALUES (1233, 18, 16, 66, 'US', '2025-04-14 11:28:32.861839', 'likedtracks_18');
INSERT INTO public.tracks_log VALUES (1234, 18, 36, 64, 'US', '2025-04-14 11:28:41.706098', 'test1');
INSERT INTO public.tracks_log VALUES (1235, 18, 36, 64, 'US', '2025-04-14 11:30:25.521661', 'test1');
INSERT INTO public.tracks_log VALUES (1236, 18, 36, 64, 'US', '2025-04-14 11:30:47.100555', 'test1');
INSERT INTO public.tracks_log VALUES (1237, 18, 36, 64, 'US', '2025-04-14 11:32:17.722411', 'test1');
INSERT INTO public.tracks_log VALUES (1238, 18, 17, 79, 'US', '2025-04-14 11:32:57.384757', 'mytracks');
INSERT INTO public.tracks_log VALUES (1239, 18, 17, 79, 'US', '2025-04-14 11:33:42.121614', 'mytracks');
INSERT INTO public.tracks_log VALUES (1240, 18, 29, 64, 'US', '2025-04-14 11:34:51.94857', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1241, 19, 37, 66, 'US', '2025-04-14 12:39:15.525347', 'admin2');
INSERT INTO public.tracks_log VALUES (1242, 19, 37, 64, 'US', '2025-04-14 12:39:25.218173', 'admin2');
INSERT INTO public.tracks_log VALUES (1243, 19, 37, 64, 'US', '2025-04-14 12:39:25.227609', 'admin2');
INSERT INTO public.tracks_log VALUES (1244, 19, 37, 66, 'US', '2025-04-14 12:39:25.234218', 'admin2');
INSERT INTO public.tracks_log VALUES (1245, 19, 37, 66, 'US', '2025-04-14 12:39:25.242774', 'admin2');
INSERT INTO public.tracks_log VALUES (1246, 19, 37, 66, 'US', '2025-04-14 12:39:28.552331', 'admin2');
INSERT INTO public.tracks_log VALUES (1247, 19, 37, 64, 'US', '2025-04-14 12:39:32.161172', 'admin2');
INSERT INTO public.tracks_log VALUES (1248, 19, 37, 66, 'US', '2025-04-14 12:39:47.451355', 'admin2');
INSERT INTO public.tracks_log VALUES (1249, 19, 16, 66, 'US', '2025-04-14 12:39:59.477247', 'likedtracks_19');
INSERT INTO public.tracks_log VALUES (1250, 19, 17, 81, 'US', '2025-04-14 12:40:34.39146', 'mytracks');
INSERT INTO public.tracks_log VALUES (1251, 19, 17, 81, 'US', '2025-04-14 12:40:57.670487', 'mytracks');
INSERT INTO public.tracks_log VALUES (1252, 19, 17, 81, 'US', '2025-04-14 12:40:59.014464', 'mytracks');
INSERT INTO public.tracks_log VALUES (1253, 19, 17, 81, 'US', '2025-04-14 12:41:00.708228', 'mytracks');
INSERT INTO public.tracks_log VALUES (1254, 19, 17, 81, 'US', '2025-04-14 12:41:01.84239', 'mytracks');
INSERT INTO public.tracks_log VALUES (1255, 19, 17, 81, 'US', '2025-04-14 12:41:53.417783', 'mytracks');
INSERT INTO public.tracks_log VALUES (1256, 18, 29, 64, 'US', '2025-04-14 12:42:46.536289', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1257, 18, 29, 64, 'US', '2025-04-14 12:44:44.725366', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1258, 11, 29, 64, 'US', '2025-04-22 21:51:30.037342', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1259, 11, 29, 66, 'US', '2025-04-22 21:51:30.390488', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1260, 11, 29, 67, 'US', '2025-04-22 21:51:30.792035', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1261, 11, 29, 68, 'US', '2025-04-22 21:51:30.949573', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1262, 11, 29, 69, 'US', '2025-04-22 21:51:31.306836', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1263, 11, 29, 64, 'US', '2025-04-22 21:51:31.708283', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1264, 11, 29, 66, 'US', '2025-04-22 21:51:31.875532', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1265, 11, 29, 67, 'US', '2025-04-22 21:51:32.041088', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1266, 11, 29, 68, 'US', '2025-04-22 21:51:32.394527', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1267, 11, 29, 69, 'US', '2025-04-22 21:51:32.559315', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1268, 11, 29, 64, 'US', '2025-04-22 21:51:32.724635', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1269, 11, 29, 66, 'US', '2025-04-22 21:51:32.889057', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1270, 11, 29, 67, 'US', '2025-04-22 21:51:33.075629', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1271, 11, 29, 68, 'US', '2025-04-22 21:51:33.401725', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1272, 11, 29, 69, 'US', '2025-04-22 21:51:33.579114', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1273, 11, 29, 64, 'US', '2025-04-22 21:51:33.739707', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1274, 11, 29, 66, 'US', '2025-04-22 21:51:33.900544', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1275, 11, 29, 67, 'US', '2025-04-22 21:51:34.058252', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1276, 11, 29, 68, 'US', '2025-04-22 21:51:34.214217', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1277, 11, 29, 69, 'US', '2025-04-22 21:51:34.376596', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1278, 11, 29, 64, 'US', '2025-04-22 21:51:34.534326', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1279, 11, 29, 66, 'US', '2025-04-22 21:51:34.693129', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1280, 11, 29, 67, 'US', '2025-04-22 21:51:34.852823', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1281, 11, 29, 68, 'US', '2025-04-22 21:51:35.012036', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1282, 11, 29, 69, 'US', '2025-04-22 21:51:35.169439', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1283, 11, 29, 64, 'US', '2025-04-22 21:51:35.326101', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1284, 11, 29, 66, 'US', '2025-04-22 21:51:35.482456', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1285, 11, 29, 67, 'US', '2025-04-22 21:51:35.639076', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1286, 11, 29, 68, 'US', '2025-04-22 21:51:35.799916', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1287, 11, 29, 69, 'US', '2025-04-22 21:51:35.962034', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1288, 11, 29, 64, 'US', '2025-04-22 21:51:36.125399', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1289, 11, 29, 66, 'US', '2025-04-22 21:51:36.284366', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1290, 11, 29, 67, 'US', '2025-04-22 21:51:36.443173', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1291, 11, 29, 68, 'US', '2025-04-22 21:51:36.602219', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1292, 11, 29, 69, 'US', '2025-04-22 21:51:36.758044', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1293, 11, 29, 64, 'US', '2025-04-22 21:51:36.917214', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1294, 11, 29, 66, 'US', '2025-04-22 21:51:37.072733', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1295, 11, 29, 67, 'US', '2025-04-22 21:51:37.231804', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1296, 11, 29, 68, 'US', '2025-04-22 21:51:37.388312', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1297, 11, 29, 69, 'US', '2025-04-22 21:51:37.546316', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1298, 11, 29, 64, 'US', '2025-04-22 21:51:37.710897', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1299, 11, 29, 66, 'US', '2025-04-22 21:51:37.866851', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1300, 11, 29, 67, 'US', '2025-04-22 21:51:38.03193', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1301, 11, 29, 68, 'US', '2025-04-22 21:51:38.231804', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1302, 11, 29, 69, 'US', '2025-04-22 21:51:38.390749', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1303, 11, 29, 64, 'US', '2025-04-22 21:51:38.57982', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1304, 11, 29, 66, 'US', '2025-04-22 21:51:38.739164', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1305, 11, 29, 67, 'US', '2025-04-22 21:51:38.909575', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1306, 11, 29, 68, 'US', '2025-04-22 21:51:39.065762', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1307, 11, 29, 69, 'US', '2025-04-22 21:51:39.228225', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1308, 11, 29, 64, 'US', '2025-04-22 21:51:39.3904', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1309, 11, 29, 66, 'US', '2025-04-22 21:51:39.547847', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1310, 11, 29, 67, 'US', '2025-04-22 21:51:39.707491', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1311, 11, 29, 68, 'US', '2025-04-22 21:51:39.871023', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1312, 11, 29, 69, 'US', '2025-04-22 21:51:40.028999', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1313, 11, 29, 64, 'US', '2025-04-22 21:51:40.19116', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1314, 11, 29, 66, 'US', '2025-04-22 21:51:40.350635', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1315, 11, 29, 67, 'US', '2025-04-22 21:51:40.518016', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1316, 11, 29, 68, 'US', '2025-04-22 21:51:40.675472', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1317, 11, 29, 69, 'US', '2025-04-22 21:51:40.835589', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1318, 11, 29, 64, 'US', '2025-04-22 21:51:40.997911', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1319, 11, 29, 66, 'US', '2025-04-22 21:51:41.155386', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1320, 11, 29, 67, 'US', '2025-04-22 21:51:41.315616', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1321, 11, 29, 68, 'US', '2025-04-22 21:51:41.472141', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1322, 11, 29, 69, 'US', '2025-04-22 21:51:41.629213', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1323, 11, 29, 64, 'US', '2025-04-22 21:51:41.787032', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1324, 11, 29, 66, 'US', '2025-04-22 21:51:41.945439', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1325, 11, 29, 67, 'US', '2025-04-22 21:51:42.249388', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1326, 11, 29, 68, 'US', '2025-04-22 21:51:42.414357', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1327, 11, 29, 69, 'US', '2025-04-22 21:51:42.574273', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1328, 11, 29, 64, 'US', '2025-04-22 21:51:42.735378', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1329, 11, 29, 66, 'US', '2025-04-22 21:51:42.899894', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1330, 11, 29, 67, 'US', '2025-04-22 21:51:43.055629', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1331, 11, 29, 68, 'US', '2025-04-22 21:51:43.303107', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1332, 11, 29, 69, 'US', '2025-04-22 21:51:43.469225', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1333, 11, 29, 64, 'US', '2025-04-22 21:51:43.630402', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1334, 11, 29, 66, 'US', '2025-04-22 21:51:43.816953', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1335, 11, 29, 67, 'US', '2025-04-22 21:51:43.97274', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1336, 11, 29, 68, 'US', '2025-04-22 21:51:44.408942', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1337, 11, 29, 69, 'US', '2025-04-22 21:51:44.590471', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1338, 11, 29, 64, 'US', '2025-04-22 21:51:44.746232', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1339, 11, 29, 66, 'US', '2025-04-22 21:51:45.06054', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1340, 11, 29, 67, 'US', '2025-04-22 21:51:45.251655', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1341, 11, 29, 68, 'US', '2025-04-22 21:51:45.530785', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1342, 11, 29, 69, 'US', '2025-04-22 21:51:45.719444', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1343, 11, 29, 64, 'US', '2025-04-22 21:51:45.88208', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1344, 11, 29, 66, 'US', '2025-04-22 21:51:46.045448', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1345, 11, 29, 67, 'US', '2025-04-22 21:51:46.201442', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1346, 11, 29, 68, 'US', '2025-04-22 21:51:46.360903', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1347, 11, 29, 69, 'US', '2025-04-22 21:51:46.549255', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1351, 11, 29, 68, 'US', '2025-04-22 21:51:47.230201', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1354, 11, 29, 66, 'US', '2025-04-22 21:51:48.285452', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1357, 11, 29, 69, 'US', '2025-04-22 21:51:48.80827', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1360, 11, 29, 67, 'US', '2025-04-22 21:51:49.480635', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1363, 11, 29, 64, 'US', '2025-04-22 21:51:49.939575', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1366, 11, 29, 68, 'US', '2025-04-22 21:51:50.671934', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1369, 11, 29, 66, 'US', '2025-04-22 21:51:51.13805', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1372, 11, 29, 69, 'US', '2025-04-22 21:51:51.604234', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1375, 11, 29, 66, 'US', '2025-04-22 21:51:52.806142', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1378, 11, 29, 69, 'US', '2025-04-22 21:51:53.352383', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1381, 11, 29, 67, 'US', '2025-04-22 21:51:54.118222', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1384, 11, 29, 64, 'US', '2025-04-22 21:51:54.598599', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1387, 11, 29, 68, 'US', '2025-04-22 21:51:55.078041', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1348, 11, 29, 64, 'US', '2025-04-22 21:51:46.719016', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1349, 11, 29, 66, 'US', '2025-04-22 21:51:46.886299', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1350, 11, 29, 67, 'US', '2025-04-22 21:51:47.046101', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1352, 11, 29, 69, 'US', '2025-04-22 21:51:47.439489', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1353, 11, 29, 64, 'US', '2025-04-22 21:51:48.040411', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1355, 11, 29, 67, 'US', '2025-04-22 21:51:48.472171', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1356, 11, 29, 68, 'US', '2025-04-22 21:51:48.632488', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1358, 11, 29, 64, 'US', '2025-04-22 21:51:49.140473', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1359, 11, 29, 66, 'US', '2025-04-22 21:51:49.325944', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1361, 11, 29, 68, 'US', '2025-04-22 21:51:49.631032', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1362, 11, 29, 69, 'US', '2025-04-22 21:51:49.782143', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1364, 11, 29, 66, 'US', '2025-04-22 21:51:50.109025', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1365, 11, 29, 67, 'US', '2025-04-22 21:51:50.503227', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1367, 11, 29, 69, 'US', '2025-04-22 21:51:50.822007', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1368, 11, 29, 64, 'US', '2025-04-22 21:51:50.980818', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1370, 11, 29, 67, 'US', '2025-04-22 21:51:51.289603', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1371, 11, 29, 68, 'US', '2025-04-22 21:51:51.451173', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1373, 11, 29, 64, 'US', '2025-04-22 21:51:51.755996', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1374, 11, 29, 66, 'US', '2025-04-22 21:51:51.913623', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1376, 11, 29, 67, 'US', '2025-04-22 21:51:52.975222', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1377, 11, 29, 68, 'US', '2025-04-22 21:51:53.174579', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1379, 11, 29, 64, 'US', '2025-04-22 21:51:53.514505', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1380, 11, 29, 66, 'US', '2025-04-22 21:51:53.679719', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1382, 11, 29, 68, 'US', '2025-04-22 21:51:54.274256', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1383, 11, 29, 69, 'US', '2025-04-22 21:51:54.440509', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1385, 11, 29, 66, 'US', '2025-04-22 21:51:54.762196', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1386, 11, 29, 67, 'US', '2025-04-22 21:51:54.92001', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1388, 11, 29, 69, 'US', '2025-04-22 21:51:55.238638', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1389, 11, 29, 64, 'US', '2025-04-22 21:51:55.40785', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1391, 11, 29, 67, 'US', '2025-04-22 21:51:55.728277', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1392, 11, 29, 68, 'US', '2025-04-22 21:51:55.87757', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1394, 11, 29, 64, 'US', '2025-04-22 21:51:56.194864', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1395, 11, 29, 66, 'US', '2025-04-22 21:51:56.358153', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1397, 11, 29, 68, 'US', '2025-04-22 21:51:56.672007', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1398, 11, 29, 69, 'US', '2025-04-22 21:51:56.82611', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1400, 11, 29, 66, 'US', '2025-04-22 21:51:57.519807', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1401, 11, 29, 67, 'US', '2025-04-22 21:51:57.686125', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1403, 11, 29, 69, 'US', '2025-04-22 21:51:58.008301', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1406, 11, 29, 64, 'US', '2025-04-22 21:51:59.15975', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1408, 11, 29, 67, 'US', '2025-04-22 21:51:59.66911', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1409, 11, 29, 68, 'US', '2025-04-22 21:51:59.836927', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1410, 11, 29, 69, 'US', '2025-04-22 21:52:00.056169', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1412, 11, 29, 66, 'US', '2025-04-22 21:52:00.384954', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1414, 11, 29, 68, 'US', '2025-04-22 21:52:00.724155', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1415, 11, 29, 69, 'US', '2025-04-22 21:52:00.879889', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1416, 11, 29, 64, 'US', '2025-04-22 21:52:01.039663', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1418, 11, 29, 67, 'US', '2025-04-22 21:52:01.555826', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1420, 11, 29, 69, 'US', '2025-04-22 21:52:01.866012', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1421, 11, 29, 64, 'US', '2025-04-22 21:52:02.016886', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1422, 11, 29, 66, 'US', '2025-04-22 21:52:02.184866', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1424, 11, 29, 68, 'US', '2025-04-22 21:52:02.779001', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1426, 11, 29, 64, 'US', '2025-04-22 21:52:03.096865', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1427, 11, 29, 66, 'US', '2025-04-22 21:52:03.252938', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1428, 11, 29, 67, 'US', '2025-04-22 21:52:03.764144', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1430, 11, 29, 69, 'US', '2025-04-22 21:52:04.168575', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1432, 11, 29, 66, 'US', '2025-04-22 21:52:04.543439', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1433, 11, 29, 67, 'US', '2025-04-22 21:52:04.701567', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1434, 11, 29, 68, 'US', '2025-04-22 21:52:05.297628', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1436, 11, 29, 64, 'US', '2025-04-22 21:52:05.700642', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1438, 11, 29, 67, 'US', '2025-04-22 21:52:06.014431', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1439, 11, 29, 68, 'US', '2025-04-22 21:52:06.176695', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1440, 11, 29, 69, 'US', '2025-04-22 21:52:06.339725', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1442, 11, 29, 66, 'US', '2025-04-22 21:52:07.645896', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1444, 11, 29, 68, 'US', '2025-04-22 21:52:08.440112', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1445, 11, 29, 69, 'US', '2025-04-22 21:52:08.688757', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1446, 11, 29, 64, 'US', '2025-04-22 21:52:08.872326', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1448, 11, 29, 67, 'US', '2025-04-22 21:52:09.734976', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1450, 11, 29, 69, 'US', '2025-04-22 21:52:10.276206', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1451, 11, 29, 64, 'US', '2025-04-22 21:52:10.454746', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1452, 11, 29, 66, 'US', '2025-04-22 21:52:10.665961', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1454, 11, 29, 68, 'US', '2025-04-22 21:52:11.062276', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1456, 11, 29, 64, 'US', '2025-04-22 21:52:11.468533', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1457, 11, 29, 66, 'US', '2025-04-22 21:52:11.642359', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1458, 11, 29, 67, 'US', '2025-04-22 21:52:11.84864', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1460, 11, 29, 69, 'US', '2025-04-22 21:52:12.223116', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1462, 11, 29, 66, 'US', '2025-04-22 21:52:12.587416', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1463, 11, 29, 67, 'US', '2025-04-22 21:52:13.080539', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1464, 11, 29, 68, 'US', '2025-04-22 21:52:13.273939', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1466, 11, 29, 64, 'US', '2025-04-22 21:52:13.728699', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1468, 11, 29, 67, 'US', '2025-04-22 21:52:14.712324', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1469, 11, 29, 68, 'US', '2025-04-22 21:52:15.027365', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1470, 11, 29, 69, 'US', '2025-04-22 21:52:15.536715', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1472, 11, 29, 66, 'US', '2025-04-22 21:52:16.594661', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1474, 11, 29, 68, 'US', '2025-04-22 21:52:18.049834', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1475, 11, 29, 69, 'US', '2025-04-22 21:52:18.352244', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1477, 11, 29, 66, 'US', '2025-04-22 21:52:19.228666', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1478, 11, 29, 67, 'US', '2025-04-22 21:52:20.658628', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1479, 11, 29, 68, 'US', '2025-04-22 21:52:20.86384', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1390, 11, 29, 66, 'US', '2025-04-22 21:51:55.575777', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1396, 11, 29, 67, 'US', '2025-04-22 21:51:56.52119', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1402, 11, 29, 68, 'US', '2025-04-22 21:51:57.846986', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1404, 11, 29, 64, 'US', '2025-04-22 21:51:58.153253', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1411, 11, 29, 64, 'US', '2025-04-22 21:52:00.226098', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1417, 11, 29, 66, 'US', '2025-04-22 21:52:01.195877', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1423, 11, 29, 67, 'US', '2025-04-22 21:52:02.613531', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1429, 11, 29, 68, 'US', '2025-04-22 21:52:04.010651', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1435, 11, 29, 69, 'US', '2025-04-22 21:52:05.540097', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1441, 11, 29, 64, 'US', '2025-04-22 21:52:06.883515', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1447, 11, 29, 66, 'US', '2025-04-22 21:52:09.320019', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1453, 11, 29, 67, 'US', '2025-04-22 21:52:10.901003', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1459, 11, 29, 68, 'US', '2025-04-22 21:52:12.018235', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1465, 11, 29, 69, 'US', '2025-04-22 21:52:13.46957', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1471, 11, 29, 64, 'US', '2025-04-22 21:52:16.138484', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1480, 11, 29, 69, 'US', '2025-04-22 21:52:21.7806', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1487, 11, 29, 66, 'US', '2025-04-22 21:52:23.798384', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1491, 11, 29, 64, 'US', '2025-04-22 21:52:24.944676', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1496, 11, 29, 64, 'US', '2025-04-22 21:52:27.316906', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1502, 11, 29, 66, 'US', '2025-04-22 21:52:28.828679', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1508, 11, 29, 67, 'US', '2025-04-22 21:52:30.809986', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1514, 11, 29, 68, 'US', '2025-04-22 21:52:32.65594', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1520, 11, 29, 69, 'US', '2025-04-22 21:52:35.302577', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1526, 11, 29, 64, 'US', '2025-04-22 21:52:37.109866', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1532, 11, 29, 66, 'US', '2025-04-22 21:52:39.079586', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1538, 11, 29, 67, 'US', '2025-04-22 21:52:41.431028', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1544, 11, 29, 68, 'US', '2025-04-22 21:52:43.353756', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1550, 11, 29, 69, 'US', '2025-04-22 21:52:47.277373', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1556, 11, 29, 64, 'US', '2025-04-22 21:52:49.818955', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1561, 11, 29, 64, 'US', '2025-04-22 21:52:52.241447', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1566, 11, 29, 64, 'US', '2025-04-22 21:52:54.547652', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1572, 11, 29, 66, 'US', '2025-04-22 21:52:57.624374', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1578, 11, 29, 67, 'US', '2025-04-22 21:53:01.424048', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1584, 11, 29, 68, 'US', '2025-04-22 21:53:05.153748', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1590, 11, 29, 69, 'US', '2025-04-22 21:53:07.263906', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1596, 11, 29, 64, 'US', '2025-04-22 21:53:10.23745', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1602, 11, 29, 66, 'US', '2025-04-22 21:53:13.94757', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1608, 11, 29, 67, 'US', '2025-04-22 21:53:17.159041', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1614, 11, 29, 68, 'US', '2025-04-22 21:53:18.889102', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1620, 11, 29, 69, 'US', '2025-04-22 21:53:21.200407', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1626, 11, 29, 64, 'US', '2025-04-22 21:53:22.983965', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1632, 11, 29, 66, 'US', '2025-04-22 21:53:26.276749', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1638, 11, 29, 67, 'US', '2025-04-22 21:53:28.16725', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1644, 11, 29, 68, 'US', '2025-04-22 21:53:31.327732', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1650, 11, 29, 69, 'US', '2025-04-22 21:53:33.460176', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1656, 11, 29, 64, 'US', '2025-04-22 21:53:36.551763', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1662, 11, 29, 66, 'US', '2025-04-22 21:53:37.955679', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1668, 11, 29, 67, 'US', '2025-04-22 21:53:40.685314', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1674, 11, 29, 68, 'US', '2025-04-22 21:53:42.245108', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1680, 11, 29, 69, 'US', '2025-04-22 21:53:45.479288', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1686, 11, 29, 64, 'US', '2025-04-22 21:53:47.323125', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1692, 11, 29, 66, 'US', '2025-04-22 21:53:49.477473', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1698, 11, 29, 67, 'US', '2025-04-22 21:53:51.586471', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1704, 11, 29, 68, 'US', '2025-04-22 21:53:53.917977', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1710, 11, 29, 69, 'US', '2025-04-22 21:53:56.942907', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1716, 11, 29, 64, 'US', '2025-04-22 21:53:58.792985', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1722, 11, 29, 66, 'US', '2025-04-22 21:54:01.313161', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1728, 11, 29, 67, 'US', '2025-04-22 21:54:03.283978', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1734, 11, 29, 68, 'US', '2025-04-22 21:54:07.299684', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1740, 11, 29, 69, 'US', '2025-04-22 21:54:10.575681', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1746, 11, 29, 64, 'US', '2025-04-22 21:54:12.501545', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1759, 11, 20, 63, 'US', '2025-04-22 22:06:04.66432', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1763, 11, 20, 54, 'US', '2025-04-22 22:06:12.075652', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1766, 11, 20, 69, 'US', '2025-04-22 22:09:07.991446', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1769, 11, 20, 70, 'US', '2025-04-22 22:11:59.259164', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1772, 11, 20, 70, 'US', '2025-04-22 22:17:58.11092', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1784, 11, 39, 70, 'US', '2025-04-22 22:34:34.056332', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1796, 11, 39, 70, 'US', '2025-04-28 23:41:43.491035', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1808, 11, 39, 70, 'US', '2025-06-05 15:54:45.309516', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1829, 11, 17, 86, 'US', '2025-06-05 16:35:58.702972', 'mytracks');
INSERT INTO public.tracks_log VALUES (1847, 11, 17, 84, 'US', '2025-06-05 17:47:41.484423', 'mytracks');
INSERT INTO public.tracks_log VALUES (1860, 11, 17, 84, 'US', '2025-06-05 18:18:45.884756', 'mytracks');
INSERT INTO public.tracks_log VALUES (1393, 11, 29, 69, 'US', '2025-04-22 21:51:56.033669', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1399, 11, 29, 64, 'US', '2025-04-22 21:51:57.333214', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1405, 11, 29, 66, 'US', '2025-04-22 21:51:58.341244', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1407, 11, 29, 66, 'US', '2025-04-22 21:51:59.461885', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1413, 11, 29, 67, 'US', '2025-04-22 21:52:00.56943', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1419, 11, 29, 68, 'US', '2025-04-22 21:52:01.711928', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1425, 11, 29, 69, 'US', '2025-04-22 21:52:02.944376', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1431, 11, 29, 64, 'US', '2025-04-22 21:52:04.324332', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1437, 11, 29, 66, 'US', '2025-04-22 21:52:05.856607', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1443, 11, 29, 67, 'US', '2025-04-22 21:52:08.042146', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1449, 11, 29, 68, 'US', '2025-04-22 21:52:10.041002', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1455, 11, 29, 69, 'US', '2025-04-22 21:52:11.298816', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1461, 11, 29, 64, 'US', '2025-04-22 21:52:12.398541', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1467, 11, 29, 66, 'US', '2025-04-22 21:52:14.05359', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1473, 11, 29, 67, 'US', '2025-04-22 21:52:17.181861', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1476, 11, 29, 64, 'US', '2025-04-22 21:52:18.905581', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1482, 11, 29, 66, 'US', '2025-04-22 21:52:22.201874', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1489, 11, 29, 68, 'US', '2025-04-22 21:52:24.234427', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1498, 11, 29, 67, 'US', '2025-04-22 21:52:27.683517', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1504, 11, 29, 68, 'US', '2025-04-22 21:52:29.389923', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1510, 11, 29, 69, 'US', '2025-04-22 21:52:31.714664', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1516, 11, 29, 64, 'US', '2025-04-22 21:52:33.624797', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1522, 11, 29, 66, 'US', '2025-04-22 21:52:36.168639', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1528, 11, 29, 67, 'US', '2025-04-22 21:52:37.618774', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1534, 11, 29, 68, 'US', '2025-04-22 21:52:39.711111', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1540, 11, 29, 69, 'US', '2025-04-22 21:52:41.937326', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1546, 11, 29, 64, 'US', '2025-04-22 21:52:44.92337', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1552, 11, 29, 66, 'US', '2025-04-22 21:52:47.708351', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1563, 11, 29, 67, 'US', '2025-04-22 21:52:52.672327', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1567, 11, 29, 66, 'US', '2025-04-22 21:52:55.4364', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1573, 11, 29, 67, 'US', '2025-04-22 21:52:57.917695', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1579, 11, 29, 68, 'US', '2025-04-22 21:53:01.658577', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1585, 11, 29, 69, 'US', '2025-04-22 21:53:05.92482', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1591, 11, 29, 64, 'US', '2025-04-22 21:53:07.5111', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1597, 11, 29, 66, 'US', '2025-04-22 21:53:10.975353', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1603, 11, 29, 67, 'US', '2025-04-22 21:53:15.346878', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1609, 11, 29, 68, 'US', '2025-04-22 21:53:17.398784', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1615, 11, 29, 69, 'US', '2025-04-22 21:53:19.122187', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1621, 11, 29, 64, 'US', '2025-04-22 21:53:21.491084', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1627, 11, 29, 66, 'US', '2025-04-22 21:53:23.661261', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1633, 11, 29, 67, 'US', '2025-04-22 21:53:26.532577', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1639, 11, 29, 68, 'US', '2025-04-22 21:53:28.903866', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1645, 11, 29, 69, 'US', '2025-04-22 21:53:31.536628', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1651, 11, 29, 64, 'US', '2025-04-22 21:53:33.929877', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1657, 11, 29, 66, 'US', '2025-04-22 21:53:36.787934', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1663, 11, 29, 67, 'US', '2025-04-22 21:53:38.154227', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1669, 11, 29, 68, 'US', '2025-04-22 21:53:41.06694', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1675, 11, 29, 69, 'US', '2025-04-22 21:53:42.458023', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1681, 11, 29, 64, 'US', '2025-04-22 21:53:46.035534', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1687, 11, 29, 66, 'US', '2025-04-22 21:53:47.567424', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1693, 11, 29, 67, 'US', '2025-04-22 21:53:50.126736', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1699, 11, 29, 68, 'US', '2025-04-22 21:53:51.927635', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1705, 11, 29, 69, 'US', '2025-04-22 21:53:54.522577', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1711, 11, 29, 64, 'US', '2025-04-22 21:53:57.180123', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1717, 11, 29, 66, 'US', '2025-04-22 21:53:59.421235', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1723, 11, 29, 67, 'US', '2025-04-22 21:54:01.541427', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1729, 11, 29, 68, 'US', '2025-04-22 21:54:03.82948', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1735, 11, 29, 69, 'US', '2025-04-22 21:54:07.551322', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1741, 11, 29, 64, 'US', '2025-04-22 21:54:10.971386', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1747, 11, 29, 66, 'US', '2025-04-22 21:54:12.95865', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1761, 11, 20, 54, 'US', '2025-04-22 22:06:10.245538', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1785, 11, 39, 70, 'US', '2025-04-22 22:35:05.028627', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1797, 11, 39, 70, 'US', '2025-04-28 23:41:48.14048', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1811, 11, 39, 70, 'US', '2025-06-05 16:15:22.106841', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1818, 11, 17, 86, 'US', '2025-06-05 16:21:11.306082', 'mytracks');
INSERT INTO public.tracks_log VALUES (1830, 11, 17, 85, 'US', '2025-06-05 16:39:33.66776', 'mytracks');
INSERT INTO public.tracks_log VALUES (1832, 11, 17, 83, 'US', '2025-06-05 16:44:47.785419', 'mytracks');
INSERT INTO public.tracks_log VALUES (1848, 11, 17, 83, 'US', '2025-06-05 17:52:23.761241', 'mytracks');
INSERT INTO public.tracks_log VALUES (1849, 11, 17, 82, 'US', '2025-06-05 17:56:10.865527', 'mytracks');
INSERT INTO public.tracks_log VALUES (1850, 11, 17, 87, 'US', '2025-06-05 17:58:37.581105', 'mytracks');
INSERT INTO public.tracks_log VALUES (1851, 11, 17, 86, 'US', '2025-06-05 18:00:19.37789', 'mytracks');
INSERT INTO public.tracks_log VALUES (1852, 11, 17, 85, 'US', '2025-06-05 18:03:54.255348', 'mytracks');
INSERT INTO public.tracks_log VALUES (1861, 11, 17, 84, 'US', '2025-06-05 18:19:18.033579', 'mytracks');
INSERT INTO public.tracks_log VALUES (1481, 11, 29, 64, 'US', '2025-04-22 21:52:21.966349', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1488, 11, 29, 67, 'US', '2025-04-22 21:52:24.006013', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1492, 11, 29, 66, 'US', '2025-04-22 21:52:25.168381', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1497, 11, 29, 66, 'US', '2025-04-22 21:52:27.508356', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1503, 11, 29, 67, 'US', '2025-04-22 21:52:29.149647', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1509, 11, 29, 68, 'US', '2025-04-22 21:52:31.196347', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1515, 11, 29, 69, 'US', '2025-04-22 21:52:33.213178', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1521, 11, 29, 64, 'US', '2025-04-22 21:52:35.650034', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1527, 11, 29, 66, 'US', '2025-04-22 21:52:37.435096', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1533, 11, 29, 67, 'US', '2025-04-22 21:52:39.359872', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1539, 11, 29, 68, 'US', '2025-04-22 21:52:41.683579', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1545, 11, 29, 69, 'US', '2025-04-22 21:52:43.979003', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1551, 11, 29, 64, 'US', '2025-04-22 21:52:47.488633', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1562, 11, 29, 66, 'US', '2025-04-22 21:52:52.461153', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1568, 11, 29, 67, 'US', '2025-04-22 21:52:56.307384', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1574, 11, 29, 68, 'US', '2025-04-22 21:52:58.458995', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1580, 11, 29, 69, 'US', '2025-04-22 21:53:01.889799', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1586, 11, 29, 64, 'US', '2025-04-22 21:53:06.268767', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1592, 11, 29, 66, 'US', '2025-04-22 21:53:07.706122', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1598, 11, 29, 67, 'US', '2025-04-22 21:53:11.395293', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1604, 11, 29, 68, 'US', '2025-04-22 21:53:16.06668', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1610, 11, 29, 69, 'US', '2025-04-22 21:53:17.602887', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1616, 11, 29, 64, 'US', '2025-04-22 21:53:19.948615', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1622, 11, 29, 66, 'US', '2025-04-22 21:53:21.747859', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1628, 11, 29, 67, 'US', '2025-04-22 21:53:24.285311', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1634, 11, 29, 68, 'US', '2025-04-22 21:53:26.847431', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1640, 11, 29, 69, 'US', '2025-04-22 21:53:29.5499', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1646, 11, 29, 64, 'US', '2025-04-22 21:53:31.762473', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1652, 11, 29, 66, 'US', '2025-04-22 21:53:34.413647', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1658, 11, 29, 67, 'US', '2025-04-22 21:53:36.996526', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1664, 11, 29, 68, 'US', '2025-04-22 21:53:38.673686', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1670, 11, 29, 69, 'US', '2025-04-22 21:53:41.285121', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1676, 11, 29, 64, 'US', '2025-04-22 21:53:42.702997', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1682, 11, 29, 66, 'US', '2025-04-22 21:53:46.413096', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1688, 11, 29, 67, 'US', '2025-04-22 21:53:47.787352', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1694, 11, 29, 68, 'US', '2025-04-22 21:53:50.695068', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1700, 11, 29, 69, 'US', '2025-04-22 21:53:52.164931', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1706, 11, 29, 64, 'US', '2025-04-22 21:53:55.200533', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1712, 11, 29, 66, 'US', '2025-04-22 21:53:57.397937', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1718, 11, 29, 67, 'US', '2025-04-22 21:54:00.153973', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1724, 11, 29, 68, 'US', '2025-04-22 21:54:01.75865', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1730, 11, 29, 69, 'US', '2025-04-22 21:54:04.944852', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1736, 11, 29, 64, 'US', '2025-04-22 21:54:07.799133', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1742, 11, 29, 66, 'US', '2025-04-22 21:54:11.272508', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1748, 11, 29, 67, 'US', '2025-04-22 21:54:14.333409', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1774, 11, 20, 69, 'US', '2025-04-22 22:21:27.298812', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1779, 11, 39, 70, 'US', '2025-04-22 22:27:54.357553', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1787, 11, 39, 70, 'US', '2025-04-22 22:36:25.307043', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1798, 11, 39, 70, 'US', '2025-05-30 05:48:43.417647', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1812, 11, 17, 82, 'US', '2025-06-05 16:16:45.000899', 'mytracks');
INSERT INTO public.tracks_log VALUES (1813, 11, 17, 82, 'US', '2025-06-05 16:17:53.061926', 'mytracks');
INSERT INTO public.tracks_log VALUES (1817, 11, 16, 54, 'US', '2025-06-05 16:21:04.453577', 'likedtracks_11');
INSERT INTO public.tracks_log VALUES (1821, 11, 17, 85, 'US', '2025-06-05 16:26:58.131073', 'mytracks');
INSERT INTO public.tracks_log VALUES (1824, 11, 17, 84, 'US', '2025-06-05 16:27:04.313769', 'mytracks');
INSERT INTO public.tracks_log VALUES (1831, 11, 17, 84, 'US', '2025-06-05 16:42:21.37156', 'mytracks');
INSERT INTO public.tracks_log VALUES (1833, 11, 17, 82, 'US', '2025-06-05 16:50:47.795132', 'mytracks');
INSERT INTO public.tracks_log VALUES (1836, 11, 17, 86, 'US', '2025-06-05 16:55:10.464793', 'mytracks');
INSERT INTO public.tracks_log VALUES (1837, 11, 17, 85, 'US', '2025-06-05 16:58:52.004819', 'mytracks');
INSERT INTO public.tracks_log VALUES (1853, 11, 17, 84, 'US', '2025-06-05 18:06:41.939597', 'mytracks');
INSERT INTO public.tracks_log VALUES (1854, 11, 17, 84, 'US', '2025-06-05 18:07:08.142328', 'mytracks');
INSERT INTO public.tracks_log VALUES (1862, 11, 39, 70, 'US', '2025-06-05 18:19:56.761811', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1483, 11, 29, 67, 'US', '2025-04-22 21:52:22.412118', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1493, 11, 29, 67, 'US', '2025-04-22 21:52:26.02091', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1499, 11, 29, 68, 'US', '2025-04-22 21:52:27.88958', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1505, 11, 29, 69, 'US', '2025-04-22 21:52:29.6585', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1511, 11, 29, 64, 'US', '2025-04-22 21:52:31.954392', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1517, 11, 29, 66, 'US', '2025-04-22 21:52:33.930937', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1523, 11, 29, 67, 'US', '2025-04-22 21:52:36.393538', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1529, 11, 29, 68, 'US', '2025-04-22 21:52:37.914843', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1535, 11, 29, 69, 'US', '2025-04-22 21:52:40.269445', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1541, 11, 29, 64, 'US', '2025-04-22 21:52:42.133498', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1547, 11, 29, 66, 'US', '2025-04-22 21:52:45.182218', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1553, 11, 29, 67, 'US', '2025-04-22 21:52:47.981257', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1569, 11, 29, 68, 'US', '2025-04-22 21:52:56.52107', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1575, 11, 29, 69, 'US', '2025-04-22 21:52:59.696317', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1581, 11, 29, 64, 'US', '2025-04-22 21:53:02.628035', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1587, 11, 29, 66, 'US', '2025-04-22 21:53:06.538373', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1593, 11, 29, 67, 'US', '2025-04-22 21:53:08.026489', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1599, 11, 29, 68, 'US', '2025-04-22 21:53:11.69386', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1605, 11, 29, 69, 'US', '2025-04-22 21:53:16.378457', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1611, 11, 29, 64, 'US', '2025-04-22 21:53:17.843367', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1617, 11, 29, 66, 'US', '2025-04-22 21:53:20.573734', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1623, 11, 29, 67, 'US', '2025-04-22 21:53:22.014806', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1629, 11, 29, 68, 'US', '2025-04-22 21:53:24.643805', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1635, 11, 29, 69, 'US', '2025-04-22 21:53:27.147558', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1641, 11, 29, 64, 'US', '2025-04-22 21:53:30.182287', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1647, 11, 29, 66, 'US', '2025-04-22 21:53:31.991406', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1653, 11, 29, 67, 'US', '2025-04-22 21:53:35.257613', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1659, 11, 29, 68, 'US', '2025-04-22 21:53:37.211096', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1665, 11, 29, 69, 'US', '2025-04-22 21:53:39.125963', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1671, 11, 29, 64, 'US', '2025-04-22 21:53:41.548845', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1677, 11, 29, 66, 'US', '2025-04-22 21:53:43.825282', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1683, 11, 29, 67, 'US', '2025-04-22 21:53:46.660982', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1689, 11, 29, 68, 'US', '2025-04-22 21:53:48.160236', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1695, 11, 29, 69, 'US', '2025-04-22 21:53:50.903625', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1701, 11, 29, 64, 'US', '2025-04-22 21:53:52.442504', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1707, 11, 29, 66, 'US', '2025-04-22 21:53:55.856426', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1713, 11, 29, 67, 'US', '2025-04-22 21:53:57.745006', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1719, 11, 29, 68, 'US', '2025-04-22 21:54:00.683673', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1725, 11, 29, 69, 'US', '2025-04-22 21:54:02.033779', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1731, 11, 29, 64, 'US', '2025-04-22 21:54:06.170808', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1737, 11, 29, 66, 'US', '2025-04-22 21:54:08.209328', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1743, 11, 29, 67, 'US', '2025-04-22 21:54:11.793964', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1749, 11, 29, 68, 'US', '2025-04-22 21:54:14.538377', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1775, 11, 20, 70, 'US', '2025-04-22 22:21:30.052278', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1781, 11, 39, 70, 'US', '2025-04-22 22:29:08.442627', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1788, 11, 39, 70, 'US', '2025-04-22 22:39:13.847976', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1799, 11, 39, 70, 'US', '2025-05-30 05:50:18.629717', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1814, 11, 17, 82, 'US', '2025-06-05 16:17:54.120634', 'mytracks');
INSERT INTO public.tracks_log VALUES (1823, 11, 17, 85, 'US', '2025-06-05 16:27:01.142554', 'mytracks');
INSERT INTO public.tracks_log VALUES (1834, 11, 17, 87, 'US', '2025-06-05 16:53:14.627819', 'mytracks');
INSERT INTO public.tracks_log VALUES (1855, 11, 17, 84, 'US', '2025-06-05 18:07:54.817647', 'mytracks');
INSERT INTO public.tracks_log VALUES (1863, 11, 39, 70, 'LV', '2025-06-05 19:48:39.354069', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1865, 11, 39, 70, 'LV', '2025-06-05 19:51:27.816115', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1866, 11, 17, 88, 'LV', '2025-06-05 19:51:59.652868', 'mytracks');
INSERT INTO public.tracks_log VALUES (1868, 11, 17, 87, 'LV', '2025-06-05 19:53:46.037999', 'mytracks');
INSERT INTO public.tracks_log VALUES (1869, 11, 17, 89, 'LV', '2025-06-05 19:53:47.070618', 'mytracks');
INSERT INTO public.tracks_log VALUES (1870, 11, 17, 88, 'LV', '2025-06-05 19:59:24.434027', 'mytracks');
INSERT INTO public.tracks_log VALUES (1484, 11, 29, 68, 'US', '2025-04-22 21:52:23.134964', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1494, 11, 29, 68, 'US', '2025-04-22 21:52:26.555889', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1500, 11, 29, 69, 'US', '2025-04-22 21:52:28.1279', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1506, 11, 29, 64, 'US', '2025-04-22 21:52:30.031182', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1512, 11, 29, 66, 'US', '2025-04-22 21:52:32.244131', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1518, 11, 29, 67, 'US', '2025-04-22 21:52:34.266418', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1524, 11, 29, 68, 'US', '2025-04-22 21:52:36.727498', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1530, 11, 29, 69, 'US', '2025-04-22 21:52:38.079944', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1536, 11, 29, 64, 'US', '2025-04-22 21:52:40.831464', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1542, 11, 29, 66, 'US', '2025-04-22 21:52:42.382929', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1548, 11, 29, 67, 'US', '2025-04-22 21:52:45.700101', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1554, 11, 29, 68, 'US', '2025-04-22 21:52:48.967787', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1557, 11, 29, 66, 'US', '2025-04-22 21:52:50.892595', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1560, 11, 29, 69, 'US', '2025-04-22 21:52:51.987499', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1751, 11, 29, 69, 'US', '2025-04-22 21:57:06.045244', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1756, 11, 29, 69, 'US', '2025-04-22 22:05:02.936134', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1776, 11, 39, 70, 'US', '2025-04-22 22:22:07.590442', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1778, 11, 39, 70, 'US', '2025-04-22 22:24:57.418644', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1780, 11, 39, 70, 'US', '2025-04-22 22:28:43.063931', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1789, 11, 39, 70, 'US', '2025-04-22 22:41:59.723596', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1800, 11, 39, 70, 'US', '2025-05-30 05:51:53.852141', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1801, 11, 39, 70, 'US', '2025-05-30 05:52:16.607444', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1802, 11, 39, 70, 'US', '2025-05-30 06:29:05.140921', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1803, 11, 10, 46, 'US', '2025-05-30 06:29:50.90114', 'arcane');
INSERT INTO public.tracks_log VALUES (1815, 11, 17, 82, 'US', '2025-06-05 16:18:06.720935', 'mytracks');
INSERT INTO public.tracks_log VALUES (1819, 11, 17, 85, 'US', '2025-06-05 16:21:35.468652', 'mytracks');
INSERT INTO public.tracks_log VALUES (1838, 11, 17, 85, 'US', '2025-06-05 17:01:42.311046', 'mytracks');
INSERT INTO public.tracks_log VALUES (1844, 11, 17, 84, 'US', '2025-06-05 17:13:42.284036', 'mytracks');
INSERT INTO public.tracks_log VALUES (1856, 11, 17, 84, 'US', '2025-06-05 18:12:44.979282', 'mytracks');
INSERT INTO public.tracks_log VALUES (1864, 11, 39, 70, 'LV', '2025-06-05 19:51:27.815128', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1867, 11, 17, 87, 'LV', '2025-06-05 19:53:10.501234', 'mytracks');
INSERT INTO public.tracks_log VALUES (1485, 11, 29, 69, 'US', '2025-04-22 21:52:23.355036', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1486, 11, 29, 64, 'US', '2025-04-22 21:52:23.561647', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1490, 11, 29, 69, 'US', '2025-04-22 21:52:24.726808', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1495, 11, 29, 69, 'US', '2025-04-22 21:52:27.155175', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1501, 11, 29, 64, 'US', '2025-04-22 21:52:28.527462', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1507, 11, 29, 66, 'US', '2025-04-22 21:52:30.506324', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1513, 11, 29, 67, 'US', '2025-04-22 21:52:32.442801', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1519, 11, 29, 68, 'US', '2025-04-22 21:52:34.766426', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1525, 11, 29, 69, 'US', '2025-04-22 21:52:36.927319', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1531, 11, 29, 64, 'US', '2025-04-22 21:52:38.777861', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1537, 11, 29, 66, 'US', '2025-04-22 21:52:41.193619', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1543, 11, 29, 67, 'US', '2025-04-22 21:52:42.566636', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1549, 11, 29, 68, 'US', '2025-04-22 21:52:46.736859', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1555, 11, 29, 69, 'US', '2025-04-22 21:52:49.448275', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1558, 11, 29, 67, 'US', '2025-04-22 21:52:51.142685', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1559, 11, 29, 68, 'US', '2025-04-22 21:52:51.40749', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1752, 11, 29, 64, 'US', '2025-04-22 21:57:27.059249', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1755, 11, 29, 68, 'US', '2025-04-22 22:02:25.318706', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1758, 11, 29, 66, 'US', '2025-04-22 22:05:22.78168', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1760, 11, 20, 55, 'US', '2025-04-22 22:06:10.056736', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1764, 11, 20, 61, 'US', '2025-04-22 22:06:13.011819', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1767, 11, 20, 70, 'US', '2025-04-22 22:09:09.976937', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1770, 11, 20, 69, 'US', '2025-04-22 22:14:46.05422', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1773, 11, 20, 69, 'US', '2025-04-22 22:20:44.05514', 'recentlyadded');
INSERT INTO public.tracks_log VALUES (1777, 11, 39, 70, 'US', '2025-04-22 22:24:44.976108', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1790, 18, 29, 64, 'US', '2025-04-22 22:59:32.993358', 'sad-playlist');
INSERT INTO public.tracks_log VALUES (1804, 11, 39, 70, 'US', '2025-06-05 15:11:35.377289', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1805, 11, 39, 70, 'US', '2025-06-05 15:13:01.618766', 'kabanchik');
INSERT INTO public.tracks_log VALUES (1816, 11, 17, 83, 'US', '2025-06-05 16:18:07.607314', 'mytracks');
INSERT INTO public.tracks_log VALUES (1820, 11, 17, 86, 'US', '2025-06-05 16:21:37.814964', 'mytracks');
INSERT INTO public.tracks_log VALUES (1839, 11, 17, 85, 'US', '2025-06-05 17:02:35.816074', 'mytracks');
INSERT INTO public.tracks_log VALUES (1840, 11, 17, 85, 'US', '2025-06-05 17:04:31.758706', 'mytracks');
INSERT INTO public.tracks_log VALUES (1842, 11, 17, 84, 'US', '2025-06-05 17:08:42.521376', 'mytracks');
INSERT INTO public.tracks_log VALUES (1845, 11, 17, 84, 'US', '2025-06-05 17:17:38.773488', 'mytracks');
INSERT INTO public.tracks_log VALUES (1857, 11, 17, 84, 'US', '2025-06-05 18:16:22.72521', 'mytracks');


--
-- TOC entry 3467 (class 0 OID 16426)
-- Dependencies: 224
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES (9, 'Minixomek', '$2b$10$f03fsC2fCitPKnBJWbB1yu3eosmHvlOd.gjRwF4X1dEpFrbKf54zy', NULL, '[48, 46]', '[10]', '2024-12-02 00:24:06.916439', '2024-12-02 00:24:06.916439', 0, 0.00, 0, 0, 0, 0, 0, 'minixomek1905@gmail.com', 0, 0);
INSERT INTO public.users VALUES (12, 'nefar', '$2b$10$wsWc4q2NVi8zLnc7RYRBfu6jFAIpGqzavAhRFHz35k4Mrb4GZRZ8O', NULL, '[]', '[]', '2025-01-06 02:37:26.777684', '2025-01-06 02:37:26.777684', 0, 0.00, 0, 0, 0, 0, 0, 'nefar@mail.com', 0, 0);
INSERT INTO public.users VALUES (8, 'peas4nt', '$2b$10$UMw0QOa7BthQinSjiNcLeufh8YvgJ0lR0D8cjsIzd8Iq.CT4LcXf2', NULL, '[47]', '[10]', '2024-12-01 17:10:19.762314', '2024-12-01 17:10:19.762314', 0, 0.14, 0, 0, 0, 0, 1, 'vladislavsteclavs@gmail.com', 0, 0);
INSERT INTO public.users VALUES (13, 'aleg', '$2b$10$/wUYH51DNE2FDY2gElavKO/cGQVTATbsHxhaknxVq4LKpaEM5r0Ce', NULL, '[]', '[]', '2025-01-14 13:18:08.335387', '2025-01-14 13:18:08.335387', 1, 0.20, 0, 0, 0, 0, 0, 'alegjelgava@gmail.com', 1, 1);
INSERT INTO public.users VALUES (10, 'Danil', '$2b$10$yCV.CiK57Tmt1Ay3wZf57O8fGgyVRn51rNTEjKk6joN8jzVZ4tzyO', '1738882097169-73.jpg', '[63, 70, 65, 62, 67]', '[24, 26]', '2024-12-02 01:23:10.97743', '2024-12-02 01:23:10.97743', 1, 0.19, 0, 0, 0, 1, 1, 'danilsatsuta4@gmail.com', 1, 1);
INSERT INTO public.users VALUES (14, 'AnalDetect', '$2b$10$uUB5u2umvcDONXW3qVfc4eCbXnXJyIQzT7U2fA9QGWke9WCqtqejC', '1736880150781-433.jpg', '[56]', '[]', '2025-01-14 18:40:46.142619', '2025-01-14 18:40:46.142619', 0, 0.01, 0, 0, 0, 0, 0, 'andrewminov1@gmail.com', 1, 1);
INSERT INTO public.users VALUES (16, 'test2', '$2b$10$3OG1LzIstSYLg2pBlDdErOgJcjJgses/cK/pTtazwlRK1ICAi9lna', '1738917244644-566.png', '[71]', '[29]', '2025-02-07 08:28:15.133268', '2025-02-07 08:28:15.133268', 0, 0.14, 0, 0, 0, 0, 0, 'test@gmail.com', 1, 1);
INSERT INTO public.users VALUES (17, 'Justin', '$2b$10$ft5HTef8S4XImi4zvbMY8Obm7vYEe602hlxYuL5VPvF5ifk.Fewl2', NULL, '[]', '[]', '2025-03-15 13:22:15.895666', '2025-03-15 13:22:15.895666', 0, 0.20, 0, 0, 0, 0, 0, 'danilsatsuta44@gmail.com', 1, 1);
INSERT INTO public.users VALUES (11, 'Admin', '$2b$10$yGdq5bEHJG69ICvuCSTzHuTEQObiKVwI/rts4soPnoOdwkE0ZNgym', '1736916265505-843.jpg', '[52, 53, null, null, null, 46, 54]', '[7, 9, 10, 12, 13, 14, 20, 27, 29, 30]', '2024-12-03 07:55:58.650267', '2024-12-03 07:55:58.650267', 1, 0.02, 1, 1, 1, 0, 1, 'admin@admin.com', 1, 1);
INSERT INTO public.users VALUES (20, 'qwe', '$2b$10$DMV.50ZjiXv9NyQp98iDYOR9hhyMY5wkxS4EZAnopmLhj0qB31WTC', NULL, '[]', '[]', '2025-04-26 20:06:29.849657', '2025-04-26 20:06:29.849657', 0, 0.36, 0, 0, 0, 0, 0, 'qweqwe@gmail.com', 1, 1);
INSERT INTO public.users VALUES (15, 'test', '$2b$10$qBUfyv1N3n8SqLdYQ09TUOguSJLDjnvgRAEuRmrexEL5046edNnj2', NULL, '[71]', '[]', '2025-02-07 06:57:12.530713', '2025-02-07 06:57:12.530713', 1, 0.20, 0, 0, 0, 0, 0, 'test@test.com', 1, 1);
INSERT INTO public.users VALUES (19, 'admin2', '$2b$10$PQfx4IJK3GeT2UOT5EmIi.iOvADHSh5PEA3d2mS3gL1RRsbwZhz0u', '1744634506858-632.png', '[66]', '[]', '2025-04-14 12:37:37.852287', '2025-04-14 12:37:37.852287', 0, 0.31, 0, 1, 1, 0, 1, 'admin2@admin.com', 1, 1);
INSERT INTO public.users VALUES (18, 'admin24', '$2b$10$1sZwM/vj/1BDpxmrNqJKyuchXMAi8KhcA2K0KE7JWH0PP824UfnIe', '1744630241140-258.png', '[66]', '[29]', '2025-04-14 11:23:49.30007', '2025-04-14 11:23:49.30007', 1, 0.22, 0, 0, 0, 0, 1, 'admin1@admin.com', 1, 1);


--
-- TOC entry 3481 (class 0 OID 0)
-- Dependencies: 217
-- Name: artists_artist_key_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.artists_artist_key_seq', 40, true);


--
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 221
-- Name: logs_log_key_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.logs_log_key_seq', 1, false);


--
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 219
-- Name: playlists_playlist_key_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.playlists_playlist_key_seq', 42, true);


--
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 215
-- Name: tracks_log_tracks_log_key_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tracks_log_tracks_log_key_seq', 1870, true);


--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 225
-- Name: tracks_track_key_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tracks_track_key_seq', 90, true);


--
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 223
-- Name: users_user_key_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_user_key_seq', 20, true);


--
-- TOC entry 3306 (class 2606 OID 16406)
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (artist_key);


--
-- TOC entry 3310 (class 2606 OID 16424)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (log_key);


--
-- TOC entry 3308 (class 2606 OID 16415)
-- Name: playlists playlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT playlists_pkey PRIMARY KEY (playlist_key);


--
-- TOC entry 3304 (class 2606 OID 16397)
-- Name: tracks_log tracks_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracks_log
    ADD CONSTRAINT tracks_log_pkey PRIMARY KEY (tracks_log_key);


--
-- TOC entry 3314 (class 2606 OID 16442)
-- Name: tracks tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (track_key);


--
-- TOC entry 3312 (class 2606 OID 16433)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_key);


-- Completed on 2025-06-05 23:24:54

--
-- PostgreSQL database dump complete
--

