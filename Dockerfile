# ---- Build Stage ----
FROM golang:1.18 AS builder
WORKDIR /app
COPY . .
RUN go mod tidy
RUN go build -o app

# ---- Run Stage ----
FROM debian:bookworm-slim
WORKDIR /root/
COPY --from=builder /app/app .
EXPOSE 8080
CMD ["./app"]
