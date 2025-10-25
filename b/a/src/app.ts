import express, { Application, Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';
import connectDB from './database/connection';
import authRoutes from './routes/authRoutes';
import workoutRoutes from './routes/workoutRoutes';

// Load environment variables
dotenv.config();

class App {
  public app: Application;
  public port: string | number;

  constructor() {
    this.app = express();
    this.port = process.env.PORT || 3000;

    this.initializeMiddlewares();
    this.initializeRoutes();
    this.initializeErrorHandling();
    this.connectToDatabase();
  }

  private initializeMiddlewares(): void {
    // Security middleware
    this.app.use(helmet());
    
    // CORS middleware - allow all origins for Vercel deployment
    this.app.use(cors({
      origin: '*',
      credentials: true
    }));

    // Logging middleware
    this.app.use(morgan(process.env.NODE_ENV === 'production' ? 'combined' : 'dev'));

    // Body parsing middleware
    this.app.use(express.json({ limit: '10mb' }));
    this.app.use(express.urlencoded({ extended: true, limit: '10mb' }));
  }

  private initializeRoutes(): void {
    // Root route - Welcome page with health check
    this.app.get('/', async (req: Request, res: Response) => {
      try {
        const dbStatus = await this.checkDatabaseConnection();
        
        res.status(200).json({
          success: true,
          message: '🚀 JWT Authentication API',
          description: 'API de autenticação com JWT, Node.js, TypeScript e MongoDB',
          timestamp: new Date().toISOString(),
          environment: process.env.NODE_ENV || 'development',
          database: dbStatus,
          endpoints: {
            health: '/health',
            register: 'POST /register',
            login: 'POST /login',
            protected: 'GET /protected (requires token)',
            workouts: {
              create: 'POST /workouts (requires token)',
              list: 'GET /workouts (requires token)',
              get: 'GET /workouts/:id (requires token)',
              update: 'PUT /workouts/:id (requires token)',
              patch: 'PATCH /workouts/:id (requires token)',
              delete: 'DELETE /workouts/:id (requires token)',
              stats: 'GET /workouts/stats (requires token)'
            }
          },
          documentation: 'https://github.com/bluemetti/b'
        });
      } catch (error) {
        res.status(503).json({
          success: false,
          message: '🚀 JWT Authentication API',
          description: 'API de autenticação com JWT, Node.js, TypeScript e MongoDB',
          timestamp: new Date().toISOString(),
          environment: process.env.NODE_ENV || 'development',
          database: {
            status: 'disconnected',
            error: 'Database connection failed'
          },
          endpoints: {
            health: '/health',
            register: 'POST /register',
            login: 'POST /login',
            protected: 'GET /protected (requires token)'
          },
          documentation: 'https://github.com/bluemetti/b'
        });
      }
    });

    // Health check route
    this.app.get('/health', async (req: Request, res: Response) => {
      try {
        const dbStatus = await this.checkDatabaseConnection();
        
        res.status(200).json({
          success: true,
          message: 'Server is running!',
          timestamp: new Date().toISOString(),
          environment: process.env.NODE_ENV || 'development',
          database: dbStatus
        });
      } catch (error) {
        res.status(503).json({
          success: false,
          message: 'Service unavailable',
          timestamp: new Date().toISOString(),
          environment: process.env.NODE_ENV || 'development',
          database: {
            status: 'disconnected',
            error: 'Database connection failed'
          }
        });
      }
    });

    // API routes
    this.app.use('/', authRoutes);
    this.app.use('/workouts', workoutRoutes);

    // 404 handler
    this.app.use((req: Request, res: Response) => {
      res.status(404).json({
        success: false,
        message: `Route ${req.originalUrl} not found`,
        error: 'NOT_FOUND'
      });
    });
  }

  private async checkDatabaseConnection(): Promise<{ status: string; name?: string }> {
    const mongoose = (await import('mongoose')).default;
    
    if (mongoose.connection.readyState === 1) {
      return {
        status: 'connected',
        name: mongoose.connection.name
      };
    }
    
    return { status: 'disconnected' };
  }

  private initializeErrorHandling(): void {
    // Global error handler
    this.app.use((error: Error, req: Request, res: Response, next: NextFunction) => {
      console.error('❌ Global error handler:', error);

      // Handle JSON parsing errors
      if (error instanceof SyntaxError && 'body' in error) {
        res.status(400).json({
          success: false,
          message: 'Invalid JSON format',
          error: 'INVALID_JSON'
        });
        return;
      }

      res.status(500).json({
        success: false,
        message: 'Internal server error',
        error: 'INTERNAL_ERROR'
      });
    });
  }

  private async connectToDatabase(): Promise<void> {
    await connectDB();
  }

  public getApp(): Application {
    return this.app;
  }

  public listen(): void {
    this.app.listen(this.port, () => {
      console.log(`🚀 Server running on port ${this.port}`);
      console.log(`📊 Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`🔗 Health check: http://localhost:${this.port}/health`);
    });
  }
}

export default App;
