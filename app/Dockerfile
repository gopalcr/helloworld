# Pull the official Python base image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Set environment variables for Python
# Ensures Python output is sent directly to the terminal/log (unbuffered)
ENV PYTHONUNBUFFERED 1

# Copy the requirements file and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY app.py .
COPY requirements.txt .

RUN apt update && apt install curl wget -y

# Expose the port Gunicorn will run on
EXPOSE 8000

# Command to run the application using Gunicorn
# "app:app" refers to the module "app.py" and the Flask instance/callable named "app" within it
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--worker-class", "uvicorn.workers.UvicornWorker","app:app"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
