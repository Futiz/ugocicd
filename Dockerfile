FROM debian:12-slim AS build 

RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes python3-venv gcc libpython3-dev curl && \
    python3 -m venv /venv && \
    curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    /venv/bin/python get-pip.py && \
    rm get-pip.py && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

FROM build AS build-venv

COPY requirements.txt /requirements.txt

# DEBUG: afficher requirements
RUN cat /requirements.txt

# DEBUG: version de pip
RUN /venv/bin/pip --version

# Installation des deps
RUN /venv/bin/pip install --no-cache-dir --disable-pip-version-check -r /requirements.txt

FROM gcr.io/distroless/python3-debian12:latest-amd64
COPY --from=build-venv /venv /venv

WORKDIR /app
COPY . .

EXPOSE 8080

CMD ["python", "manage.py", "runserver", "0.0.0.0:8080"]
