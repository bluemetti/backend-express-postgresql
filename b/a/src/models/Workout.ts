import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';

export class Exercise {
  @Column({ type: 'varchar', length: 100 })
  name!: string;

  @Column({ type: 'int', nullable: true })
  sets?: number;

  @Column({ type: 'int', nullable: true })
  reps?: number;

  @Column({ type: 'decimal', precision: 6, scale: 2, nullable: true })
  weight?: number;

  @Column({ type: 'decimal', precision: 6, scale: 2, nullable: true })
  distance?: number;

  @Column({ type: 'int', nullable: true })
  time?: number;
}

@Entity('workouts')
@Index(['userId', 'date'])
@Index(['userId', 'type'])
@Index(['userId', 'createdAt'])
export class Workout {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'varchar', length: 100 })
  name!: string;

  @Column({
    type: 'enum',
    enum: ['cardio', 'strength', 'flexibility', 'sports', 'other']
  })
  type!: 'cardio' | 'strength' | 'flexibility' | 'sports' | 'other';

  @Column({ type: 'int' })
  duration!: number;

  @Column({ type: 'int', nullable: true })
  calories?: number;

  @Column({ type: 'jsonb' })
  exercises!: Exercise[];

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  date!: Date;

  @Column({ type: 'varchar', length: 1000, nullable: true })
  notes?: string;

  @Column({ type: 'uuid' })
  @Index()
  userId!: string;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt!: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt!: Date;
}
