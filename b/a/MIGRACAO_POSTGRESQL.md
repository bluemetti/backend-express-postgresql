# 🔄 Guia Completo: Migração MongoDB → PostgreSQL

## 📋 Índice
1. [Pré-requisitos](#1-pré-requisitos)
2. [Atualizar Dependências](#2-atualizar-dependências)
3. [Configurar PostgreSQL Local](#3-configurar-postgresql-local)
4. [Configurar PostgreSQL na Nuvem](#4-configurar-postgresql-na-nuvem)
5. [Migrar Models](#5-migrar-models)
6. [Migrar Database Connection](#6-migrar-database-connection)
7. [Migrar Services](#7-migrar-services)
8. [Atualizar .env](#8-atualizar-env)
9. [Testar](#9-testar)
10. [Deploy](#10-deploy)

---

## 1️⃣ Pré-requisitos

✅ **Já feito:**
- Docker Compose atualizado
- Dependências instaladas (`pg`, `typeorm`, `reflect-metadata`)

---

## 2️⃣ Atualizar Dependências

### Instalar PostgreSQL e TypeORM:
```bash
cd /workspaces/backend-express-postgresql/b/a
npm install pg @types/pg typeorm reflect-metadata
npm uninstall mongoose
```

### Atualizar package.json:
```json
{
  "dependencies": {
    "pg": "^8.11.0",
    "typeorm": "^0.3.17",
    "reflect-metadata": "^0.1.13",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2"
  },
  "devDependencies": {
    "@types/pg": "^8.10.0"
  }
}
```

---

## 3️⃣ Configurar PostgreSQL Local (Docker)

### Docker Compose já está configurado com:

**PostgreSQL:**
- Imagem: `postgres:16-alpine`
- Porta: `5432`
- Database: `jwt_auth_db`
- User: `postgres`
- Password: `postgres123`

**pgAdmin (Interface Web):**
- Porta: `8081`
- URL: http://localhost:8081
- Email: `admin@admin.com`
- Password: `admin123`

### Iniciar containers:
```bash
cd /workspaces/backend-express-postgresql/b/a
docker-compose up -d
```

### Verificar se está rodando:
```bash
docker-compose ps
```

---

## 4️⃣ Configurar PostgreSQL na Nuvem

### Opções de Serviços:

#### A) **Neon (Recomendado - Grátis)**
1. Acesse: https://neon.tech/
2. Crie uma conta
3. Crie um novo projeto
4. Copie a **Connection String**:
   ```
   postgresql://user:password@ep-xxx.neon.tech/dbname?sslmode=require
   ```

#### B) **Supabase (Alternativa)**
1. Acesse: https://supabase.com/
2. Crie um novo projeto
3. Vá em Settings → Database
4. Copie a **Connection String** (Direct connection)

#### C) **Render (Alternativa)**
1. Acesse: https://render.com/
2. New → PostgreSQL
3. Copie a **External Database URL**

---

## 5️⃣ Migrar Models

### Criar arquivo de configuração TypeORM:

**src/data-source.ts:**
```typescript
import "reflect-metadata";
import { DataSource } from "typeorm";
import { User } from "./models/User";
import { Workout } from "./models/Workout";

export const AppDataSource = new DataSource({
  type: "postgres",
  url: process.env.DATABASE_URL || undefined,
  host: process.env.DB_HOST || "localhost",
  port: parseInt(process.env.DB_PORT || "5432"),
  username: process.env.DB_USERNAME || "postgres",
  password: process.env.DB_PASSWORD || "postgres123",
  database: process.env.DB_DATABASE || "jwt_auth_db",
  synchronize: process.env.NODE_ENV === "development",
  logging: process.env.NODE_ENV === "development",
  entities: [User, Workout],
  migrations: ["src/migrations/*.ts"],
  subscribers: [],
  ssl: process.env.DATABASE_URL ? { rejectUnauthorized: false } : false,
});
```

### Migrar Model User:

**Antes (Mongoose):**
```typescript
import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true }
}, { timestamps: true });

export const User = mongoose.model('User', userSchema);
```

**Depois (TypeORM):**
```typescript
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from "typeorm";
import { Workout } from "./Workout";

@Entity("users")
export class User {
  @PrimaryGeneratedColumn("uuid")
  id: string;

  @Column({ type: "varchar", length: 100 })
  name: string;

  @Column({ type: "varchar", length: 255, unique: true })
  email: string;

  @Column({ type: "varchar", length: 255 })
  password: string;

  @OneToMany(() => Workout, (workout) => workout.user)
  workouts: Workout[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

### Migrar Model Workout:

**Antes (Mongoose):**
```typescript
import mongoose from 'mongoose';

const exerciseSchema = new mongoose.Schema({
  name: String,
  sets: Number,
  reps: Number,
  weight: Number,
  rest: Number
});

const workoutSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  name: String,
  type: String,
  duration: Number,
  calories: Number,
  exercises: [exerciseSchema],
  date: Date,
  notes: String
}, { timestamps: true });

export const Workout = mongoose.model('Workout', workoutSchema);
```

**Depois (TypeORM):**
```typescript
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from "typeorm";
import { User } from "./User";

@Entity("workouts")
export class Workout {
  @PrimaryGeneratedColumn("uuid")
  id: string;

  @Column({ type: "uuid" })
  userId: string;

  @ManyToOne(() => User, (user) => user.workouts, { onDelete: "CASCADE" })
  @JoinColumn({ name: "userId" })
  user: User;

  @Column({ type: "varchar", length: 100 })
  name: string;

  @Column({ type: "varchar", length: 20 })
  type: string;

  @Column({ type: "int" })
  duration: number;

  @Column({ type: "int" })
  calories: number;

  @Column({ type: "jsonb" })
  exercises: {
    name: string;
    sets: number;
    reps: number;
    weight?: number;
    rest?: number;
  }[];

  @Column({ type: "timestamp", default: () => "CURRENT_TIMESTAMP" })
  date: Date;

  @Column({ type: "text", nullable: true })
  notes: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

---

## 6️⃣ Migrar Database Connection

**src/database/connection.ts:**

**Antes (Mongoose):**
```typescript
import mongoose from 'mongoose';

export const connectDB = async () => {
  const uri = process.env.MONGODB_URI || 'mongodb://localhost:27017/jwt-auth-db';
  await mongoose.connect(uri);
  console.log('MongoDB Connected');
};
```

**Depois (TypeORM):**
```typescript
import { AppDataSource } from "../data-source";

export const connectDB = async (): Promise<void> => {
  try {
    await AppDataSource.initialize();
    console.log("✅ PostgreSQL Connected");
    console.log(`📊 Database: ${AppDataSource.options.database}`);
  } catch (error) {
    console.error("❌ Error connecting to PostgreSQL:", error);
    throw error;
  }
};

export const closeDB = async (): Promise<void> => {
  if (AppDataSource.isInitialized) {
    await AppDataSource.destroy();
    console.log("PostgreSQL Disconnected");
  }
};
```

---

## 7️⃣ Migrar Services

### AuthService:

**Antes (Mongoose):**
```typescript
import { User } from '../models/User';

export class AuthService {
  static async register(data) {
    const existingUser = await User.findOne({ email: data.email });
    if (existingUser) throw new Error('Email already exists');
    
    const user = new User(data);
    await user.save();
    return user;
  }
  
  static async login(email: string) {
    const user = await User.findOne({ email });
    return user;
  }
}
```

**Depois (TypeORM):**
```typescript
import { AppDataSource } from "../data-source";
import { User } from "../models/User";

const userRepository = AppDataSource.getRepository(User);

export class AuthService {
  static async register(data: { name: string; email: string; password: string }) {
    const existingUser = await userRepository.findOne({
      where: { email: data.email }
    });
    
    if (existingUser) {
      throw new Error('Email already exists');
    }
    
    const user = userRepository.create(data);
    await userRepository.save(user);
    return user;
  }
  
  static async login(email: string) {
    const user = await userRepository.findOne({
      where: { email }
    });
    return user;
  }
}
```

### WorkoutService:

**Antes (Mongoose):**
```typescript
import { Workout } from '../models/Workout';

export class WorkoutService {
  static async create(data) {
    const workout = new Workout(data);
    await workout.save();
    return workout;
  }
  
  static async getWorkouts(userId: string, filters: any) {
    const query = { userId, ...filters };
    return await Workout.find(query);
  }
  
  static async getById(id: string, userId: string) {
    return await Workout.findOne({ _id: id, userId });
  }
  
  static async update(id: string, userId: string, data: any) {
    return await Workout.findOneAndUpdate(
      { _id: id, userId },
      data,
      { new: true }
    );
  }
  
  static async delete(id: string, userId: string) {
    return await Workout.findOneAndDelete({ _id: id, userId });
  }
}
```

**Depois (TypeORM):**
```typescript
import { AppDataSource } from "../data-source";
import { Workout } from "../models/Workout";
import { Between, LessThanOrEqual, MoreThanOrEqual } from "typeorm";

const workoutRepository = AppDataSource.getRepository(Workout);

export class WorkoutService {
  static async create(data: Partial<Workout>) {
    const workout = workoutRepository.create(data);
    await workoutRepository.save(workout);
    return workout;
  }
  
  static async getWorkouts(userId: string, filters: any) {
    const where: any = { userId };
    
    if (filters.type) where.type = filters.type;
    if (filters.dateFrom && filters.dateTo) {
      where.date = Between(new Date(filters.dateFrom), new Date(filters.dateTo));
    } else if (filters.dateFrom) {
      where.date = MoreThanOrEqual(new Date(filters.dateFrom));
    } else if (filters.dateTo) {
      where.date = LessThanOrEqual(new Date(filters.dateTo));
    }
    
    return await workoutRepository.find({ where, order: { date: "DESC" } });
  }
  
  static async getById(id: string, userId: string) {
    return await workoutRepository.findOne({
      where: { id, userId }
    });
  }
  
  static async update(id: string, userId: string, data: Partial<Workout>) {
    const workout = await this.getById(id, userId);
    if (!workout) return null;
    
    Object.assign(workout, data);
    await workoutRepository.save(workout);
    return workout;
  }
  
  static async delete(id: string, userId: string) {
    const workout = await this.getById(id, userId);
    if (!workout) return null;
    
    await workoutRepository.remove(workout);
    return workout;
  }
  
  static async getStats(userId: string) {
    const workouts = await workoutRepository.find({ where: { userId } });
    
    return {
      totalWorkouts: workouts.length,
      totalDuration: workouts.reduce((sum, w) => sum + w.duration, 0),
      totalCalories: workouts.reduce((sum, w) => sum + w.calories, 0),
      byType: workouts.reduce((acc, w) => {
        acc[w.type] = (acc[w.type] || 0) + 1;
        return acc;
      }, {} as Record<string, number>)
    };
  }
}
```

---

## 8️⃣ Atualizar .env

### LOCAL (Docker):
```bash
# PostgreSQL LOCAL
DB_TYPE=postgres
DB_HOST=postgres
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres123
DB_DATABASE=jwt_auth_db

# JWT
JWT_SECRET=e64c60b2ce4429ceb041a6f19058f726f55f0eb56b452fcba2ac4e32957fa5c9
JWT_EXPIRES_IN=24h
BCRYPT_SALT_ROUNDS=12

# Node
NODE_ENV=development
PORT=3001
```

### PRODUÇÃO (Nuvem):
```bash
# PostgreSQL NUVEM (Neon, Supabase, Render, etc)
DATABASE_URL=postgresql://user:password@host:5432/database?sslmode=require

# JWT
JWT_SECRET=e64c60b2ce4429ceb041a6f19058f726f55f0eb56b452fcba2ac4e32957fa5c9
JWT_EXPIRES_IN=24h
BCRYPT_SALT_ROUNDS=12

# Node
NODE_ENV=production
PORT=3001
```

---

## 9️⃣ Testar

### 1. Parar containers antigos (MongoDB):
```bash
docker-compose down -v
```

### 2. Iniciar novos containers (PostgreSQL):
```bash
docker-compose up -d
```

### 3. Verificar logs:
```bash
docker logs jwt-auth-app-local --tail 50
```

### 4. Testar health check:
```bash
curl http://localhost:3001/health
```

### 5. Acessar pgAdmin:
- URL: http://localhost:8081
- Email: admin@admin.com
- Password: admin123

### 6. Conectar ao PostgreSQL no pgAdmin:
1. Clique em "Add New Server"
2. **General Tab:**
   - Name: `Local PostgreSQL`
3. **Connection Tab:**
   - Host: `postgres`
   - Port: `5432`
   - Database: `jwt_auth_db`
   - Username: `postgres`
   - Password: `postgres123`

---

## 🔟 Deploy

### Vercel + Neon PostgreSQL:

1. **Criar banco no Neon:**
   - https://neon.tech/
   - Copiar DATABASE_URL

2. **Configurar variáveis no Vercel:**
   ```
   DATABASE_URL=postgresql://...
   JWT_SECRET=sua-chave-secreta
   JWT_EXPIRES_IN=24h
   BCRYPT_SALT_ROUNDS=12
   NODE_ENV=production
   ```

3. **Deploy:**
   ```bash
   vercel --prod
   ```

---

## 📊 Comparação MongoDB vs PostgreSQL

| Recurso | MongoDB | PostgreSQL |
|---------|---------|------------|
| **Tipo** | NoSQL (Document) | SQL (Relational) |
| **Schema** | Flexível | Rígido (TypeORM) |
| **Queries** | find(), aggregate() | SQL / Repository |
| **Relacionamentos** | ref, populate | JOIN, Foreign Keys |
| **Transações** | Sim | Sim |
| **JSON** | Nativo (BSON) | JSONB |
| **Interface Web** | Mongo Express | pgAdmin |
| **Nuvem Grátis** | Atlas (512MB) | Neon (3GB) |

---

## ✅ Checklist Final

- [ ] Dependências instaladas
- [ ] Docker Compose atualizado
- [ ] Models migrados para TypeORM
- [ ] Database connection atualizada
- [ ] Services refatorados
- [ ] .env configurado
- [ ] Containers rodando
- [ ] Health check funcionando
- [ ] pgAdmin acessível
- [ ] PostgreSQL na nuvem configurado
- [ ] Deploy testado

---

**Migração completa! 🎉**
