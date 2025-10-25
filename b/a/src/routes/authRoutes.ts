import express from 'express';
import { AuthController } from '../controllers/AuthController';
import { authMiddleware } from '../middlewares/authMiddleware';
import { validateRegister, validateLogin, validateJsonBody } from '../middlewares/validationMiddleware';

const router = express.Router();

// Public routes
router.post('/register', validateJsonBody, validateRegister, AuthController.register);
router.post('/login', validateJsonBody, validateLogin, AuthController.login);

// Protected routes
router.get('/protected', authMiddleware, AuthController.getProtected);

export default router;
