# Use Node.js 20.9.0 as the base image
FROM node:20.9.0 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json files to the working directory
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Serve the React app using a lightweight HTTP server
FROM node:20.9.0-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the built app from the builder stage to the container
COPY --from=builder /app/dist /app/dist

# Expose port 5147
EXPOSE 5147

# Start the HTTP server to serve the built React app
CMD ["npx", "http-server", "-p", "5147", "dist"]
