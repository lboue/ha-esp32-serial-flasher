FROM ghcr.io/home-assistant/base:3.24

RUN apk add --no-cache ser2net

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
