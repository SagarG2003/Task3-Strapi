# Use the official Strapi image as a parent image
FROM strapi/strapi

# Set working directory
WORKDIR /srv/app

# Copy the current directory contents into the container at /srv/app
COPY . /srv/app

# Install dependencies
RUN npm install

# Expose the port the app runs on
EXPOSE 1337

# Start the Strapi application
CMD ["npm", "start"]
