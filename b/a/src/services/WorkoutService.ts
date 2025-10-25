import { Workout, IWorkout } from '../models/Workout';
import mongoose from 'mongoose';

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
  ): Promise<IWorkout> {
    try {
      console.log(`🔄 Creating workout for user: ${userId}`);

      const workout = new Workout({
        ...workoutData,
        userId: new mongoose.Types.ObjectId(userId),
        date: workoutData.date || new Date()
      });

      await workout.save();

      console.log(`✅ Workout created successfully: ${workout._id}`);
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
  ): Promise<IWorkout[]> {
    try {
      console.log(`🔄 Fetching workouts for user: ${userId}`);

      const query: any = { userId: new mongoose.Types.ObjectId(userId) };

      // Apply filters
      if (filters?.type) {
        query.type = filters.type;
      }

      if (filters?.dateFrom || filters?.dateTo) {
        query.date = {};
        if (filters.dateFrom) {
          query.date.$gte = new Date(filters.dateFrom);
        }
        if (filters.dateTo) {
          query.date.$lte = new Date(filters.dateTo);
        }
      }

      if (filters?.minDuration || filters?.maxDuration) {
        query.duration = {};
        if (filters.minDuration) {
          query.duration.$gte = parseInt(filters.minDuration);
        }
        if (filters.maxDuration) {
          query.duration.$lte = parseInt(filters.maxDuration);
        }
      }

      if (filters?.minCalories || filters?.maxCalories) {
        query.calories = {};
        if (filters.minCalories) {
          query.calories.$gte = parseInt(filters.minCalories);
        }
        if (filters.maxCalories) {
          query.calories.$lte = parseInt(filters.maxCalories);
        }
      }

      const workouts = await Workout.find(query)
        .sort({ date: -1 })
        .exec();

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
  ): Promise<IWorkout | null> {
    try {
      console.log(`🔄 Fetching workout ${workoutId} for user: ${userId}`);

      if (!mongoose.Types.ObjectId.isValid(workoutId)) {
        console.log(`⚠️ Invalid workout ID format: ${workoutId}`);
        return null;
      }

      const workout = await Workout.findOne({
        _id: new mongoose.Types.ObjectId(workoutId),
        userId: new mongoose.Types.ObjectId(userId)
      }).exec();

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
  ): Promise<IWorkout | null> {
    try {
      console.log(`🔄 Updating workout ${workoutId} for user: ${userId}`);

      if (!mongoose.Types.ObjectId.isValid(workoutId)) {
        console.log(`⚠️ Invalid workout ID format: ${workoutId}`);
        return null;
      }

      const workout = await Workout.findOneAndUpdate(
        {
          _id: new mongoose.Types.ObjectId(workoutId),
          userId: new mongoose.Types.ObjectId(userId)
        },
        {
          ...workoutData,
          date: workoutData.date || new Date()
        },
        {
          new: true,
          runValidators: true
        }
      ).exec();

      if (!workout) {
        console.log(`⚠️ Workout not found or access denied: ${workoutId}`);
        return null;
      }

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
  ): Promise<IWorkout | null> {
    try {
      console.log(`🔄 Patching workout ${workoutId} for user: ${userId}`);

      if (!mongoose.Types.ObjectId.isValid(workoutId)) {
        console.log(`⚠️ Invalid workout ID format: ${workoutId}`);
        return null;
      }

      const workout = await Workout.findOneAndUpdate(
        {
          _id: new mongoose.Types.ObjectId(workoutId),
          userId: new mongoose.Types.ObjectId(userId)
        },
        { $set: workoutData },
        {
          new: true,
          runValidators: true
        }
      ).exec();

      if (!workout) {
        console.log(`⚠️ Workout not found or access denied: ${workoutId}`);
        return null;
      }

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

      if (!mongoose.Types.ObjectId.isValid(workoutId)) {
        console.log(`⚠️ Invalid workout ID format: ${workoutId}`);
        return false;
      }

      const result = await Workout.findOneAndDelete({
        _id: new mongoose.Types.ObjectId(workoutId),
        userId: new mongoose.Types.ObjectId(userId)
      }).exec();

      if (!result) {
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

      const stats = await Workout.aggregate([
        {
          $match: { userId: new mongoose.Types.ObjectId(userId) }
        },
        {
          $group: {
            _id: null,
            totalWorkouts: { $sum: 1 },
            totalDuration: { $sum: '$duration' },
            totalCalories: { $sum: '$calories' },
            avgDuration: { $avg: '$duration' },
            avgCalories: { $avg: '$calories' },
            workoutsByType: {
              $push: {
                type: '$type',
                count: 1
              }
            }
          }
        }
      ]);

      console.log(`✅ Workout statistics fetched for user: ${userId}`);
      return stats[0] || {
        totalWorkouts: 0,
        totalDuration: 0,
        totalCalories: 0,
        avgDuration: 0,
        avgCalories: 0
      };
    } catch (error) {
      console.error('❌ Error fetching workout statistics:', error);
      throw error;
    }
  }
}
