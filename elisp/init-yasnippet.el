;;; init-yasnippet.el --- Initialize yasnippet configurations. -*- lexcial-bindint: t -*-
;;; Commentary:

;;; Code:

;; Yet another snippet extension
(use-package yasnippet
  :diminish yasnippet
  :hook (after-init . yas-global-mode))

;; Collection of yasnippet snippets
(use-package yasnippet-snippets)

(provide 'init-yasnippet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-yasnippet.el ends here
