# FastText Language ID Server

HTTP server that provides language identification using FastText models.

## Quick Start

```bash
# Pull and run
docker run -p 8080:8080 mariozechner/fasttext-lid-server

# Test
curl "http://localhost:8080/detect?text=Hello%20world"
```

## API

### GET /detect
- **Parameter**: `text` (required)
- **Response**: JSON with language code and probability
```json
{
    "language": "en",
    "probability": 0.987
}
```
- **Errors**:
  - 400: Missing text parameter
  - 500: Prediction failed

## Docker

### Using docker run
```bash
# Default settings
docker run -p 8080:8080 mariozechner/fasttext-lid-server

# Custom settings
docker run -p 9000:9000 \
  -e PORT=9000 \
  -e MODEL_FILE=/models/custom.ftz \
  -v $(pwd)/models:/models \
  mariozechner/fasttext-lid-server
```

### Using docker compose
```yaml
version: '3.8'

services:
  lid-server:
    image: mariozechner/fasttext-lid-server
    ports:
        - "${PORT:-8080}:${PORT:-8080}"
    environment:
        - MODEL_FILE=${MODEL_FILE:-lid.176.ftz}
        - PORT=${PORT:-8080}
    volumes:
        - ./models:/models
    healthcheck:
        test: ["CMD", "curl", "-f", "http://localhost:${PORT:-8080}/detect?text=Hello%20world"]
        interval: 5s
        timeout: 5s
        retries: 3
```

Run with:
```bash
# Default settings
docker compose up

# Custom port
PORT=9000 docker compose up

# Custom model
MODEL_FILE=/models/custom.ftz docker compose up
```

## Building from Source

Prerequisites: CMake 3.14+, C++17 compiler

```bash
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
```

Run:
```bash
./fasttext_lid_server [model_path] [port]
```