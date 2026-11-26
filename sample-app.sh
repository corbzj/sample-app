#!/bin/bash

rm -rf tempdir
mkdir -p tempdir/templates
mkdir -p tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat << 'EOF' > tempdir/Dockerfile
FROM python:3.11-slim
RUN pip install --no-cache-dir --trusted-host pypi.org --trusted-host files.pythonhosted.org --progress-bar off flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD ["python", "/home/myapp/sample_app.py"]
EOF

cd tempdir
docker build -t sampleapp .
docker rm -f samplerunning 2>/dev/null || true
docker run --security-opt seccomp=unconfined -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a