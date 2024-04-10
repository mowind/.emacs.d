;;; init-rust.el Rust configurations. -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

;; Rust
(use-package rustic
  :custom (rustic-lsp-client centaur-lsp))

(use-package ron-mode
  :mode ("\\.ron" . ron-mode))

(provide 'init-rust)
