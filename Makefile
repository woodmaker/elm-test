.PHONY: clean install-elm install-deps deploy default help format



# basic targets


help:
	@echo 'basic targets:'
	@echo ' - help         - this help'
	@echo ' - build        - deployable build of this app'
	@echo ' - clean        - remove build artifacts'
	@echo ' - purge        - more clean'
	@echo 'misc. targets:'
	@echo ' - install-elm  - *install elm into your system'
	@echo ' - install-deps - *install apache2 and configure it to be able to host this app'
	@echo '                  * - requires root access and could ruin your life. Be careful.'
	@echo ' - deploy       - provide (cp) build of this app to apache'
	@echo '                - requires install-deps'


build: main.js index.html articles.md
	mkdir -p build
	touch build
	cp index.html build/
	cp articles.md build/
	cp main.js build/


clean:
	rm -Rf build
	rm -f main.js


purge: clean
	rm -f elm
	rm -Rf elm-stuff
	rm -Rf node_modules
	rm -f package-lock.json



# misc. targets


deploy: build
	cp build/* /var/www/html/


/usr/local/bin/elm: elm
	cp elm /usr/local/bin


install-elm: /usr/local/bin/elm


install-deps:
	@echo install and configure apache2 to be able to provide build of this app
	@echo this target could break your computer configuration.
	@echo Please review this target in Makefile.
	apt-get update
	apt-get install apache2
	cp etc/apache2.conf /etc/apache2/apache2.conf
	chmod -R 777 /var/www/html 
	/etc/init.d/apache2 restart



# internal targets


main.js: elm src/*
	#make format
	./elm make --output main.js src/Main.elm


elm:
	wget -O elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
	gunzip elm.gz
	chmod +x elm


elm-format:
	wget -O elm-format.tgz https://github.com/avh4/elm-format/releases/download/0.8.4/elm-format-0.8.4-linux-x64.tgz
	tar xf elm-format.tgz


format: elm-format
	./elm-format --yes src/
