# Use an appropriate base image
FROM python:3.8

# Set the working directory in the container
WORKDIR /app

# Copy the contents of your project folder into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8000 for FastAPI application
EXPOSE 8000

# Define the command to run the FastAPI application using Uvicorn server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
