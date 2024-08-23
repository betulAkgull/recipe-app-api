FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PATH="/py/bin:$PATH"

# Create a directory for the app
WORKDIR /app

# Copy the requirements.txt file into the container
COPY ./requirements.txt /tmp/requirements.txt

COPY ./requirements.dev.txt /tmp/requirements.dev.txt

EXPOSE 8000

ARG DEV=false


# Step 1: Create a virtual environment
RUN python -m venv /py

# Step 2: Upgrade pip in the virtual environment
RUN /py/bin/pip install --upgrade pip

# Step 3: Install the requirements
RUN /py/bin/pip install -r /tmp/requirements.txt

RUN if [ "$DEV" = "true" ]; then \
    /py/bin/pip install -r /tmp/requirements.dev.txt; \
fi 

# Step 4: Clean up temporary files
RUN rm -rf /tmp

# Step 5: Add a user to run the application
RUN adduser --disabled-password --no-create-home django-user

# Copy the rest of the application code
COPY . /app

# Switch to the non-root user
USER django-user
