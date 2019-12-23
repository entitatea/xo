# xo

docker build -t xo .

docker run -v /path/to/redis:/var/lib/redis -p 8000:8000 -d xo
