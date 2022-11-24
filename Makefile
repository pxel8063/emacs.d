test: init.el
	bash test-startup.sh

mobile:
	emacs --batch -l init.el -f org-mobile-push
