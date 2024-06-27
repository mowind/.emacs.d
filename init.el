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

(setq native-comp-deferred-compilation t)
(setq native-compile-prune-cache t)

(require 'init-base)
(require 'init-hydra)
(require 'init-ui)
(require 'init-completion)
(require 'init-edit)
(require 'init-dired)
;;(require 'init-dirvish)
(require 'init-yasnippet)

(require 'init-highlight)

(require 'init-gptel)
(require 'init-dict)

(require 'init-markdown)
(require 'init-org)

(require 'init-vcs)
(require 'init-lsp)

(require 'init-check)
(require 'init-prog)
(require 'init-elisp)
(require 'init-go)
(require 'init-solidity)
(require 'init-rust)

(provide 'init)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("36b57dcbe8262c52d3123ed30fa34e5ef6b355881674142162a8ca8e26124da9"
     "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098"
     "7c28419e963b04bf7ad14f3d8f6655c078de75e4944843ef9522dbecfcd8717d"
     "00cec71d41047ebabeb310a325c365d5bc4b7fab0a681a2a108d32fb161b4006"
     "0f76f9e0af168197f4798aba5c5ef18e07c926f4e7676b95f2a13771355ce850" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
