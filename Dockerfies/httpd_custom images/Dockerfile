# Use the official httpd image as the base image
FROM httpd:latest

# Set the working directory to /usr/local/apache2/htdocs/
WORKDIR /usr/local/apache2/htdocs/

# Remove the existing index.html file
RUN rm -rf index.html

# Create a new index.html file with the specified content
RUN echo "<html><h1>Server-01</h1></html>" > index.html
