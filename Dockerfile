# Use an official Python runtime as a parent image
FROM python:3.11

# Set the working directory in the container
WORKDIR /app

# Install the necessary system dependencies, including python3-rados
RUN apt update && apt install -y python3-rados && rm -rf /var/lib/apt/lists/*

# Set the environment variable for the system Python packages to be included in PYTHONPATH
ENV PYTHONPATH=/usr/lib/python3/dist-packages:$PYTHONPATH

# Copy the requirements.txt first, so we can install dependencies
COPY requirements.txt /app/

# Create a virtual environment and install Python dependencies
RUN python3 -m venv /venv \
    && /venv/bin/pip install --no-cache-dir -r requirements.txt \
    && ln -sf /venv/bin/python /usr/local/bin/python \
    && ln -sf /venv/bin/pip /usr/local/bin/pip

# Now copy the rest of the current directory contents into the container
COPY . /app

# Set the environment variable for Ceph configuration file
ENV CEPH_CONF_PATH=/etc/ceph/ceph.conf

# Verify if python3-rados is working correctly
RUN /venv/bin/python3 -c "import rados; print('Successfully imported rados')" || echo 'Failed to import rados'

# Run the application
CMD ["/venv/bin/python", "app.py"]
