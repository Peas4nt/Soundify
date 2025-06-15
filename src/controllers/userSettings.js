import { sql } from "../../db.js";
import { validationResult } from "express-validator";
import bcrypt from "bcrypt";
import path from "path";
import fs from "fs";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const putData = async (req, res) => {
	try {
		const { name, value } = req.body;

		const columns = await sql`
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'users'`;

		let isFound = false;
		columns.forEach((column) => {
			if (column.column_name == name) {
				isFound = true;
			}
		});

		if (!isFound) {
			return res.status(200).send({ status: "ERROR", message: "Column name not found" });
		}

		const data = {};
		data[name] = value;
		await sql`
    UPDATE users SET ${sql(data, name)}
		WHERE user_key = ${req.session.user.key};`;

		console.log(data);

		return res.status(200).send({ status: "SUCCESSFUL", message: "Settings was edited" });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "User settings editing error" });
	}
};

export const putUsername = async (req, res) => {
	try {
		const { username } = req.body;

		const errors = validationResult(req);
		if (!errors.isEmpty()) return res.status(200).send({ status: "ERROR", data: getErrorObj(errors.array()) });

		await sql`update artists 
    set name = ${username} 
    where fk_user_key = ${req.session.user.key} and is_user = 1;`;

		await sql`update users 
    set username = ${username} 
    where user_key = ${req.session.user.key};`;

		return res.status(200).send({ status: "SUCCESSFUL", message: "The username was edited successfully", data: { username: username } });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Username editing error" });
	}
};

export const putImage = async (req, res) => {
	try {
		let fileName = req.file?.filename ?? "";

		if (!fileName) return res.status(200).send({ status: "ERROR", image: "The picture was not found try again" });

		const [{ user_image }] = await sql`select image_path user_image from users where user_key = ${req.session.user.key};`;

		if (user_image) {
			const filePath = path.join(__dirname, "../", "../", process.env.IMAGE_FOLDER_PATH, user_image);

			fs.unlink(filePath, (err) => {
				if (err) {
					console.error(`Error deleting file ${filePath}:`, err);
				} else {
					console.log(`File ${filePath} deleted successfully.`);
				}
			});
		}

		await sql`update users set image_path = ${fileName} where user_key = ${req.session.user.key};`;

		return res.status(200).send({ status: "SUCCESSFUL", message: "The picture was edited successfully", data: { image_path: process.env.IMAGE_PATH + fileName } });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "User settings editing error" });
	}
};

export const putPassword = async (req, res) => {
	try {
		let { new_password, password } = req.body;

		const errors = validationResult(req);

		if (!errors.isEmpty()) return res.status(200).send({ status: "ERROR", data: getErrorObj(errors.array()) });

		const [{ old_password }] = await sql`select password old_password from users where user_key = ${req.session.user.key}`;

		const isValid = await bcrypt.compare(password, old_password);
		if (!isValid) return res.status(200).send({ status: "ERROR", data: { password: "Your password is not correct. Please check password and try again." } });

		new_password = await bcrypt.hash(new_password, 10);

		await sql`update users set password = ${new_password} where user_key = ${req.session.user.key};`;

		return res.status(200).send({ status: "SUCCESSFUL", message: "The password was edited successfully" });
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "User settings editing error" });
	}
};

function getErrorObj(errors) {
	const errorObj = {};
	errors.forEach((e) => {
		errorObj[e.path] = e.msg;
	});
	return errorObj;
}
