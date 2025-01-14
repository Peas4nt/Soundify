import { body } from "express-validator";

export const trackValidation = [
  // Validate track name: 3 to 50 characters
  body('name')
      .trim()
      .isLength({ min: 3, max: 100 })
      .withMessage('Track name must be between 3 and 100 characters long'),
];