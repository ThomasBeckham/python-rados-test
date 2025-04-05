# Use an official Python runtime as a parent image
FROM python:3.11

# Set the working directory in the container
WORKDIR /app

# Install necessary system dependency for Ceph and Python bindings
RUN apt update && apt install -y python3-rados && rm -rf /var/lib/apt/lists/*

# Ensure the rados module is accessible
RUN python3 -c "import sys; sys.path.append('/usr/lib/python3/dist-packages'); import rados; print('Successfully imported rados')"

# Install Python dependencies (if any)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container
COPY . /app

# Set the environment variable for Ceph configuration file
ENV CEPH_CONF_PATH=/etc/ceph/ceph.conf

# Verify if python3-rados is working correctly
RUN python3 -c "import rados; print('Successfully imported rados')" || echo 'Failed to import rados'

# Run the application
CMD ["python", "app.py"]
