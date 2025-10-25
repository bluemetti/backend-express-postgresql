import { Request, Response, NextFunction } from 'express';
import { AuthService, IAuthTokenPayload } from '../services/AuthService';

// Extend Express Request interface to include user
declare global {
  namespace Express {
    interface Request {
      user?: IAuthTokenPayload;
    }
  }
}

export const authMiddleware = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const authHeader = req.header('Authorization');
    
    if (!authHeader) {
      res.status(401).json({
        success: false,
        message: 'Access denied. No token provided.',
        error: 'MISSING_TOKEN'
      });
      return;
    }

    // Extract token from "Bearer TOKEN"
    const token = authHeader.startsWith('Bearer ') 
      ? authHeader.substring(7) 
      : authHeader;

    if (!token) {
      res.status(401).json({
        success: false,
        message: 'Access denied. Invalid token format.',
        error: 'INVALID_TOKEN_FORMAT'
      });
      return;
    }

    // Verify token
    const decoded = AuthService.verifyToken(token);
    req.user = decoded;

    console.log(`✅ Token verified for user: ${decoded.email}`);
    next();
  } catch (error) {
    console.error('❌ Auth middleware error:', error);
    
    res.status(401).json({
      success: false,
      message: 'Access denied. Invalid token.',
      error: 'INVALID_TOKEN'
    });
  }
};
