.PHONY: default all
default: build

# PHONY targets

all: publish

build: build-alpine build-ubuntu

publish: publish-alpine publish-ubuntu

clean: clean-alpine clean-ubuntu

build-alpine:
	./build/alpine/build_all.sh > ./build/alpine/versions.txt

publish-alpine: ./build/alpine/versions.txt
	cat ./build/alpine/versions.txt | xargs -n 1 -I '{}' bash -c "echo 'Publishing image {} to Docker Hub...'; docker push {}; echo ''"

clean-alpine:
	cat ./build/alpine/versions.txt | xargs -n 1 -I '{}' docker image rm {}
	rm build/alpine/versions.txt

build-ubuntu:
	./build/ubuntu/build_all.sh > ./build/ubuntu/versions.txt

publish-ubuntu: ./build/ubuntu/versions.txt
	cat ./build/ubuntu/versions.txt | xargs -n 1 -I '{}' bash -c "echo 'Publishing image {} to Docker Hub...'; docker push {}; echo ''"

clean-ubuntu:
	cat ./build/ubuntu/versions.txt | xargs -n 1 -I '{}' docker image rm {}
	rm build/ubuntu/versions.txt

# File targets

./build/alpine/versions.txt: build-alpine
./build/ubuntu/versions.txt: build-ubuntu