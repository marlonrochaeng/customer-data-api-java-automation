# Use a base image with Python and Robot Framework pre-installed
# Having the API running in the background

FROM python:3.12-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project directory into the container
COPY . .

# Expose any necessary ports (if applicable)
#    EXPOSE <port_number>

# Command to run the Robot Framework tests
CMD ["robot", "."]
