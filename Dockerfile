FROM node:20-alpine AS frontend-builder
WORKDIR /app
COPY package.json ./
RUN npm install --frozen-lockfile || npm install
COPY client ./client
COPY shared ./shared
COPY vite.config.ts ./
COPY tsconfig.json ./
COPY tailwind.config.ts ./
COPY postcss.config.js ./
COPY components.json ./
RUN npx vite build

FROM golang:1.25-alpine AS go-builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
COPY --from=frontend-builder /app/dist ./dist
RUN CGO_ENABLED=0 GOOS=linux go build -o hr-plussystem .

FROM alpine:3.19
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app
COPY --from=go-builder /app/hr-plussystem .
COPY --from=go-builder /app/dist ./dist
ENV TZ=Asia/Tashkent
EXPOSE 5000
CMD ["./hr-plussystem"]
