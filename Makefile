.PHONY: clean install-elm

main.js: elm src/Main.elm
	./elm make --output main.js src/Main.elm

elm:
	curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
	gunzip elm.gz
	chmod +x elm

/usr/local/bin/elm: elm
	cp elm /usr/local/bin

install-elm: /usr/local/bin/elm

build: main.js index.html
	mkdir build
	cp index.html build/
	cp main.js build/

clean:
	rm -Rf elm
	rm -Rf build
	rm -f main.js
	rm -Rf node_modules
	rm -f package-lock.json


