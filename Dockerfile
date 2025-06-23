# Use Python 3.10 Slim as the base image

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory

# Create the directory for static files
RUN mkdir -p /opt/app/cloudtalents/static

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    postgresql-client \
    libpq-dev \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies

# Copy relevant project files to the container

# Run entrypoint script
