# # Use Node.js 16 slim as the base image
# FROM node:16-slim

# # Set the working directory
# WORKDIR /app

# # Copy package.json and package-lock.json to the working directory
# COPY package*.json ./

# # Install dependencies
# RUN npm install

# # Copy the rest of the application code
# COPY . .

# # Build the React app
# RUN npm run build

# # Expose port 3000 (or the port your app is configured to listen on)
# EXPOSE 3000

# # Start your Node.js server (assuming it serves the React app)  
# CMD ["npm", "start"]

# Stage 1: Build React app
FROM node:16-slim AS build
WORKDIR /app

# Copy only package files first for caching
COPY package*.json ./
RUN npm install

# Copy source code and build
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy optimized build from Stage 1
COPY --from=build /app/build .

# Expose port 80
EXPOSE 80

# Nginx serves static files automatically
