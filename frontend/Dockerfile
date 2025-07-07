# Multi-stage build for testing-again React frontend
FROM node:20-alpine as build

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci --only=production

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage with nginx
FROM nginx:1.29-alpine

# Copy built assets from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 3000 (to match Score.dev service)
EXPOSE 3000

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
