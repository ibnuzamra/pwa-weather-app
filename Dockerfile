FROM node:16-alpine AS build

WORKDIR /

COPY package.json package-lock.json ./

RUN npm ci

COPY ./src ./src
COPY ./public ./public

RUN npm run build --prod

FROM nginx:1.21.6

COPY --from=build /build /var/www/
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
