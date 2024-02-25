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
	rm -f init-ui.el

init-base.el: elisp/init-base.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-base.el

init-completion.el:elisp/init-completion.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-completion.el

init-edit.el: elisp/init-edit.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-edit.el

init-yasnippet.el: elisp/init-yasnippet.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-yasnippet.el

init-highlight.el: elisp/init-highlight.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-highlight.el

init-markdown.el: elisp/init-markdown.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-markdown.el

init-lsp.el: elisp/init-lsp.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-lsp.el

init-go.el: elisp/init-go.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-go.el

init-vcs.el: elisp/init-vcs.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-vcs.el

init-hydra.el: elisp/init-hydra.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-hydra.el

init-prog.el: elisp/init-prog.org
	$(EE) --eval '(org-babel-tangle-publish t "$<" "$(@D)/")'
	rm -f init-prog.el

generate: early-init.el init.el init-ui.el init-base.el init-completion.el init-edit.el init-yasnippet.el init-markdown.el init-lsp.el init-go.el init-vcs.el init-hydra.el init-highlight.el init-prog.el

clean:
	rm -f *.el elisp/*.el
