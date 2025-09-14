# Base image
FROM python:3.9-alpine3.13
LABEL maintainer="mohammadjafari"

# Ensure Python output is unbuffered
ENV PYTHONUNBUFFERED=1
ENV PATH="/py/bin:$PATH"

# Fix DNS in case of network issues
# RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Copy requirements and app code
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

# Argument to control dev dependencies installation
ARG DEV=false

# Install Python venv, dependencies, and system packages
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    # Install runtime dependencies
    apk add --update --no-cache bash curl postgresql-client && \
    # Install build dependencies temporarily
    apk add --update --no-cache --virtual .build-deps build-base postgresql-dev musl-dev && \
    # Install Python packages
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    # Clean up temporary files and build deps
    rm -rf /tmp && \
    apk del .build-deps && \
    # Add non-root user
    adduser --disabled-password --no-create-home django-user

# Switch to non-root user
USER django-user
