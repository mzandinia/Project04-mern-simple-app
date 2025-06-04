FROM node:20-slim

# Create app directory
WORKDIR /usr/src/app

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 --ingroup nodejs nodeuser

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --omit=dev

# Copy app source
COPY . .

# Install wget and download the Amazon DocumentDB certificate
RUN apt-get update && apt-get install -y wget && \
    wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

# Change ownership to non-root user
RUN chown -R nodeuser:nodejs .

# Switch to non-root user
USER nodeuser

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]
