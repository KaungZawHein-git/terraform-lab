# Use the official Node.js image based on Ubuntu
FROM node:14

# Set the working directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/docker/getting-started-app.git .

# Install dependencies using yarn
RUN yarn install --production

# Expose the port used by the application
EXPOSE 3000

# Start the application
CMD ["node", "src/index.js"]