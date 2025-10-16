# --- Build stage ---
FROM golang:1.21 AS build
WORKDIR /app
COPY . .
RUN go mod tidy
RUN go build -o main .

# --- Run stage ---
FROM alpine:latest
WORKDIR /root/
COPY --from=build /app/main .
CMD ["./main"]
