FROM python:3.9-slim as builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt

COPY . .

FROM gcr.io/distroless/python3

COPY --from=builder /install /usr/local
COPY --from=builder /app /app

WORKDIR /app
EXPOSE 8000

CMD ["manage.py", "runserver", "0.0.0.0:8000"]
