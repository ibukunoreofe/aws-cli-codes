# Use the official Ubuntu image as a base
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment in a different directory
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install awscli and boto3 using pip in the virtual environment
RUN /opt/venv/bin/pip install awscli boto3

# Set the working directory
WORKDIR /usr/src/app

# Copy the entrypoint script
COPY entrypoint.sh /usr/src/app/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/src/app/entrypoint.sh
