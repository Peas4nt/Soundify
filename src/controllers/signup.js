import { validationResult } from "express-validator";
import { sql } from "../../db.js";
import bcrypt from "bcrypt";

export const getPage = (req, res) => {
	res.render("common", {
		viewPath: "signup",
    error: {},
    values: {}
	});
};

export const postData = async (req, res) => {
	try {
		const errors = validationResult(req);

		if (!errors.isEmpty()) {
			// return res.status(400).json({ errors: errors.array() });
			let errorObj = {};
			errors.array().forEach((err) => {
				errorObj[err.path] =  err.msg;
			});

			return res.render("common", {
				viewPath: "signup",
        error: errorObj,
        values: req.body
			});
		} else {
			let { username, email, password } = req.body;

      // password hashing
      password = await bcrypt.hash(password, 10);

      const data = await sql`insert into users (username, email, password) values (${username}, ${email}, ${password}) returning *`;
      
      // save user key
      req.session.user = { key: data[0].user_key };

			return res.redirect("/");
		}
  } catch (error) {
    console.log(error);
		return res.status(500).send({ status: "ERROR", message: "Signup failed, try later." });
	}
};
