FROM python:3.10-slim

WORKDIR /app
COPY . /app

RUN pip install --upgrade pip && pip install -r requirements.txt

CMD ["gunicorn", "app:server", "--bind", "0.0.0.0:8050"]