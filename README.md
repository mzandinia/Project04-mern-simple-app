# MERN Simple App - Local Development

This project includes a Docker Compose setup for local development with a Node.js backend and MongoDB database.

## Prerequisites

- Docker
- Docker Compose

## Getting Started

1. **Clone the repository** (if not already done)

2. **Start the application**
   ```bash
   docker-compose up --build
   ```

3. **Access the application**
   - Backend API: http://localhost:3000
   - MongoDB: localhost:27017

## Available Commands

- **Start services**: `docker-compose up`
- **Start services in background**: `docker-compose up -d`
- **Build and start**: `docker-compose up --build`
- **Stop services**: `docker-compose down`
- **View logs**: `docker-compose logs`
- **View backend logs**: `docker-compose logs backend`

## Development Features

- **Hot Reload**: Code changes in the backend directory will automatically restart the server
- **Volume Mounting**: Your local code is mounted into the container for development
- **MongoDB Persistence**: Database data is persisted in a Docker volume

## API Endpoints

### Health Check
- `GET /health` - Check the health status of the API and database connection
```bash
curl http://localhost:3000/health
```
Response:
```json
{
  "status": "healthy",
  "timestamp": "2025-06-04T04:14:28.116Z",
  "database": "connected"
}
```

### Root Endpoint
- `GET /` - Welcome message
```bash
curl http://localhost:3000/
```
Response:
```json
{
  "message": "Welcome to the MERN Simple App API"
}
```

### Products
- `POST /api/products` - Create a new product

Example request:
```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Sample Product",
    "price": 29.99,
    "image": "https://example.com/image.jpg"
  }'
```

Success Response (201):
```json
{
  "success": true,
  "data": {
    "name": "Sample Product",
    "price": 29.99,
    "image": "https://example.com/image.jpg",
    "_id": "...",
    "createdAt": "...",
    "updatedAt": "...",
    "__v": 0
  }
}
```

Error Response (400) - Missing Fields:
```json
{
  "success": false,
  "message": "Please provide all fields"
}
```

Error Response (500) - Server Error:
```json
{
  "success": false,
  "message": "Server Error"
}
```

## Environment Variables

The following environment variables are configured for local development:

- `NODE_ENV=development`
- `DBUsername=admin`
- `DBPassword=password123`
- `DBHost=mongodb`
- `DBPort=27017`

## Troubleshooting

1. **Port conflicts**: If port 3000 or 27017 are already in use, modify the ports in `docker-compose.yml`
2. **Permission issues**: Ensure Docker has proper permissions to access your project directory
3. **Database connection issues**: Check that MongoDB container is running with `docker-compose ps`

## Production Deployment

For production deployment, the application uses:
- AWS DocumentDB for the database
- AWS App Runner for container hosting
- GitHub Actions for CI/CD

The production configuration automatically handles TLS certificates and authentication for DocumentDB.
