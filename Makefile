default: build

.PHONY: build
build:
	@./build/build_all.sh > ./build/versions.txt

.PHONY: publish
publish: build
	@bash -exc '<./build/versions.txt xargs docker push'