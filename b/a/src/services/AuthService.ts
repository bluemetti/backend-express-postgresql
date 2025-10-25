import jwt from 'jsonwebtoken';
import { IUser, User } from '../models/User';
import dotenv from 'dotenv';

dotenv.config();

export interface IAuthTokenPayload {
  userId: string;
  email: string;
}

export interface IRegisterData {
  name: string;
  email: string;
  password: string;
}

export interface ILoginData {
  email: string;
  password: string;
}

export class AuthService {
  private static jwtSecret = process.env.JWT_SECRET;
  private static jwtExpiresIn = process.env.JWT_EXPIRES_IN || '24h';

  static generateToken(payload: IAuthTokenPayload): string {
    if (!this.jwtSecret) {
      throw new Error('JWT_SECRET is not defined in environment variables');
    }

    return jwt.sign(payload, this.jwtSecret, {
      expiresIn: this.jwtExpiresIn
    } as jwt.SignOptions);
  }

  static verifyToken(token: string): IAuthTokenPayload {
    if (!this.jwtSecret) {
      throw new Error('JWT_SECRET is not defined in environment variables');
    }

    try {
      return jwt.verify(token, this.jwtSecret) as IAuthTokenPayload;
    } catch (error) {
      throw new Error('Invalid or expired token');
    }
  }

  static async register(userData: IRegisterData): Promise<{ user: IUser; token: string }> {
    try {
      // Check if user already exists
      const existingUser = await User.findOne({ email: userData.email });
      if (existingUser) {
        throw new Error('User with this email already exists');
      }

      // Create new user
      const user = new User(userData);
      await user.save();

      // Generate JWT token
      const token = this.generateToken({
        userId: (user._id as any).toString(),
        email: user.email
      });

      console.log(`✅ User registered successfully: ${user.email}`);

      return { user, token };
    } catch (error) {
      console.error('❌ Registration error:', error);
      throw error;
    }
  }

  static async login(loginData: ILoginData): Promise<{ user: IUser; token: string }> {
    try {
      // Find user by email and include password for comparison
      const user = await User.findOne({ email: loginData.email }).select('+password');
      
      if (!user) {
        console.log(`⚠️ Login failed: User not found - ${loginData.email}`);
        throw new Error('User not found');
      }

      // Compare password
      const isPasswordValid = await user.comparePassword(loginData.password);
      if (!isPasswordValid) {
        console.log(`⚠️ Login failed: Invalid password for - ${loginData.email}`);
        throw new Error('Invalid password');
      }

      // Generate JWT token
      const token = this.generateToken({
        userId: (user._id as any).toString(),
        email: user.email
      });

      // Remove password from user object before returning
      user.password = undefined as any;

      console.log(`✅ User logged in successfully: ${user.email}`);

      return { user, token };
    } catch (error) {
      console.error('❌ Login error:', error);
      throw error;
    }
  }

  static async getUserById(userId: string): Promise<IUser | null> {
    try {
      return await User.findById(userId);
    } catch (error) {
      console.error('❌ Error fetching user:', error);
      throw new Error('User not found');
    }
  }
}
