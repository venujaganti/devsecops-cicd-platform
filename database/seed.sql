-- ============================================================
-- DevSecOps CI/CD Platform
-- Database Seed Script
-- PostgreSQL
-- ============================================================

-- ============================================================
-- Seed Users
-- ============================================================

INSERT INTO users (
    username,
    email,
    hashed_password,
    is_active
)
VALUES
(
    'admin',
    'admin@example.com',
    '$argon2id$v=19$m=65536,t=3,p=4$sn1VGeLleG6kDUutc4K//A$OMDqj6AKwuxJfA+RSsSRTHotpQN8UAWD7svrK2NNkGg',
    TRUE
),
(
    'developer',
    'developer@example.com',
    '$argon2id$v=19$m=65536,t=3,p=4$TEmefciB2EOok0dmhlUOBA$oCOSH5ZqEFhSekKVtg30YPnphf9rr4RZ0MVG1PyFRE0',
    TRUE
)
ON CONFLICT (username) DO NOTHING;


-- ============================================================
-- Seed Products
-- ============================================================

INSERT INTO products (
    name,
    description,
    price,
    stock,
    owner_id
)
SELECT
    'DevOps Laptop',
    'Development laptop for DevOps engineering',
    75000.00,
    10,
    id
FROM users
WHERE username = 'admin'
AND NOT EXISTS (
    SELECT 1
    FROM products
    WHERE name = 'DevOps Laptop'
      AND owner_id = users.id
);


INSERT INTO products (
    name,
    description,
    price,
    stock,
    owner_id
)
SELECT
    'Kubernetes Training',
    'Kubernetes learning and training package',
    4999.00,
    25,
    id
FROM users
WHERE username = 'admin'
AND NOT EXISTS (
    SELECT 1
    FROM products
    WHERE name = 'Kubernetes Training'
      AND owner_id = users.id
);


INSERT INTO products (
    name,
    description,
    price,
    stock,
    owner_id
)
SELECT
    'Cloud DevOps Course',
    'AWS and cloud DevOps training course',
    6999.00,
    20,
    id
FROM users
WHERE username = 'developer'
AND NOT EXISTS (
    SELECT 1
    FROM products
    WHERE name = 'Cloud DevOps Course'
      AND owner_id = users.id
);


-- ============================================================
-- Verification
-- ============================================================

SELECT
    'Users seeded: ' || COUNT(*)
AS result
FROM users;


SELECT
    'Products seeded: ' || COUNT(*)
AS result
FROM products;