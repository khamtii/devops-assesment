#set baseImage
FROM node:20-alpine 

 #Set working directory
WORKDIR /app 

COPY index.js .

#expose the neccesary port for application to run on
EXPOSE 3000

CMD ["node", "index.js"]
