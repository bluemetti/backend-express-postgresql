import { Request, Response } from 'express';
import { WorkoutService, CreateWorkoutData, UpdateWorkoutData } from '../services/WorkoutService';

export class WorkoutController {
  /**
   * POST /workouts - Create a new workout
   */
  static async createWorkout(req: Request, res: Response): Promise<void> {
    try {
      const userId = (req as any).user?.userId;
      const workoutData: CreateWorkoutData = req.body;

      console.log(`🔄 Workout creation attempt by user: ${userId}`);

      const workout = await WorkoutService.createWorkout(workoutData, userId);

      res.status(201).json({
        message: 'Workout created successfully',
        workout: {
          id: workout._id,
          name: workout.name,
          type: workout.type,
          duration: workout.duration,
          calories: workout.calories,
          exercises: workout.exercises,
          date: workout.date,
          notes: workout.notes,
          createdAt: workout.createdAt
        }
      });
    } catch (error: any) {
      console.error('❌ Workout creation controller error:', error);

      // Validation errors
      if (error.name === 'ValidationError') {
        const validationErrors = Object.values(error.errors).map((err: any) => err.message);
        console.log(`⚠️ Validation error during workout creation: ${validationErrors.length} error(s)`);
        
        res.status(422).json({
          message: 'Validation error',
          errors: validationErrors
        });
        return;
      }

      res.status(500).json({
        message: 'Internal server error while creating workout'
      });
    }
  }

  /**
   * GET /workouts - Get all workouts (with optional filters)
   */
  static async getWorkouts(req: Request, res: Response): Promise<void> {
    try {
      const userId = (req as any).user?.userId;
      const filters = req.query;

      console.log(`🔄 Fetching workouts for user: ${userId}`);

      const workouts = await WorkoutService.getWorkouts(userId, filters);

      res.status(200).json({
        message: 'Workouts retrieved successfully',
        count: workouts.length,
        workouts: workouts.map(workout => ({
          id: workout._id,
          name: workout.name,
          type: workout.type,
          duration: workout.duration,
          calories: workout.calories,
          exercises: workout.exercises,
          date: workout.date,
          notes: workout.notes,
          createdAt: workout.createdAt,
          updatedAt: workout.updatedAt
        }))
      });
    } catch (error) {
      console.error('❌ Get workouts controller error:', error);

      res.status(500).json({
        message: 'Internal server error while fetching workouts'
      });
    }
  }

  /**
   * GET /workouts/:id - Get a single workout by ID
   */
  static async getWorkoutById(req: Request, res: Response): Promise<void> {
    try {
      const userId = (req as any).user?.userId;
      const { id } = req.params;

      console.log(`🔄 Fetching workout ${id} for user: ${userId}`);

      const workout = await WorkoutService.getWorkoutById(id, userId);

      if (!workout) {
        console.log(`⚠️ Workout not found or access denied: ${id}`);
        res.status(404).json({
          message: 'Workout not found or you do not have permission to access it'
        });
        return;
      }

      res.status(200).json({
        message: 'Workout retrieved successfully',
        workout: {
          id: workout._id,
          name: workout.name,
          type: workout.type,
          duration: workout.duration,
          calories: workout.calories,
          exercises: workout.exercises,
          date: workout.date,
          notes: workout.notes,
          createdAt: workout.createdAt,
          updatedAt: workout.updatedAt
        }
      });
    } catch (error) {
      console.error('❌ Get workout by ID controller error:', error);

      res.status(500).json({
        message: 'Internal server error while fetching workout'
      });
    }
  }

  /**
   * PUT /workouts/:id - Full update of a workout
   */
  static async updateWorkout(req: Request, res: Response): Promise<void> {
    try {
      const userId = (req as any).user?.userId;
      const { id } = req.params;
      const workoutData: CreateWorkoutData = req.body;

      console.log(`🔄 Full update of workout ${id} by user: ${userId}`);

      const workout = await WorkoutService.updateWorkout(id, userId, workoutData);

      if (!workout) {
        console.log(`⚠️ Workout not found or access denied: ${id}`);
        res.status(404).json({
          message: 'Workout not found or you do not have permission to update it'
        });
        return;
      }

      res.status(200).json({
        message: 'Workout updated successfully',
        workout: {
          id: workout._id,
          name: workout.name,
          type: workout.type,
          duration: workout.duration,
          calories: workout.calories,
          exercises: workout.exercises,
          date: workout.date,
          notes: workout.notes,
          updatedAt: workout.updatedAt
        }
      });
    } catch (error: any) {
      console.error('❌ Update workout controller error:', error);

      // Validation errors
      if (error.name === 'ValidationError') {
        const validationErrors = Object.values(error.errors).map((err: any) => err.message);
        console.log(`⚠️ Validation error during workout update: ${validationErrors.length} error(s)`);
        
        res.status(422).json({
          message: 'Validation error',
          errors: validationErrors
        });
        return;
      }

      res.status(500).json({
        message: 'Internal server error while updating workout'
      });
    }
  }

  /**
   * PATCH /workouts/:id - Partial update of a workout
   */
  static async patchWorkout(req: Request, res: Response): Promise<void> {
    try {
      const userId = (req as any).user?.userId;
      const { id } = req.params;
      const workoutData: UpdateWorkoutData = req.body;

      console.log(`🔄 Partial update of workout ${id} by user: ${userId}`);

      const workout = await WorkoutService.patchWorkout(id, userId, workoutData);

      if (!workout) {
        console.log(`⚠️ Workout not found or access denied: ${id}`);
        res.status(404).json({
          message: 'Workout not found or you do not have permission to update it'
        });
        return;
      }

      res.status(200).json({
        message: 'Workout updated successfully',
        workout: {
          id: workout._id,
          name: workout.name,
          type: workout.type,
          duration: workout.duration,
          calories: workout.calories,
          exercises: workout.exercises,
          date: workout.date,
          notes: workout.notes,
          updatedAt: workout.updatedAt
        }
      });
    } catch (error: any) {
      console.error('❌ Patch workout controller error:', error);

      // Validation errors
      if (error.name === 'ValidationError') {
        const validationErrors = Object.values(error.errors).map((err: any) => err.message);
        console.log(`⚠️ Validation error during workout patch: ${validationErrors.length} error(s)`);
        
        res.status(422).json({
          message: 'Validation error',
          errors: validationErrors
        });
        return;
      }

      res.status(500).json({
        message: 'Internal server error while updating workout'
      });
    }
  }

  /**
   * DELETE /workouts/:id - Delete a workout
   */
  static async deleteWorkout(req: Request, res: Response): Promise<void> {
    try {
      const userId = (req as any).user?.userId;
      const { id } = req.params;

      console.log(`🔄 Deleting workout ${id} by user: ${userId}`);

      const deleted = await WorkoutService.deleteWorkout(id, userId);

      if (!deleted) {
        console.log(`⚠️ Workout not found or access denied: ${id}`);
        res.status(404).json({
          message: 'Workout not found or you do not have permission to delete it'
        });
        return;
      }

      res.status(200).json({
        message: 'Workout deleted successfully'
      });
    } catch (error) {
      console.error('❌ Delete workout controller error:', error);

      res.status(500).json({
        message: 'Internal server error while deleting workout'
      });
    }
  }

  /**
   * GET /workouts/stats - Get workout statistics
   */
  static async getWorkoutStats(req: Request, res: Response): Promise<void> {
    try {
      const userId = (req as any).user?.userId;

      console.log(`🔄 Fetching workout statistics for user: ${userId}`);

      const stats = await WorkoutService.getWorkoutStats(userId);

      res.status(200).json({
        message: 'Workout statistics retrieved successfully',
        stats
      });
    } catch (error) {
      console.error('❌ Get workout stats controller error:', error);

      res.status(500).json({
        message: 'Internal server error while fetching workout statistics'
      });
    }
  }
}
