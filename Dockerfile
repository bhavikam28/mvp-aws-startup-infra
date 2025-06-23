# Use Python 3.10 Slim as the base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV ENVIRONMENT="local"

# Set work directory
WORKDIR /opt/app

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
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy relevant project files to the container
COPY . .

# Run entrypoint script
RUN python manage.py collectstatic --noinput