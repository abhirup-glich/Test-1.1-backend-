FROM python:3.10-slim
WORKDIR /usr/src/app
ENV PYTHONUNBUFFERED 1

# Install system dependencies needed for dlib/psycopg2 compilation
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cmake build-essential libboost-all-dev libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
# Install Python dependencies, forcing the CPU wheel index for PyTorch if needed
RUN pip install --upgrade pip && \
    pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cpu

COPY . .

# Use Gunicorn to start the Flask application on the port provided by Cloud Run
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "server:app"]