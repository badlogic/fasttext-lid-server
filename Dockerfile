FROM debian:bullseye-slim AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN mkdir build-docker \
    && cd build-docker \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make -j$(nproc)

FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/build-docker/fasttext_lid_server .
COPY lid.176.ftz .

CMD ["sh", "-c", "./fasttext_lid_server ${MODEL_FILE:-lid.176.ftz} ${PORT:-8080}"]