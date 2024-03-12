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
