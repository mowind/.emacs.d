;;; init-rust.el Rust configurations. -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

;; Rust
(use-package rustic
  :custom (rustic-lsp-client nil))

(use-package ron-mode
  :mode ("\\.ron" . ron-mode))

(provide 'init-rust)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-rust.el ends here
