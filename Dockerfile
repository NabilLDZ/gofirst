FROM golang:1.21

WORKDIR /app

COPY hello.go .

RUN go build -o myapp hello.go

EXPOSE 4000

CMD ["./myapp"]

#halo
#test