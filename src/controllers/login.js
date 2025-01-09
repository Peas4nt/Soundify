import { validationResult } from "express-validator";
import { sql } from "../../db.js";
import bcrypt from "bcrypt";

export const getPage = (req, res) => {
	res.render("common", {
		viewPath: "login",
		error: {},
		values: {},
	});
};

export const postData = async (req, res) => {
	try {
		const { email, password } = req.body;

		const result = await sql`select user_key, password from users where email = ${email ?? ''}`;

		if (result.length > 0) {
			const isValid = await bcrypt.compare(password, result[0].password);
			if (isValid) {
        req.session.user = { key: result[0].user_key };
        return res.redirect("/");
			}
		}

		return res.render("common", {
			viewPath: "login",
			error: { msg: "Your login info is not correct. Please check your email and password and try again." },
			values: req.body,
		});
	} catch (error) {
		console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Login failed, try later." });
	}
};

export const getDeleteSessoin = (req, res) => {
	req.session.destroy();
	res.redirect("/login");
};
