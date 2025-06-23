# CURIMS Deployment to Railway

This document provides instructions for deploying the CURIMS application to Railway.

## Prerequisites

1. A Railway account (https://railway.app/)
2. GitHub account (if deploying from a repository)
3. Docker (for local testing)

## Deployment Steps

### 1. Prepare Your Repository

Make sure all your changes are committed to your Git repository.

### 2. Deploy to Railway

#### Option A: Using Railway Dashboard

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click "New Project" and select "Deploy from GitHub repo"
   - If prompted, connect your GitHub account and authorize Railway
   - Select your CURIMS repository
3. Railway will automatically detect the Dockerfile and start building
4. Once built, your app will be deployed and you'll get a URL

#### Option B: Using Railway CLI

1. Install Railway CLI:
   ```
   npm i -g @railway/cli
   ```
2. Login to Railway:
   ```
   railway login
   ```
3. Link your project:
   ```
   railway link
   ```
4. Deploy your application:
   ```
   railway up
   ```

### 3. Configure Environment Variables

After deployment, you'll need to set up any required environment variables in the Railway dashboard:

1. Go to your project in Railway
2. Navigate to the "Variables" tab
3. Add any database connection strings or other configuration variables

### 4. Access Your Application

Once deployed, Railway will provide you with a URL where your application is accessible.

## Local Development with Docker

To test the Docker container locally before deploying to Railway:

1. Build the Docker image:
   ```
   docker build -t curims .
   ```
2. Run the container:
   ```
   docker run -p 8080:80 curims
   ```
3. Access the application at http://localhost:8080

## Database Configuration

If your application requires a database:

1. Add a PostgreSQL or MySQL database in Railway
2. Get the connection string from the database service
3. Add it as an environment variable in your application

## Troubleshooting

- Check the logs in the Railway dashboard for any deployment errors
- Ensure all required Perl modules are listed in the Dockerfile
- Verify file permissions on your CGI scripts (should be executable)
