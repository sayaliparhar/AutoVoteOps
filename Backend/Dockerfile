# Use a lightweight Node.js image
FROM node:18-alpine

# Create and change to the app directory
WORKDIR /usr/src/app

# Copy dependency files first for better caching
COPY package*.json ./

# Install only production dependencies
RUN npm install --production

# Copy the rest of the backend source code
COPY . .

# The app runs on port 3000
EXPOSE 3000

# Command to run the app
CMD ["node", "server.js"]