;;; init.el --- The main init entry for Emacs -*- lexical-binding: t -*-
  ;;; Commentary:

  ;;; Code:

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t
      use-package-always-defer t
      use-package-expand-minimally t
      use-package-enable-imenu-support t)

;; bootstrap `straight'
(setq straight-repository-branch "develop")
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)

(use-package use-package-ensure-system-package :ensure t)
(use-package diminish :ensure t)
(use-package bind-key :ensure t)

(use-package gnu-elpa-keyring-update)

;; Update packages
(unless (fboundp 'package-upgrade-all)
  (use-package auto-package-update
    :init
    (setq auto-package-update-delete-old-versions t
          auto-package-update-hide-results t)
    (defalias 'package-upgrade-all #'auto-package-update-now)))

(let ((dir (locate-user-emacs-file "elisp")))
  (add-to-list 'load-path (file-name-as-directory dir)))

(require 'init-base)
(require 'init-hydra)
(require 'init-ui)
(require 'init-completion)
(require 'init-edit)
(require 'init-yasnippet)

(require 'init-highlight)

(require 'init-markdown)
(require 'init-org)

(require 'init-vcs)
(require 'init-lsp)

(require 'init-prog)
(require 'init-go)
(require 'init-solidity)

(provide 'init)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d05d7ef5ef2c6d63f382e5e2fcdf2f4c7a9f6f6aad9433f04dbddecf71d46f1c"
     "84b04a13facae7bf10f6f1e7b8526a83ca7ada36913d1a2d14902e35de4d146f"
     "4ade6b630ba8cbab10703b27fd05bb43aaf8a3e5ba8c2dc1ea4a2de5f8d45882"
     "6f780ba22a933a57ee1b3aea989dc527c068a31d31513d2f1956955f2a697e6e"
     "a242356ae1aebe9f633974c0c29b10f3e00ec2bc96a61ff2cdad5ffa4264996d"
     "65809263a533c5151d522570b419f1a653bfd8fb97e85166cf4278e38c39e00e" default))
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
