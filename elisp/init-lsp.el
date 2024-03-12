;;; init-lsp.el Lsp bridge configurations. -*- lexcial-binding: t -*-
;;; Commentary:

;;; Code:

;; Lsp bridge
(add-to-list 'load-path (expand-file-name "site-lisp/lsp-bridge" user-emacs-directory) t)
(require 'lsp-bridge)
(setq lsp-bridge-signature-show-function 'eldoc-message)
(setq lsp-bridge-enable-org-babel t)
(setq lsp-bridge-enable-hover-diagnostic t)
(setq acm-enable-quick-access t)
(setq acm-backend-yas-match-by-trigger-keyword t)
(setq lsp-bridge-disable-electric-indent t)

(global-lsp-bridge-mode)

(add-hook 'go-ts-mode-hook
          (lambda ()
            (setq go-ts-mode-indent-offset 4)))

(provide 'init-lsp)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-lsp.el ends here
