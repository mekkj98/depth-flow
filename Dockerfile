FROM broken-base:latest

RUN pip install runpod

COPY depthflow.py /depthflow.py

CMD ["python3", "/depthflow.py"]
