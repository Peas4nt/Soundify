import dotenv from "dotenv";
dotenv.config();
export default (req, res, next) => {
	if (process.env.USER_ADMIN_LOGIN == 1) {
		req.session.user = { key: process.env.USER_KEY };
	}

	if (req.session.user) {
		return res.redirect("/");
	}
	next();
};
