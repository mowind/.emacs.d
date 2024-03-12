;;; init-lsp.el Lsp bridge configurations. -*- lexcial-binding: t -*-
;;; Commentary:

;;; Code:

;; Lsp bridge
;;(add-to-list 'load-path (expand-file-name "site-lisp/lsp-bridge" user-emacs-directory) t)
;;(require 'lsp-bridge)
;;(setq lsp-bridge-signature-show-function 'eldoc-message)
;;(setq lsp-bridge-enable-org-babel t)
;;(setq lsp-bridge-enable-hover-diagnostic t)
;;(setq acm-enable-quick-access t)
;;(setq acm-backend-yas-match-by-trigger-keyword t)
;;(setq lsp-bridge-disable-electric-indent t)
;;
;;(global-lsp-bridge-mode)

(use-package lsp-bridge
  :straight '(lsp-bridge
              :type git
              :host github
              :repos "mowind/lsp-bridge"
              :files ("*" (:exclude ".git"))
              :build (:not compile))
  :hook (after-init . global-lsp-bridge-mode)
  :custom
  (lsp-bridge-signature-show-function 'eldoc-message)
  (lsp-bridge-enable-org-babel t)
  (lsp-bridge-enable-hover-diagnostic t)
  (acm-markdown-render-font-height 80)
  (acm-backend-lsp-match-mode "fuzzy")
  :bind
  (:map lsp-bridge-mode-map
        ([remap xref-find-definitions] . lsp-bridge-find-def)
        ([remap xref-go-back] . lsp-bridge-find-def-return)
        ([remap xref-find-references] . lsp-bridge-find-references)
        ([remap view-hello-file] . lsp-bridge-popup-documentation))
  :init
  (pretty-hydra-define lsp-bridge-hydra (:title (pretty-hydra-title "LSP Bridge" 'faicon "nf-fa-rocket" :face 'nerd-icons-green)
                                                :color amaranth :quit-key ("q" "C-g"))
    ("Action"
     (("f" lsp-bridge-code-format "Format")
      ("r" lsp-bridge-rename "Rename")
      ("x" lsp-bridge-code-action "Code Action"))
     "Code"
     (("i" lsp-bridge-find-impl "Implementation")
      ("D" lsp-bridge-find-def "Definition")
      ("R" lsp-bridge-find-references "Refrences"))
     "Debug"
     (("o" lsp-bridge-popup-documentation "Documentation")
      ("d" lsp-bridge-diagnostic-list "Diagnostic")
      ("M-r" lsp-bridge-restart-process "Restart")))))

(add-hook 'go-ts-mode-hook
          (lambda ()
            (setq go-ts-mode-indent-offset 4)))

(provide 'init-lsp)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-lsp.el ends here
