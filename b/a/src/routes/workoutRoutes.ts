import express from 'express';
import { WorkoutController } from '../controllers/WorkoutController';
import { authMiddleware } from '../middlewares/authMiddleware';
import { 
  validateJsonBody, 
  validateWorkoutCreate, 
  validateWorkoutUpdate,
  validateWorkoutPatch 
} from '../middlewares/validationMiddleware';

const router = express.Router();

// All workout routes are protected by authentication
router.use(authMiddleware);

// POST /workouts - Create a new workout
router.post('/', validateJsonBody, validateWorkoutCreate, WorkoutController.createWorkout);

// GET /workouts - Get all workouts (with optional filters)
router.get('/', WorkoutController.getWorkouts);

// GET /workouts/stats - Get workout statistics
router.get('/stats', WorkoutController.getWorkoutStats);

// GET /workouts/:id - Get a single workout by ID
router.get('/:id', WorkoutController.getWorkoutById);

// PUT /workouts/:id - Full update of a workout
router.put('/:id', validateJsonBody, validateWorkoutUpdate, WorkoutController.updateWorkout);

// PATCH /workouts/:id - Partial update of a workout
router.patch('/:id', validateJsonBody, validateWorkoutPatch, WorkoutController.patchWorkout);

// DELETE /workouts/:id - Delete a workout
router.delete('/:id', WorkoutController.deleteWorkout);

export default router;
