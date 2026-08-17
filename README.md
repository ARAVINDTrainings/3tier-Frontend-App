init.sql file:
-------------------

CREATE TABLE IF NOT EXISTS students (
 id INT AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(255) NOT NULL,
 age INT NOT NULL,
 class VARCHAR(100) NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


Docker Compose file:
---------------------

services:
 frontend:
  build:
   context: ./frontend
   dockerfile: Dockerfile
  container_name: frontend
  ports:
   - "80:80"
  depends_on:
   - backend
 backend:
  build:
   context: ./backend
   dockerfile: Dockerfile
  container_name: backend
  ports:
   - "3000:3000"
  env_file:
   - ./backend/.env
  depends_on:
   - redis
   - mysql
 mysql:
  image: mysql:8.0
  container_name: mysql
  environment:
   - MYSQL_ROOT_PASSWORD=admin123
   - MYSQL_DATABASE=schooldb
   - MYSQL_USER=admin
   - MYSQL_PASSWORD=admin123
  ports:
   - "3306:3306"
  volumes:
   - ./mysql_data:/var/lib/mysql
   - ./init.sql:/docker-entrypoint-initdb.d/init.sql
 redis:
  image: redis:alpine
  container_name: redis
  ports:
   - "6379:6379"
  volumes:
   - ./redis_data:/data

backend/.env
------------
DB_HOST=mysql
DB_USER=admin
DB_PASSWORD=admin123
DB_NAME=schooldb
REDIS_URL=redis://redis:6379

frontend/.env
-------------
VITE_API_URL=http://<public-ip>/api
