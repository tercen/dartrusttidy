
Utility docker container for R tidyverse, rust, and dart.

# version

- based on rocker/tidyverse:3.5.3 container
- rust 1.40.0
- dart 2.10.5-1

# build

```bash
IMAGE=tercen/dartrusttidy:1.0.9
docker build -t ${IMAGE} .
docker push ${IMAGE}
```

# usage
 
```bash
docker pull tercen/dartrusttidy:latest
docker pull tercen/dartrusttidy:1.0.9
```

 

