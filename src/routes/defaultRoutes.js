import express from "express";

// controller importning
import * as login from "../controllers/login.js";
import * as signup from "../controllers/signup.js";
import * as main from "../controllers/main.js";
import * as trackUpload from "../controllers/trackUploader.js";
import * as playlist from "../controllers/playlist.js";
import * as track from "../controllers/track.js";
import * as userSettings from "../controllers/userSettings.js";

// middlewares
import checkSession from "../middlewares/checkSession.js";
import redirectIfAuthenticated from "../middlewares/redirectIfAuthenticated.js";

// multer configuration
import * as mul from "../../multer.js";

// validations
import { signupValidation } from "../validations/signupValidation.js";
import { playlistValidation } from "../validations/playlistValidation.js";
import { trackValidation } from "../validations/trackValidation.js";
import { passwordValidation, usernameValidation } from "../validations/settingsValidation.js";


const router = express.Router();


// login
router.get("/login", redirectIfAuthenticated, login.getPage);
router.post("/login", redirectIfAuthenticated, login.postData);
// register
router.get("/signup", redirectIfAuthenticated, signup.getPage);
router.post("/signup", redirectIfAuthenticated, signupValidation, signup.postData);
// leave (clear session data)
router.get("/logouot", login.getDeleteSessoin);

// check session
router.use(checkSession);


// track uploader
router.post("/trackcheck", mul.uploadBuffer.single("track"), trackUpload.postCheckTrack);
router.post(
	"/trackupload",
	mul.upload.fields([
		{ name: "track", maxCount: 1 },
		{ name: "image", maxCount: 1 },
	]),
	trackValidation,
	trackUpload.postTrackUpload,
);

// Track
router.post("/track/like", mul.parser.none(), track.postLike);
router.post("/track/get/:key", mul.parser.none(), track.postGetTrack);

// Playlist
router.post("/playlist", mul.upload.single("image"), playlistValidation, playlist.postData);
router.put("/playlist", mul.upload.single("image"), playlistValidation, playlist.putData);
router.delete("/playlist", mul.parser.none(), playlist.deleteData);
router.post("/playlist/like", mul.parser.none(), playlist.postLike);
router.post("/playlist/addtrack", mul.parser.none(), playlist.postAddTrackToPlaylists);
router.post("/playlist/getdata", mul.parser.none(), playlist.postGetPlaylist);
router.post("/playlist/get/:slug", mul.parser.none(), playlist.postGetPlaylistTracks);

// Users Settings
router.put("/updatesettings", mul.parser.none(), userSettings.putData);
router.put("/updatesettings/username", mul.parser.none(), usernameValidation, userSettings.putUsername);
router.put("/updatesettings/image", mul.upload.single("image"), userSettings.putImage);
router.put("/updatesettings/password", mul.parser.none(), passwordValidation, userSettings.putPassword);


// main
router.get("/template/:page?/:slug?", main.getTemplate);
router.get("/:page?/:slug?", main.getPage);

export default router;
