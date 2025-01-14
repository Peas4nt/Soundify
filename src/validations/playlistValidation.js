import { body } from "express-validator";

export const playlistValidation = [
  body('name')
    .trim()
    .isLength({ min: 3, max: 50 }).withMessage('Playlist name must be between 3 and 50 characters.')
    .isString().withMessage('Name must be a string.'),
  body('description')
    .optional()
    .trim()
    .isLength({ max: 250 }).withMessage('Playlist description must not exceed 250 characters.')
    .isString().withMessage('Description must be a string.'),
];
