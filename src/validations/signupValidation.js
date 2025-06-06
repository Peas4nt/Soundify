import { body } from "express-validator";
import checkIfEmailExists from "../utils/checkEmailUnique.js";

export const signupValidation = [
  // check username
  body('username')
    .isLength({ min: 3, max: 30 })
    .withMessage('Username must be between 3 and 30 characters long')
    .matches(/^[a-zA-Z0-9_-]+$/)
    .withMessage('Username can only contain letters, numbers, underscores, and dashes'),

  // check email
  body('email')
    .isEmail()
    .withMessage('Invalid email address')
    .custom(async (value) => {
      const emailExists = await checkIfEmailExists(value); // check email in db
      if (emailExists) {
        throw new Error('This email is already in use');
      }
      return true;
    }),

  // check password
  body('password')
    .isLength({ min: 9, max: 50 })
    .withMessage('Password must be between 9 and 50 characters long')
    .matches(/\d/)
    .withMessage('Password must contain at least one number')
    .matches(/[A-Z]/)
    .withMessage('Password must contain at least one uppercase letter'),

  // check password
  body('password2')
    .custom((value, { req }) => {
      if (value !== req.body.password) {
        throw new Error('Password confirmation does not match the password');
      }
      return true;
    }),
];
