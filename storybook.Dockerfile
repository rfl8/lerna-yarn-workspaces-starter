FROM node:12-alpine as build

WORKDIR /usr/src/app

COPY package.json .
COPY yarn.lock .
COPY packages/shared ./packages/shared
COPY packages/api ./packages/api

RUN yarn install --pure-lockfile --non-interactive

WORKDIR /usr/src/app/packages/shared
RUN yarn build

WORKDIR /usr/src/app/packages/api
RUN yarn build

FROM node:10-alpine

WORKDIR /usr/src/app

COPY package.json .
COPY yarn.lock .

COPY --from=build /usr/src/app/packages/shared/package.json /usr/src/app/packages/shared/package.json
COPY --from=build /usr/src/app/packages/shared/dist /usr/src/app/packages/shared/dist

COPY --from=build /usr/src/app/packages/api/package.json /usr/src/app/packages/api/package.json
COPY --from=build /usr/src/app/packages/api/build /usr/src/app/packages/api/build

ENV NODE_ENV production

RUN yarn install --pure-lockfile --non-interactive --production

WORKDIR /usr/src/app/packages/api

CMD ["npm", "start"]