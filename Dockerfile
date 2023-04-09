# Use an official Python runtime as a parent image
FROM python:3.9-slim-buster

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY ./polls /app
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
RUN $HOME/.local/bin/poetry install --only main
RUN $HOME/.local/bin/poetry self add 'poethepoet[poetry_plugin]'
RUN $HOME/.local/bin/poetry run python manage.py collectstatic --noinput
# Expose port 8000 for the Django development server
EXPOSE 8000
# See https://github.com/awslabs/aws-lambda-web-adapter#usage
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.6.4 /lambda-adapter /opt/extensions/lambda-adapter
# Start the Django production server
CMD ["/root/.local/bin/poetry", "poe", "run-production"]
