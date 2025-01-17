;;; init-haskell.el --- Initialize Haskell configurations -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Haskell configurations.
;;

;;; Code:

(eval-when-compile
  (require 'init-const)
  (require 'init-custom))

;; Haskell
(use-package haskell-mode
  :mode "\\.hs\\'"
  :hook
  (haskell-mode . interactive-haskell-mode)
  ;;(haskell-mode . haskell-indentation-mode)
  ;;(haskell-mode . haskell-auto-insert-module-template)
  :bind (("C-x a a" . align)
         :map haskell-mode-map
         ("C-c h" . hoogle)
         ("C-o"   . open-line)
         ("C-c C-l" . haskell-process-load-or-reload)
         ("C-`" . haskell-interactive-bring)
         ("C-c C-k" . haskell-interactive-mode-clear))
  :init
  (setq haskell-mode-stylish-haskell-path            "stylish-haskell"
        haskell-process-suggest-haskell-docs-imports t
        haskell-process-suggest-remove-import-lines  t
        haskell-process-auto-import-loaded-modules   t
        haskell-process-log                          nil
        haskell-process-suggest-hoogle-imports       t
        haskell-process-type 'ghci)

  (unless (fboundp 'align-rules-list)
    (defvar align-rules-list nil))

  (add-to-list 'align-rules-list
               '(haskell-types
                 (regexp . "\\(\\s-+\\)\\(::\\|::\\)\\s-+")
                 (modes quote (haskell-mode literate-haskell-mode))))
  (add-to-list 'align-rules-list
               '(haskell-assignment
                 (regexp . "\\(\\s-+\\)=\\s-+")
                 (modes quote (haskell-mode literate-haskell-mode))))
  (add-to-list 'align-rules-list
               '(haskell-arrows
                 (regexp . "\\(\\s-+\\)\\(->\\|::\\)\\s-+")
                 (modes quote (haskell-mode literate-haskell-mode))))
  (add-to-list 'align-rules-list
               '(haskell-left-arrows
                 (regexp . "\\(\\s-+\\)\\(<-\\|::\\)\\s-+")
                 (modes quote (haskell-mode literate-haskell-mode)))))

(use-package haskell-snippets)

(when (eq centaur-lsp 'lsp-mode)
  (use-package lsp-haskell))

(provide 'init-haskell)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-haskell.el ends here
