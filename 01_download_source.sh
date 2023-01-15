#!/bin/bash

# create src dir
mkdir -p src

# download the source zip
curl -L -o src/personal_module.2022.11.30.zip https://data-society-alliance.org/wp-content/uploads/2022/11/%E3%83%91%E3%83%BC%E3%82%BD%E3%83%8A%E3%83%AB%E3%83%87%E3%83%BC%E3%82%BF%E9%80%A3%E6%90%BA%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB_%E3%82%BD%E3%83%BC%E3%82%B9%E3%82%B3%E3%83%BC%E3%83%89.zip

# extract zip
docker run --rm -v $(pwd)/src:/opt/src -v $(pwd)/utils/cp932_zip_extractor/:/opt/app python:3.10-slim python /opt/app/cp932_zip_extractor.py /opt/src/personal_module.2022.11.30.zip /opt/src

