import { Request, Response, NextFunction } from 'express';

interface ValidationError {
  field: string;
  message: string;
}

// Email validation regex
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// Password validation regex - requires at least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special char
const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$/;

export const validateRegister = (req: Request, res: Response, next: NextFunction): void => {
  const { name, email, password } = req.body;
  const errors: ValidationError[] = [];

  console.log('🔍 Validating registration data...');

  // Validate name
  if (!name || typeof name !== 'string') {
    errors.push({ field: 'name', message: 'Name is required and must be a string' });
  } else if (name.trim().length < 2) {
    errors.push({ field: 'name', message: 'Name must be at least 2 characters long' });
  } else if (name.trim().length > 50) {
    errors.push({ field: 'name', message: 'Name cannot exceed 50 characters' });
  }

  // Validate email
  if (!email || typeof email !== 'string') {
    errors.push({ field: 'email', message: 'Email is required and must be a string' });
  } else if (!emailRegex.test(email.trim())) {
    errors.push({ field: 'email', message: 'Please provide a valid email address' });
  }

  // Validate password
  if (!password || typeof password !== 'string') {
    errors.push({ field: 'password', message: 'Password is required and must be a string' });
  } else if (password.length < 8) {
    errors.push({ field: 'password', message: 'Password must be at least 8 characters long' });
  } else if (!passwordRegex.test(password)) {
    errors.push({ 
      field: 'password', 
      message: 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character (@$!%*?&#)' 
    });
  }

  if (errors.length > 0) {
    console.log(`❌ Validation failed: ${errors.length} error(s) found`);
    res.status(422).json({
      success: false,
      message: 'Validation failed',
      errors: errors,
      error: 'VALIDATION_ERROR'
    });
    return;
  }

  console.log('✅ Registration validation passed');
  next();
};

export const validateLogin = (req: Request, res: Response, next: NextFunction): void => {
  const { email, password } = req.body;
  const errors: ValidationError[] = [];

  console.log('🔍 Validating login data...');

  // Validate email
  if (!email || typeof email !== 'string') {
    errors.push({ field: 'email', message: 'Email is required and must be a string' });
  } else if (!emailRegex.test(email.trim())) {
    errors.push({ field: 'email', message: 'Please provide a valid email address' });
  }

  // Validate password
  if (!password || typeof password !== 'string') {
    errors.push({ field: 'password', message: 'Password is required and must be a string' });
  }

  if (errors.length > 0) {
    console.log(`❌ Login validation failed: ${errors.length} error(s) found`);
    res.status(422).json({
      success: false,
      message: 'Validation failed',
      errors: errors,
      error: 'VALIDATION_ERROR'
    });
    return;
  }

  console.log('✅ Login validation passed');
  next();
};

export const validateJsonBody = (req: Request, res: Response, next: NextFunction): void => {
  if (req.method === 'POST' || req.method === 'PUT' || req.method === 'PATCH') {
    if (!req.body || Object.keys(req.body).length === 0) {
      res.status(400).json({
        success: false,
        message: 'Request body is required and must be valid JSON',
        error: 'INVALID_JSON'
      });
      return;
    }
  }
  next();
};

// Workout validation
export const validateWorkoutCreate = (req: Request, res: Response, next: NextFunction): void => {
  const { name, type, duration, exercises } = req.body;
  const errors: ValidationError[] = [];

  console.log('🔍 Validating workout creation data...');

  // Validate name
  if (!name || typeof name !== 'string') {
    errors.push({ field: 'name', message: 'Workout name is required and must be a string' });
  } else if (name.trim().length < 3) {
    errors.push({ field: 'name', message: 'Workout name must be at least 3 characters long' });
  } else if (name.trim().length > 100) {
    errors.push({ field: 'name', message: 'Workout name cannot exceed 100 characters' });
  }

  // Validate type
  const validTypes = ['cardio', 'strength', 'flexibility', 'sports', 'other'];
  if (!type || typeof type !== 'string') {
    errors.push({ field: 'type', message: 'Workout type is required and must be a string' });
  } else if (!validTypes.includes(type)) {
    errors.push({ field: 'type', message: `Workout type must be one of: ${validTypes.join(', ')}` });
  }

  // Validate duration
  if (!duration || typeof duration !== 'number') {
    errors.push({ field: 'duration', message: 'Duration is required and must be a number' });
  } else if (duration < 1) {
    errors.push({ field: 'duration', message: 'Duration must be at least 1 minute' });
  } else if (duration > 1440) {
    errors.push({ field: 'duration', message: 'Duration cannot exceed 1440 minutes (24 hours)' });
  }

  // Validate exercises
  if (!exercises || !Array.isArray(exercises)) {
    errors.push({ field: 'exercises', message: 'Exercises must be an array' });
  } else if (exercises.length === 0) {
    errors.push({ field: 'exercises', message: 'At least one exercise is required' });
  } else {
    exercises.forEach((exercise: any, index: number) => {
      if (!exercise.name || typeof exercise.name !== 'string') {
        errors.push({ field: `exercises[${index}].name`, message: 'Exercise name is required and must be a string' });
      } else if (exercise.name.trim().length < 2) {
        errors.push({ field: `exercises[${index}].name`, message: 'Exercise name must be at least 2 characters long' });
      }

      // Optional fields validation
      if (exercise.sets !== undefined && (typeof exercise.sets !== 'number' || exercise.sets < 1)) {
        errors.push({ field: `exercises[${index}].sets`, message: 'Sets must be a positive number' });
      }
      if (exercise.reps !== undefined && (typeof exercise.reps !== 'number' || exercise.reps < 1)) {
        errors.push({ field: `exercises[${index}].reps`, message: 'Reps must be a positive number' });
      }
      if (exercise.weight !== undefined && (typeof exercise.weight !== 'number' || exercise.weight < 0)) {
        errors.push({ field: `exercises[${index}].weight`, message: 'Weight must be a non-negative number' });
      }
      if (exercise.distance !== undefined && (typeof exercise.distance !== 'number' || exercise.distance < 0)) {
        errors.push({ field: `exercises[${index}].distance`, message: 'Distance must be a non-negative number' });
      }
      if (exercise.time !== undefined && (typeof exercise.time !== 'number' || exercise.time < 0)) {
        errors.push({ field: `exercises[${index}].time`, message: 'Time must be a non-negative number' });
      }
    });
  }

  // Validate optional fields
  if (req.body.calories !== undefined) {
    if (typeof req.body.calories !== 'number' || req.body.calories < 0) {
      errors.push({ field: 'calories', message: 'Calories must be a non-negative number' });
    }
  }

  if (req.body.date !== undefined) {
    const date = new Date(req.body.date);
    if (isNaN(date.getTime())) {
      errors.push({ field: 'date', message: 'Invalid date format' });
    }
  }

  if (req.body.notes !== undefined) {
    if (typeof req.body.notes !== 'string') {
      errors.push({ field: 'notes', message: 'Notes must be a string' });
    } else if (req.body.notes.length > 1000) {
      errors.push({ field: 'notes', message: 'Notes cannot exceed 1000 characters' });
    }
  }

  if (errors.length > 0) {
    console.log(`❌ Workout validation failed: ${errors.length} error(s) found`);
    res.status(422).json({
      success: false,
      message: 'Validation failed',
      errors: errors,
      error: 'VALIDATION_ERROR'
    });
    return;
  }

  console.log('✅ Workout validation passed');
  next();
};

export const validateWorkoutUpdate = (req: Request, res: Response, next: NextFunction): void => {
  const { name, type, duration, exercises } = req.body;
  const errors: ValidationError[] = [];

  console.log('🔍 Validating workout update data...');

  // All fields are required for PUT
  if (!name || !type || !duration || !exercises) {
    errors.push({ field: 'body', message: 'All fields (name, type, duration, exercises) are required for full update (PUT)' });
  }

  // If we have errors already, return early
  if (errors.length > 0) {
    console.log(`❌ Workout update validation failed: ${errors.length} error(s) found`);
    res.status(422).json({
      success: false,
      message: 'Validation failed',
      errors: errors,
      error: 'VALIDATION_ERROR'
    });
    return;
  }

  // Reuse create validation since PUT requires all fields
  validateWorkoutCreate(req, res, next);
};

export const validateWorkoutPatch = (req: Request, res: Response, next: NextFunction): void => {
  const errors: ValidationError[] = [];

  console.log('🔍 Validating workout patch data...');

  // At least one field must be present
  if (Object.keys(req.body).length === 0) {
    errors.push({ field: 'body', message: 'At least one field must be provided for partial update (PATCH)' });
    res.status(422).json({
      success: false,
      message: 'Validation failed',
      errors: errors,
      error: 'VALIDATION_ERROR'
    });
    return;
  }

  // Validate each field if present
  const validTypes = ['cardio', 'strength', 'flexibility', 'sports', 'other'];

  if (req.body.name !== undefined) {
    if (typeof req.body.name !== 'string' || req.body.name.trim().length < 3 || req.body.name.trim().length > 100) {
      errors.push({ field: 'name', message: 'Workout name must be between 3 and 100 characters' });
    }
  }

  if (req.body.type !== undefined) {
    if (!validTypes.includes(req.body.type)) {
      errors.push({ field: 'type', message: `Workout type must be one of: ${validTypes.join(', ')}` });
    }
  }

  if (req.body.duration !== undefined) {
    if (typeof req.body.duration !== 'number' || req.body.duration < 1 || req.body.duration > 1440) {
      errors.push({ field: 'duration', message: 'Duration must be between 1 and 1440 minutes' });
    }
  }

  if (req.body.exercises !== undefined) {
    if (!Array.isArray(req.body.exercises) || req.body.exercises.length === 0) {
      errors.push({ field: 'exercises', message: 'Exercises must be a non-empty array' });
    }
  }

  if (req.body.calories !== undefined) {
    if (typeof req.body.calories !== 'number' || req.body.calories < 0) {
      errors.push({ field: 'calories', message: 'Calories must be a non-negative number' });
    }
  }

  if (req.body.date !== undefined) {
    const date = new Date(req.body.date);
    if (isNaN(date.getTime())) {
      errors.push({ field: 'date', message: 'Invalid date format' });
    }
  }

  if (req.body.notes !== undefined) {
    if (typeof req.body.notes !== 'string' || req.body.notes.length > 1000) {
      errors.push({ field: 'notes', message: 'Notes must be a string with maximum 1000 characters' });
    }
  }

  if (errors.length > 0) {
    console.log(`❌ Workout patch validation failed: ${errors.length} error(s) found`);
    res.status(422).json({
      success: false,
      message: 'Validation failed',
      errors: errors,
      error: 'VALIDATION_ERROR'
    });
    return;
  }

  console.log('✅ Workout patch validation passed');
  next();
};
