# Use an official Node.js runtime as a parent image
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker caching
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Compile TypeScript to JavaScript
RUN npx tsc

# --- Production Stage ---
FROM node:18-alpine

WORKDIR /app

# Security: Use a non-root user
USER node

# Set production environment
ENV NODE_ENV=production

# Copy only necessary files from the builder stage
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/config ./config

# Expose the application port
EXPOSE 3000

# Command to start the API
CMD ["node", "dist/index.js"]
