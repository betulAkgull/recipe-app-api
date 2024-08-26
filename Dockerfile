FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PATH="/py/bin:$PATH"

# Create a directory for the app
WORKDIR /app

# Copy the requirements.txt files into the container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Install PostgreSQL client and build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Step 1: Create a virtual environment and install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp

# Step 2: Add a user to run the application
RUN adduser --disabled-password --no-create-home django-user

# Copy the rest of the application code
COPY . /app

# Switch to the non-root user
USER django-user

# Expose the application port
EXPOSE 8000

# Default command
CMD ["sh", "-c", "python manage.py runserver 0.0.0.0:8000"]
