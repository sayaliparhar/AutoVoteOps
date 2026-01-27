FROM node:18-alpine

WORKDIR /Backend

COPY package.json /Backend

RUN npm install

COPY ..

EXPOSE 3000

CMD ["node" , "server.js"]