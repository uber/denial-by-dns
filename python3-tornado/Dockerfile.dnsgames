# Python 3.6.3 with Tornado 6.0.2
FROM python:3.7.3

RUN pip install tornado==6.0.2

ADD .gen/httpserver scripts/dnsgames_init /
ADD python3-tornado/main.py /

ENTRYPOINT ["/dnsgames_init"]
CMD ["/main.py"]
