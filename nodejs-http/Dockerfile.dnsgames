# Node 10.15.3 with 'http' from stdlib
FROM node:10.15.3

ADD .gen/httpserver scripts/dnsgames_init /
ADD nodejs-http/index.js /

ENTRYPOINT ["/dnsgames_init"]
CMD ["node", "/index.js"]
