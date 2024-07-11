FROM alpine AS base
RUN apk add --update cargo go
RUN cargo install lcat
RUN go install github.com/charmbracelet/gum@latest

FROM alpine AS runbase

RUN apk add --update gcc

FROM runbase AS run
WORKDIR /app
RUN export PATH="/root/go/bin:/root/.cargo/bin:$PATH"
COPY --from=base /root/.cargo/bin/lcat /usr/local/bin/lcat
COPY --from=base /root/go/bin/gum /usr/local/bin/gum


#ENTRYPOINT [ "/bin/bash", "-c" ]