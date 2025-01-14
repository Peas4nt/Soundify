import { body } from "express-validator";

export const usernameValidation = [
	body("username")
		.isLength({ min: 3, max: 30 })
		.withMessage("Username must be between 3 and 30 characters long")
		.matches(/^[a-zA-Z0-9_-]+$/)
		.withMessage("Username can only contain letters, numbers, underscores, and dashes"),
];

export const passwordValidation = [
	// check password
	body("new_password")
		.isLength({ min: 6, max: 50 })
		.withMessage("Password must be between 6 and 50 characters long")
		.matches(/\d/)
		.withMessage("Password must contain at least one number")
		.matches(/[A-Z]/)
		.withMessage("Password must contain at least one uppercase letter"),

	// check password
	body("new_password_confirm").custom((value, { req }) => {
		if (value !== req.body.new_password) {
			throw new Error("Password confirmation does not match the password");
		}
		return true;
	}),
];
