# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster AS builder

# Set the working directory to /app
WORKDIR /app

COPY ./pyproject.toml /app
COPY ./poetry.lock /app
# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Use Poetry to install the project dependencies
RUN $HOME/.local/bin/poetry export -f requirements.txt --output requirements.txt

FROM python:3.9-slim-buster

WORKDIR /var/task
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.6.4 /lambda-adapter /opt/extensions/lambda-adapter
# COPY extension.zip extension.zip
# RUN apt-get update && apt-get install -y unzip \
#   && unzip extension.zip -d /opt \
#   && rm -f extension.zip
COPY --from=builder /app/requirements.txt ./
RUN python -m pip install -r requirements.txt
COPY ./polls/ ./
RUN python manage.py collectstatic --noinput

EXPOSE 8000
# See https://github.com/awslabs/aws-lambda-web-adapter#usage
# Start the Django production server
CMD ["gunicorn", "polls.wsgi:application", "-w=1", "-b=0.0.0.0:8000"]
