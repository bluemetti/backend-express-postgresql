import { DataSource } from 'typeorm';
import dotenv from 'dotenv';
import { User } from '../models/User';
import { Workout } from '../models/Workout';

dotenv.config();

export const AppDataSource = new DataSource({
  type: 'postgres',
  url: process.env.DATABASE_URL || undefined,
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  username: process.env.DB_USERNAME || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres123',
  database: process.env.DB_DATABASE || 'jwt_auth_db',
  synchronize: true, // ⚠️ Apenas para desenvolvimento! Use migrations em produção
  logging: process.env.NODE_ENV === 'development',
  entities: [User, Workout],
  migrations: [],
  subscribers: [],
  ssl: process.env.DATABASE_URL ? { rejectUnauthorized: false } : false,
});

const connectDB = async (): Promise<void> => {
  try {
    await AppDataSource.initialize();
    console.log(`✅ PostgreSQL Connected: ${AppDataSource.options.database}`);
  } catch (error) {
    console.error('❌ Error connecting to PostgreSQL:', error);
    process.exit(1);
  }
};

export default connectDB;
