import mongoose, { Schema, Document } from 'mongoose';

export interface IExercise {
  name: string;
  sets?: number;
  reps?: number;
  weight?: number;
  distance?: number;
  time?: number;
}

export interface IWorkout extends Document {
  name: string;
  type: 'cardio' | 'strength' | 'flexibility' | 'sports' | 'other';
  duration: number; // in minutes
  calories?: number;
  exercises: IExercise[];
  date: Date;
  notes?: string;
  userId: mongoose.Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

const exerciseSchema = new Schema({
  name: {
    type: String,
    required: [true, 'Exercise name is required'],
    trim: true,
    minlength: [2, 'Exercise name must be at least 2 characters long'],
    maxlength: [100, 'Exercise name cannot exceed 100 characters']
  },
  sets: {
    type: Number,
    min: [1, 'Sets must be at least 1'],
    max: [100, 'Sets cannot exceed 100']
  },
  reps: {
    type: Number,
    min: [1, 'Reps must be at least 1'],
    max: [1000, 'Reps cannot exceed 1000']
  },
  weight: {
    type: Number,
    min: [0, 'Weight cannot be negative'],
    max: [1000, 'Weight cannot exceed 1000kg']
  },
  distance: {
    type: Number,
    min: [0, 'Distance cannot be negative'],
    max: [1000, 'Distance cannot exceed 1000km']
  },
  time: {
    type: Number,
    min: [0, 'Time cannot be negative'],
    max: [1440, 'Time cannot exceed 1440 minutes (24 hours)']
  }
}, { _id: false });

const workoutSchema: Schema<IWorkout> = new Schema({
  name: {
    type: String,
    required: [true, 'Workout name is required'],
    trim: true,
    minlength: [3, 'Workout name must be at least 3 characters long'],
    maxlength: [100, 'Workout name cannot exceed 100 characters']
  },
  type: {
    type: String,
    enum: {
      values: ['cardio', 'strength', 'flexibility', 'sports', 'other'],
      message: 'Type must be one of: cardio, strength, flexibility, sports, other'
    },
    required: [true, 'Workout type is required']
  },
  duration: {
    type: Number,
    required: [true, 'Duration is required'],
    min: [1, 'Duration must be at least 1 minute'],
    max: [1440, 'Duration cannot exceed 1440 minutes (24 hours)']
  },
  calories: {
    type: Number,
    min: [0, 'Calories cannot be negative'],
    max: [10000, 'Calories cannot exceed 10000']
  },
  exercises: {
    type: [exerciseSchema],
    validate: {
      validator: function(exercises: IExercise[]) {
        return exercises && exercises.length > 0;
      },
      message: 'At least one exercise is required'
    }
  },
  date: {
    type: Date,
    required: [true, 'Workout date is required'],
    default: Date.now
  },
  notes: {
    type: String,
    trim: true,
    maxlength: [1000, 'Notes cannot exceed 1000 characters']
  },
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'User ID is required'],
    index: true
  }
}, {
  timestamps: true
});

// Compound indexes for efficient querying
workoutSchema.index({ userId: 1, date: -1 });
workoutSchema.index({ userId: 1, type: 1 });
workoutSchema.index({ userId: 1, createdAt: -1 });

export const Workout = mongoose.model<IWorkout>('Workout', workoutSchema);
