# Stage 1: Build the Application
FROM python:3.11 AS build

# Set working directory
WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements if exists
COPY requirements.txt ./requirements.txt

# Install Python dependencies
RUN pip install --upgrade pip && \
    if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

# Copy the application source code
COPY . .

# Stage 2: Final production image
FROM python:3.11

WORKDIR /usr/src/app

# Copy virtual environment
COPY --from=build /opt/venv /opt/venv

# Copy app code
COPY --from=build /usr/src/app . 

# Set virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Create non-root user
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /usr/src/app
USER appuser

# Expose port
ENV PORT=8080
EXPOSE $PORT

# Run bot.py
CMD ["python", "bot.py"]
