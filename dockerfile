FROM python:3.9.1-alpine3.13
LABEL maintainer="cmedina.developer@gmail.com"

# Disable buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Configure environment
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Set DEV environment variable
ARG DEV=false

# Install dependencies using a virtual environment
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; \
       then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Set environment variables
ENV PATH="/py/bin:$PATH"

USER django-user