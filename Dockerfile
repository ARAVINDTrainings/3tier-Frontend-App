FROM node:20-alpine as builder

WORKDIR /app
COPY ./code/package*.json ./
RUN npm install
COPY ./code .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
