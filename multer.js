import multer from "multer";
import dotenv from "dotenv";
import path from "path";
dotenv.config();

const storage = multer.diskStorage({
	destination: (req, file, cb) => {
		let uploadPath;

		if (file.fieldname === "track") {
			uploadPath = process.env.TRACK_FOLDER_PATH;
		} else if (file.fieldname === "image") {
			uploadPath = process.env.IMAGE_FOLDER_PATH;
		} else {
			return cb(new Error("Invalid field name"), false);
		}

		cb(null, uploadPath);
	},
	filename: (req, file, cb) => {
		const randomName = Date.now() + "-" + Math.round(Math.random() * 1000);
		cb(null, randomName + path.extname(file.originalname));
	},
});

// file filter
const fileFilter = (req, file, cb) => {
	const ext = path.extname(file.originalname).toLowerCase();
	if (file.mimetype.startsWith("audio") || ext === ".mp3" || ext === ".mp4") {
		cb(null, true);
	} else if (file.mimetype.startsWith("image")) {
		cb(null, true);
	} else {
		cb(new Error("Unsupported file type"), false);
	}
};

export const uploadBuffer = multer({ dest: process.env.BUFFER_FOLDER_PATH }, fileFilter);

export const upload = multer({ storage }, fileFilter);

export const parser = multer();