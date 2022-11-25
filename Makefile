.PHONY: compile
compile:
	eldev clean elc
	eldev -C --unstable -a -dtT compile

.PHONY: clean
clean:
	eldev clean

.PHONY: fullclean
fullclean:
	eldev clean all

.PHONY: lint
lint:
	eldev -C --unstable -a -dtT lint

.PHONY: test
test:
	eldev exec t
	eldev -C --unstable -a -dtT test

startup: init.el
	bash test-startup.sh

mobile:
	emacs --batch -l init.el -f org-mobile-push
