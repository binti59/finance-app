FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE ${BACKEND_PORT}

CMD ["npm", "start"]
