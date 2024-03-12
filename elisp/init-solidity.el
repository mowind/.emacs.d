;; init-solidity.el --- Initialize solidity configurations. -*- lexical-binding: t -*-
;;
;;; Commentary:

;;; Code:

(use-package solidity-mode
  :hook (solidity-mode . (lambda ()
                           (c-set-offset 'defun-block-intro 4)
                           (c-set-offset 'statement-block-intro 4)))
  :config
  (setq solidity-comment-style 'slash))

(provide 'init-solidity)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-solidity.el ends here
