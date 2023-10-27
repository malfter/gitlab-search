FROM node:21-slim

ENV NODE_ENV=production

COPY . /app

WORKDIR /app

RUN npm install -g gitlab-search 

ENTRYPOINT ["gitlab-search"]

CMD ["--help"]
