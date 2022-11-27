.PHONY: compile
compile:
	eldev clean elc
	eldev -C --unstable -a -dtT compile
	eldev -dtT -C compile --set all

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
	eldev -C --unstable -a -dtT test
	eldev -p -dtT -C test
	eldev exec t

startup: init.el
	bash test-startup.sh

mobile:
	emacs --batch -l init.el -f org-mobile-push
