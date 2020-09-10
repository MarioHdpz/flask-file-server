FROM python:3.8

# build deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev

RUN mkdir /var/log/uwsgi

# Web app source code
COPY . /app
WORKDIR /app

ENV POETRY_HOME="/opt/poetry"
ENV PATH="$POETRY_HOME/bin:$PATH"
RUN wget -O - https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python \
    && poetry --version \
    && poetry config virtualenvs.create false

RUN poetry install --no-dev --no-interaction --no-ansi -vvv

ENTRYPOINT [ "uwsgi", "-s", "/tmp/fileserver.sock", \
               "--chmod-socket=777", \
               "--manage-script-name", \
               "--mount", "/=file_server:app" ]
