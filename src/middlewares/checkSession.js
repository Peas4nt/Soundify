import { sql } from "../../db.js";

// function for check a session
export default async (req, res, next) => {
	
	// Check if user is authenticated in the session
	if (!req.session.user) {
		return res.redirect("/login");
	}

	// get user data from db
	const [user] = await sql`select user_key key, username, email, image_path from users where user_key = ${req.session.user.key}`;
	req.session.user = user;
	
	next();
};
