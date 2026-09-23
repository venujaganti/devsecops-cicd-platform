## DevSecOps CI/CD Platform

This directory contains the PostgreSQL database initialization and seed scripts for the DevSecOps CI/CD Platform.

## Database Structure

```text
database/
├── init.sql
├── seed.sql
└── README.md
```

## Database Technology

The project uses:

* PostgreSQL
* SQLAlchemy
* FastAPI
* Python
* Podman
* Kubernetes

## Database Tables

### users

The `users` table stores application user accounts.

| Column          | Type         | Description           |
| --------------- | ------------ | --------------------- |
| id              | SERIAL       | Primary key           |
| username        | VARCHAR(50)  | Unique username       |
| email           | VARCHAR(255) | Unique email          |
| hashed_password | VARCHAR(255) | Hashed password       |
| is_active       | BOOLEAN      | Account status        |
| created_at      | TIMESTAMP    | Account creation time |

### products

The `products` table stores products belonging to users.

| Column      | Type             | Description               |
| ----------- | ---------------- | ------------------------- |
| id          | SERIAL           | Primary key               |
| name        | VARCHAR(150)     | Product name              |
| description | TEXT             | Product description       |
| price       | DOUBLE PRECISION | Product price             |
| stock       | INTEGER          | Available stock           |
| owner_id    | INTEGER          | User who owns the product |
| created_at  | TIMESTAMP        | Product creation time     |

## Relationship

The database uses a one-to-many relationship:

```text
users
  |
  | 1
  |
  | *
products
```

One user can own multiple products.

The `products.owner_id` column references:

```text
users.id
```

The foreign key uses:

```sql
ON DELETE CASCADE
```

Therefore, deleting a user also removes that user's products.

## Constraints

The database contains:

* Primary keys
* Unique username
* Unique email
* Foreign key relationship
* Non-null constraints
* Price validation
* Stock validation

Prices cannot be negative:

```sql
CHECK (price >= 0)
```

Stock cannot be negative:

```sql
CHECK (stock >= 0)
```

## Indexes

Indexes are created for:

```text
users.username
users.email
products.name
products.owner_id
```

These indexes improve lookup performance for commonly queried fields.

## PostgreSQL Configuration

Example connection string:

```text
postgresql+psycopg2://postgres:postgres@localhost:5432/devsecops
```

The FastAPI backend reads the database connection from:

```text
DATABASE_URL
```

Example:

```env
DATABASE_URL=postgresql+psycopg2://postgres:postgres@localhost:5432/devsecops
```

## Initialize the Database

Connect to PostgreSQL:

```bash
psql -U postgres
```

Create the database:

```sql
CREATE DATABASE devsecops;
```

Connect to it:

```sql
\c devsecops
```

Run the initialization script:

```bash
psql -U postgres -d devsecops -f database/init.sql
```

Run the seed script:

```bash
psql -U postgres -d devsecops -f database/seed.sql
```

## Verify Tables

Inside PostgreSQL:

```sql
\dt
```

Expected tables:

```text
users
products
```

## Verify Users

```sql
SELECT
    id,
    username,
    email,
    is_active,
    created_at
FROM users;
```

## Verify Products

```sql
SELECT
    id,
    name,
    price,
    stock,
    owner_id,
    created_at
FROM products;
```

## Verify Relationship

```sql
SELECT
    p.id,
    p.name,
    p.price,
    p.stock,
    u.username AS owner
FROM products p
JOIN users u
    ON p.owner_id = u.id;
```

## Verify Database Connection from Backend

Set the backend environment variable:

```env
DATABASE_URL=postgresql+psycopg2://postgres:postgres@localhost:5432/devsecops
```

Then start the FastAPI backend:

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Check:

```text
http://localhost:8000/health
```

Expected:

```json
{
    "status": "healthy"
}
```

## Development vs Production

The SQL scripts are intended for development and deployment initialization.

Production environments should additionally use:

* Strong database passwords
* Secrets management
* Database backups
* Restricted database network access
* TLS/SSL connections
* Database migrations
* Monitoring
* Least-privilege database users

Never commit real database passwords or production secrets to Git.

## Phase 4 Completion

Phase 4 provides:

* PostgreSQL schema
* Users table
* Products table
* Primary keys
* Foreign keys
* Unique constraints
* Validation constraints
* Database indexes
* Development seed data
* Database verification commands

The database is ready for the next DevSecOps phases.
