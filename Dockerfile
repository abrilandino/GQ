Hi, I'm trying to fix my Fly.io deployment. There's a build error on my Dockerfile.

Please fix my Dockerfile for me to the best of your ability. And give me the updated version so I can paste in Fly.io web deployment UI.

Error logs:

```
flyctl deploy --build-only --push -a gqbot --image-label deployment-3bd1a3fde8420c97aeea6f1f9f67222a --config fly.toml
==> Verifying app config
--> Verified app config
Validating fly.toml
[32m✓[0m Configuration is valid
==> Building image
Waiting for depot builder...

==> Building image with Depot
--> build:  (​)
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 1.56kB done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/python:3.11
#2 DONE 0.2s

#3 [internal] load .dockerignore
#3 transferring context: 789B done
#3 DONE 0.0s

#4 [build 1/7] FROM docker.io/library/python:3.11@sha256:33b4060c8f8268bb55f244a11adf6a1d75348f1a3a8335b858c65fe755559b29
#4 resolve docker.io/library/python:3.11@sha256:33b4060c8f8268bb55f244a11adf6a1d75348f1a3a8335b858c65fe755559b29 done
#4 DONE 0.0s

#5 [build 2/7] WORKDIR /usr/src/app
#5 CACHED

#6 [build 3/7] RUN apt-get update && apt-get install -y --no-install-recommends     build-essential     && rm -rf /var/lib/apt/lists/*
#6 CACHED

#7 [build 4/7] RUN python -m venv /opt/venv
#7 CACHED

#8 [internal] load build context
#8 transferring context: 1.45kB done
#8 DONE 0.0s

#9 [build 5/7] COPY requirements.txt ./requirements.txt
#9 ERROR: failed to calculate checksum of ref yvw9wb4i06msanaw1k2ako7gb::tzz172x1b7bs0dhwimq17m8tu: "/requirements.txt": not found
------
 > [build 5/7] COPY requirements.txt ./requirements.txt:
------
==> Building image
Waiting for depot builder...

==> Building image with Depot
--> build:  (​)
#1 [internal] load build definition from Dockerfile
#1 DONE 0.0s

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 1.56kB 0.0s done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/python:3.11
#2 DONE 0.2s

#3 [internal] load .dockerignore
#3 transferring context: 789B done
#3 DONE 0.0s

#4 [stage-1 1/5] FROM docker.io/library/python:3.11@sha256:33b4060c8f8268bb55f244a11adf6a1d75348f1a3a8335b858c65fe755559b29
#4 resolve docker.io/library/python:3.11@sha256:33b4060c8f8268bb55f244a11adf6a1d75348f1a3a8335b858c65fe755559b29 done
#4 DONE 0.0s

#5 [stage-1 2/5] WORKDIR /usr/src/app
#5 CACHED

#6 [build 3/7] RUN apt-get update && apt-get install -y --no-install-recommends     build-essential     && rm -rf /var/lib/apt/lists/*
#6 CACHED

#7 [build 4/7] RUN python -m venv /opt/venv
#7 CACHED

#8 [internal] load build context
#8 transferring context: 133B done
#8 DONE 0.0s

#9 [build 5/7] COPY requirements.txt ./requirements.txt
#9 ERROR: failed to calculate checksum of ref yvw9wb4i06msanaw1k2ako7gb::7tzj75hhavpe7eq0lpcr5z6fa: "/requirements.txt": not found
------
 > [build 5/7] COPY requirements.txt ./requirements.txt:
------
Error: failed to fetch an image or build from source: error building: failed to solve: failed to compute cache key: failed to calculate checksum of ref yvw9wb4i06msanaw1k2ako7gb::7tzj75hhavpe7eq0lpcr5z6fa: "/requirements.txt": not found
Dockerfile failed to build error
unsuccessful command 'flyctl deploy --build-only --push -a gqbot --image-label deployment-3bd1a3fde8420c97aeea6f1f9f67222a --config fly.toml'
```

Dockerfile


```
# Stage 1: Build the Application
# We use python:3.11 as the base for building and installing dependencies.
FROM python:3.11 AS build

# Set the working directory inside the container
WORKDIR /usr/src/app

# Install system dependencies if needed
RUN apt-get update && apt-get install -y --no-install-recommends     build-essential     && rm -rf /var/lib/apt/lists/*

# Create a virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements.txt if it exists (using wildcard to avoid build failure)
COPY requirements.txt ./requirements.txt

# Install Python dependencies only if requirements.txt exists
RUN pip install --upgrade pip &&     if [ -f requirements.txt ]; then         pip install -r requirements.txt;     fi

# Copy the rest of the application source code
COPY . .

# Stage 2: Create the Final Production Image
# We use python:3.11 as the runtime image with all the necessary tools.
FROM python:3.11

# Set the working directory
WORKDIR /usr/src/app

# Copy the virtual environment from the build stage
COPY --from=build /opt/venv /opt/venv

# Copy the application code
COPY --from=build /usr/src/app .

# Set the virtual environment as the active Python environment
ENV PATH="/opt/venv/bin:$PATH"

# Create a non-root user to run the application
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /usr/src/app
USER appuser

# Expose the port your app runs on
ENV PORT=8080
EXPOSE $PORT

# Define the command to start your application
CMD ["python", "bot.py"]
