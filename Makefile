default: build

build:
	@./build/build-all.sh > ./build/versions.txt

publish: build
	@bash -exc '<./build/versions.txt xargs docker push'