default: build

# Phony targets
.PHONY: all
all: publish

.PHONY: build
build:
	bash ./build/build_all.sh > ./build/versions.txt

.PHONY: publish
publish: ./build/versions.txt
	cat ./build/versions.txt | xargs -n 1 -I '{}' bash -c "echo 'Publishing image {} to Docker Hub...'; docker push {}; echo ''"

.PHONY: clean
clean:
	cat ./build/versions.txt | xargs -n 1 -I '{}' docker image rm {}
	rm build/versions.txt

# File targets
./build/versions.txt: build