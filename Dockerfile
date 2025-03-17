# Stage 1: Install dependencies
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files first (Better caching)
COPY app/package.json app/yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Stage 2: Final minimal image
FROM node:20-alpine
WORKDIR /app

# Copy only required files
COPY --from=builder /app/node_modules ./node_modules
COPY app/ ./

# Expose port
EXPOSE 3000

# Start React app
CMD ["yarn", "start"]