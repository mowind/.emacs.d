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
  (with-eval-after-load 'transient
    (transient-define-prefix lsp-transient ()
      "LSP Transient"

      [["Action"
        ("f" "Format" lsp-bridge-code-format)
        ("r" "Rename" lsp-bridge-rename)
        ("x" "Action" lsp-bridge-code-action)]
       ["Code"
        ("i" "Implementation" lsp-bridge-find-impl)
        ("D" "Definition" lsp-bridge-find-def)
        ("R" "Refrences" lsp-bridge-find-references)]
       ["Debug"
        ("o" "Documentation" lsp-bridge-popup-documentation)
        ("d" "Diagnostic" lsp-bridge-diagnostic-list)
        ("M-r" "Restart" lsp-bridge-restart-process)]])))


(add-hook 'go-ts-mode-hook
          (lambda ()
            (setq go-ts-mode-indent-offset 4)))

(provide 'init-lsp)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-lsp.el ends here
