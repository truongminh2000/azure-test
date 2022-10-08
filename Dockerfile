# FROM node:16.15.1 as build
# WORKDIR /app
# COPY . /app
# RUN npm install && npm run build

# FROM nginx:latest
# COPY --from=build /app/dist/angular14 /usr/share/nginx/html
FROM node:16.15.1 AS build
# Create a Virtual directory inside the docker image
WORKDIR /dist/src/app
# Copy files to virtual directory
# COPY package.json package-lock.json ./
# Run command in Virtual directory
RUN npm cache clean --force
# Copy files from local machine to virtual directory in docker image
COPY . .
RUN npm install
RUN npm run build


### STAGE 2:RUN ###
# Defining nginx image to be used
FROM nginx:latest AS ngi
# Copying compiled code and nginx config to different folder
# NOTE: This path may change according to your project's output folder
COPY --from=build /dist/src/app/dist/angular14 /usr/share/nginx/html
COPY /nginx.conf  /etc/nginx/conf.d/default.conf
# Exposing a port, here it means that inside the container
# the app will be using Port 80 while running
EXPOSE 80

# docker build -t truongminh2000/angular-app:v1.0.0 -f ./Dockerfile .
