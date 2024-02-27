# syntax=docker/dockerfile:1

# Build stage
FROM crystallang/crystal:1.11.2-alpine as build

RUN apk update && apk add --no-cache git

RUN mkdir /project
WORKDIR /project
ADD . /project

RUN crystal build --release --no-debug --static -o password src/main.cr && \
    strip password

RUN addgroup -S appgroup && adduser -S password -G appgroup

# copy artifacts to a scratch image
#FROM scratch
FROM alpine:3.19.1
COPY --from=build /etc/passwd /etc/passwd
USER password
COPY --from=build /project/password /password
#COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "/password" ]
CMD ["--help"]
