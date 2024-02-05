EM ?= emacs
EE ?= $(EM) -Q --batch --eval "(progn (require 'ob-tangle) (setq org-confirm-babel-evaluate nil))"
# EL ?= $(EM) -Q --batch -l "init.el" --eval "(setq load-prefer-newer t load-suffixes '(\".el\") nasy--require t)" --eval "(progn (run-hooks 'after-init-hook 'emacs-startup-hook 'nasy-first-key-hook 'pre-command-hook 'prog-mode-hook 'org-mode-hook 'nasy-org-first-key-hook))"

EL ?= $(EM) -Q


early-init.el: early-init.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'

init.el: init.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'

init-ui.el: elisp/init-ui.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'

init-base.el: elisp/init-base.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'

generate: early-init.el init.el init-ui.el init-base.el

clean:
	rm -f init.el early-init.el init-ui.el init-base.el elisp/*.el
