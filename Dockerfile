FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1
ENV POETRY_VIRTUALENVS_CREATE=false
ENV QT_DEBUG_PLUGINS=0

ENV DEBIAN_FRONTEND=noninteractive
# This fix: libGL error: No matching fbConfigs or visuals found
ENV LIBGL_ALWAYS_INDIRECT=1
ENV PATH="${PATH}:/root/.gem/ruby/3.1.0/bin:/root/.local/share/gem/ruby/3.1.0/bin"

# This is needed to install libsqlcipher-dev==4.6.1 on bookworm
RUN echo "deb http://deb.debian.org/debian bookworm-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://deb.debian.org/debian bookworm-backports main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y build-essential python3-pip python3-dev libxcb-cursor0 qt6-base-dev ruby libsqlcipher-dev=4.6.1-2~bpo12+1 && \
    gem install fpm --user-install && \
    pip install pip==25.1.1 poetry && \
    adduser --quiet --disabled-password qtuser && usermod -a -G audio qtuser

WORKDIR /app

COPY ./alinka ./pyproject.toml ./poetry.lock /app/

RUN poetry install --no-interaction --no-root --with dev
USER qtuser
