FROM alpine:latest
RUN apk add --no-cache postgresql-client
COPY backup.sh ./backup.sh
RUN chmod +x /backup.sh
EXPOSE 8081

CMD ["sh", "/backup.sh"]