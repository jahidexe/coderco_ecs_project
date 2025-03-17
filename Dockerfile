# Use Node.js base image
FROM node:20

# Set working directory inside container
WORKDIR /app

# Copy package files first
COPY app/package.json app/yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy all application files
COPY app/ ./

# Expose port 3000
EXPOSE 3000

# Set environment variables for React (Fixes long startup time)
ENV WDS_SOCKET_PORT=0
ENV CHOKIDAR_USEPOLLING=true
ENV WATCHPACK_POLLING=true
ENV FAST_REFRESH=true
ENV HOST=0.0.0.0

# Start React in development mode
CMD ["yarn", "start"]