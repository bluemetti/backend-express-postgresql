import { Workout } from '../models/Workout';
import { AppDataSource } from '../database/connection';
import { Between, LessThanOrEqual, MoreThanOrEqual } from 'typeorm';

export interface CreateWorkoutData {
  name: string;
  type: 'cardio' | 'strength' | 'flexibility' | 'sports' | 'other';
  duration: number;
  calories?: number;
  exercises: Array<{
    name: string;
    sets?: number;
    reps?: number;
    weight?: number;
    distance?: number;
    time?: number;
  }>;
  date?: Date;
  notes?: string;
}

export interface UpdateWorkoutData {
  name?: string;
  type?: 'cardio' | 'strength' | 'flexibility' | 'sports' | 'other';
  duration?: number;
  calories?: number;
  exercises?: Array<{
    name: string;
    sets?: number;
    reps?: number;
    weight?: number;
    distance?: number;
    time?: number;
  }>;
  date?: Date;
  notes?: string;
}

export interface WorkoutFilters {
  type?: string;
  dateFrom?: string;
  dateTo?: string;
  minDuration?: string;
  maxDuration?: string;
  minCalories?: string;
  maxCalories?: string;
}

export class WorkoutService {
  /**
   * Create a new workout
   */
  static async createWorkout(
    workoutData: CreateWorkoutData,
    userId: string
  ): Promise<Workout> {
    try {
      console.log(`🔄 Creating workout for user: ${userId}`);

      const workoutRepository = AppDataSource.getRepository(Workout);
      
      const workout = workoutRepository.create({
        ...workoutData,
        userId,
        date: workoutData.date || new Date()
      });

      await workoutRepository.save(workout);

      console.log(`✅ Workout created successfully: ${workout.id}`);
      return workout;
    } catch (error) {
      console.error('❌ Error creating workout:', error);
      throw error;
    }
  }

  /**
   * Get all workouts for a user with optional filters
   */
  static async getWorkouts(
    userId: string,
    filters?: WorkoutFilters
  ): Promise<Workout[]> {
    try {
      console.log(`🔄 Fetching workouts for user: ${userId}`);

      const workoutRepository = AppDataSource.getRepository(Workout);
      const queryBuilder = workoutRepository.createQueryBuilder('workout')
        .where('workout.userId = :userId', { userId });

      // Apply filters
      if (filters?.type) {
        queryBuilder.andWhere('workout.type = :type', { type: filters.type });
      }

      if (filters?.dateFrom && filters?.dateTo) {
        queryBuilder.andWhere('workout.date BETWEEN :dateFrom AND :dateTo', {
          dateFrom: new Date(filters.dateFrom),
          dateTo: new Date(filters.dateTo)
        });
      } else if (filters?.dateFrom) {
        queryBuilder.andWhere('workout.date >= :dateFrom', {
          dateFrom: new Date(filters.dateFrom)
        });
      } else if (filters?.dateTo) {
        queryBuilder.andWhere('workout.date <= :dateTo', {
          dateTo: new Date(filters.dateTo)
        });
      }

      if (filters?.minDuration && filters?.maxDuration) {
        queryBuilder.andWhere('workout.duration BETWEEN :minDuration AND :maxDuration', {
          minDuration: parseInt(filters.minDuration),
          maxDuration: parseInt(filters.maxDuration)
        });
      } else if (filters?.minDuration) {
        queryBuilder.andWhere('workout.duration >= :minDuration', {
          minDuration: parseInt(filters.minDuration)
        });
      } else if (filters?.maxDuration) {
        queryBuilder.andWhere('workout.duration <= :maxDuration', {
          maxDuration: parseInt(filters.maxDuration)
        });
      }

      if (filters?.minCalories && filters?.maxCalories) {
        queryBuilder.andWhere('workout.calories BETWEEN :minCalories AND :maxCalories', {
          minCalories: parseInt(filters.minCalories),
          maxCalories: parseInt(filters.maxCalories)
        });
      } else if (filters?.minCalories) {
        queryBuilder.andWhere('workout.calories >= :minCalories', {
          minCalories: parseInt(filters.minCalories)
        });
      } else if (filters?.maxCalories) {
        queryBuilder.andWhere('workout.calories <= :maxCalories', {
          maxCalories: parseInt(filters.maxCalories)
        });
      }

      const workouts = await queryBuilder
        .orderBy('workout.date', 'DESC')
        .getMany();

      console.log(`✅ Found ${workouts.length} workout(s) for user: ${userId}`);
      return workouts;
    } catch (error) {
      console.error('❌ Error fetching workouts:', error);
      throw error;
    }
  }

  /**
   * Get a single workout by ID
   */
  static async getWorkoutById(
    workoutId: string,
    userId: string
  ): Promise<Workout | null> {
    try {
      console.log(`🔄 Fetching workout ${workoutId} for user: ${userId}`);

      const workoutRepository = AppDataSource.getRepository(Workout);
      
      const workout = await workoutRepository.findOne({
        where: {
          id: workoutId,
          userId
        }
      });

      if (!workout) {
        console.log(`⚠️ Workout not found or access denied: ${workoutId}`);
        return null;
      }

      console.log(`✅ Workout found: ${workoutId}`);
      return workout;
    } catch (error) {
      console.error('❌ Error fetching workout by ID:', error);
      throw error;
    }
  }

  /**
   * Update a workout (full update - PUT)
   */
  static async updateWorkout(
    workoutId: string,
    userId: string,
    workoutData: CreateWorkoutData
  ): Promise<Workout | null> {
    try {
      console.log(`🔄 Updating workout ${workoutId} for user: ${userId}`);

      const workoutRepository = AppDataSource.getRepository(Workout);
      
      const workout = await workoutRepository.findOne({
        where: {
          id: workoutId,
          userId
        }
      });

      if (!workout) {
        console.log(`⚠️ Workout not found or access denied: ${workoutId}`);
        return null;
      }

      // Update all fields
      Object.assign(workout, {
        ...workoutData,
        date: workoutData.date || new Date()
      });

      await workoutRepository.save(workout);

      console.log(`✅ Workout updated successfully: ${workoutId}`);
      return workout;
    } catch (error) {
      console.error('❌ Error updating workout:', error);
      throw error;
    }
  }

  /**
   * Partially update a workout (PATCH)
   */
  static async patchWorkout(
    workoutId: string,
    userId: string,
    workoutData: UpdateWorkoutData
  ): Promise<Workout | null> {
    try {
      console.log(`🔄 Patching workout ${workoutId} for user: ${userId}`);

      const workoutRepository = AppDataSource.getRepository(Workout);
      
      const workout = await workoutRepository.findOne({
        where: {
          id: workoutId,
          userId
        }
      });

      if (!workout) {
        console.log(`⚠️ Workout not found or access denied: ${workoutId}`);
        return null;
      }

      // Update only provided fields
      Object.assign(workout, workoutData);

      await workoutRepository.save(workout);

      console.log(`✅ Workout patched successfully: ${workoutId}`);
      return workout;
    } catch (error) {
      console.error('❌ Error patching workout:', error);
      throw error;
    }
  }

  /**
   * Delete a workout
   */
  static async deleteWorkout(
    workoutId: string,
    userId: string
  ): Promise<boolean> {
    try {
      console.log(`🔄 Deleting workout ${workoutId} for user: ${userId}`);

      const workoutRepository = AppDataSource.getRepository(Workout);
      
      const result = await workoutRepository.delete({
        id: workoutId,
        userId
      });

      if (!result.affected || result.affected === 0) {
        console.log(`⚠️ Workout not found or access denied: ${workoutId}`);
        return false;
      }

      console.log(`✅ Workout deleted successfully: ${workoutId}`);
      return true;
    } catch (error) {
      console.error('❌ Error deleting workout:', error);
      throw error;
    }
  }

  /**
   * Get workout statistics for a user
   */
  static async getWorkoutStats(userId: string): Promise<any> {
    try {
      console.log(`🔄 Fetching workout statistics for user: ${userId}`);

      const workoutRepository = AppDataSource.getRepository(Workout);
      
      const stats = await workoutRepository
        .createQueryBuilder('workout')
        .select('COUNT(*)', 'totalWorkouts')
        .addSelect('SUM(workout.duration)', 'totalDuration')
        .addSelect('SUM(workout.calories)', 'totalCalories')
        .addSelect('AVG(workout.duration)', 'avgDuration')
        .addSelect('AVG(workout.calories)', 'avgCalories')
        .where('workout.userId = :userId', { userId })
        .getRawOne();

      // Get workouts by type
      const workoutsByType = await workoutRepository
        .createQueryBuilder('workout')
        .select('workout.type', 'type')
        .addSelect('COUNT(*)', 'count')
        .where('workout.userId = :userId', { userId })
        .groupBy('workout.type')
        .getRawMany();

      console.log(`✅ Workout statistics fetched for user: ${userId}`);
      
      return {
        totalWorkouts: parseInt(stats?.totalWorkouts || '0'),
        totalDuration: parseFloat(stats?.totalDuration || '0'),
        totalCalories: parseFloat(stats?.totalCalories || '0'),
        avgDuration: parseFloat(stats?.avgDuration || '0'),
        avgCalories: parseFloat(stats?.avgCalories || '0'),
        workoutsByType
      };
    } catch (error) {
      console.error('❌ Error fetching workout statistics:', error);
      throw error;
    }
  }
}
