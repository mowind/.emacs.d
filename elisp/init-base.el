;;; init-base.el --- Basical settings -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package gcmh
  :diminish
  :hook (emacs-startup . gcmh-mode)
  :init
  (setq gcmh-idle-delay 'auto
        gcmh-auto-idle-delay-factor 10
        gcmh-high-cons-threshold #x1000000)) ; 16MB

(when (or (eq system-type 'gnu/linux) (daemonp))
  (use-package exec-path-from-shell
    :custom (exec-path-from-shell-arguments '("-l"))
    :init (exec-path-from-shell-initialize)))

(use-package no-littering)

(use-package savehist
  :hook (after-init . savehist-mode)
  :config
  ;; Allow commands in minibuffers, will affect `dired-do-dired-do-find-regexp-and-replace' command:
  (setq enable-recursive-minibuffers t
        history-length 1000
        savehist-additional-variables '(mark-ring
                                        global-mark-ring
                                        search-ring
                                        regexp-search-ring
                                        extended-command-history)
        savehist-autosave-interval 300))

(use-package saveplace
  :hook (after-init . save-place-mode))

(when (fboundp 'sqlite-open)
  (use-package emacsql-sqlite-builtin))

(use-package recentf
  :bind (("C-x C-r" . recentf-open-files))
  :hook (after-init . recentf-mode)
  :init (setq recentf-max-saved-items 300
              recentf-exclude
              '("\\.?cache" ".cask" "url" "COMMIT_EDITMSG\\'" "bookmarks"
                "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
                "\\.?ido\\.last$" "\\.revive$" "/G?TAGS$" "/.elfeed/"
                "^/tmp/" "^/var/folders/.+$" "^/ssh:" "/persp-confs"
                (lambda (file) (file-in-directory-p file package-user-dir))))
  :config
  (push (expand-file-name recentf-save-file) recentf-exclude)
  (add-to-list 'recentf-filename-handlers #'abbreviate-file-name))

(use-package simple
  :ensure nil
  :hook ((after-init . size-indication-mode)
         (text-mode . visual-line-mode)
         ((prog-mode markdown-mode conf-mode) . enable-trailing-whitespace))
  :init
  (setq column-number-mode t
        line-number-mode t
        line-move-visual nil
        track-eol t                     ; Keep cursor at end of lines. Require line-move-visual is nil.
        set-mark-command-repeat-pop t)  ; Repeating C-SPC after popping mark pops it again

  ;; Visual TAB, (HARD) SPACE, NEWLINE
  (setq-default show-trailing-whitespace nil) ; Don't show trailing whitespace by default
  (defun enable-trailing-whitespace ()
    "Show trailing spaces and delete on saving."
    (setq show-trailing-whitespace t)
    (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))

  ;; Prettify the process list
  (with-no-warnings
    (defun my-list-processes--prettify ()
      "Prettify process list."
      (when-let ((entries tabulated-list-entries))
        (setq tabulated-list-entries nil)
        (dolist (p (process-list))
          (when-let* ((val (cadr (assoc p entries)))
                      (name (aref val 0))
                      (pid (aref val 1))
                      (status (aref val 2))
                      (status (list status
                                    'face
                                    (if (memq status '(stop exit closed failed))
                                        'error
                                      'success)))
                      (buf-label (aref val 3))
                      (tty (list (aref val 4) 'face 'font-lock-doc-face))
                      (thread (list (aref val 5) 'face 'font-lock-doc-face))
                      (cmd (list (aref val 6) 'face 'completions-annotations)))
            (push (list p (vector name pid status buf-label tty thread cmd))
                  tabulated-list-entries)))))
    (advice-add #'list-processes--refresh :after #'my-list-processes--prettify)))

(if (boundp 'use-short-answers)
    (setq use-short-answers t)
  (fset 'yes-or-no-p 'y-or-n-p))
(setq-default major-mode 'text-mode
              fill-column 80
              tab-width 4
              indent-tabs-mode nil) ; Permanently indent with spaces, never with TABs

(setq visible-bell t
      inhibit-compacting-font-caches t  ; Don't compact font caches during GC
      delete-by-moving-to-trash t       ; Deleting files go to OS's trash folder
      make-backup-files nil             ; Forbide to make backup files
      auto-save-default nil             ; Disable auto save

      uniquify-buffer-name-style 'post-forward-angle-brackets ; Show path if name are same
      adaptive-fill-regexp "[ +t]+|[ t]*([0-9]+.|*+)[ t]*"
      adaptive-fill-first-line-regexp "^* *$"
      sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*"
      sentence-end-double-space  nil
      word-wrap-by-category t)

(use-package disk-usage)
(use-package memory-usage)

;; Frame transparence
(when (display-graphic-p)
  (use-package transwin
    :bind (("C-M-9" . transwin-inc)
           ("C-M-8" . transwin-dec)
           ("C-M-7" . transwin-toggle))
    :init
    (setq transwin-parameter-alpha 'alpha-background)))

;; Display available keybindings in popup
(use-package which-key
  :diminish
  :bind ("C-h M-m" . which-key-show-major-mode)
  :hook (after-init . which-key-mode)
  :init (setq which-key-max-description-length 30
              which-key-lighter nil
              which-key-show-remaining-keys t)
  :config
  (which-key-add-key-based-replacements "C-c !" "flycheck")
  (which-key-add-key-based-replacements "C-c &" "yasnippet")
  (which-key-add-key-based-replacements "C-c @" "hideshow")
  (which-key-add-key-based-replacements "C-c t" "hl-todo")

  (which-key-add-key-based-replacements "C-x 8" "unicode")
  (which-key-add-key-based-replacements "C-x 8 e" "emoji")
  (which-key-add-key-based-replacements "C-x @" "modifior")
  (which-key-add-key-based-replacements "C-x n" "narrow")
  (which-key-add-key-based-replacements "C-x r" "rect & bookmark")
  (which-key-add-key-based-replacements "C-x t" "tab & treemacs")
  (which-key-add-key-based-replacements "C-x x" "buffer")
  (which-key-add-key-based-replacements "C-x RET" "coding-system")

  (which-key-add-major-mode-key-based-replacements 'org-mode "C-c \"" "org-plot")
  (which-key-add-major-mode-key-based-replacements 'org-mode "C-c C-v" "org-babel")
  (which-key-add-major-mode-key-based-replacements 'org-mode "C-c C-x" "org-misc")

  (which-key-add-major-mode-key-based-replacements 'emacs-lisp-mode "C-c ," "overseer")
  (which-key-add-major-mode-key-based-replacements 'python-mode "C-c C-t" "python-skeleton")

  (which-key-add-major-mode-key-based-replacements 'markdown-mode "C-c C-a" "markdown-link")
  (which-key-add-major-mode-key-based-replacements 'markdown-mode "C-c C-c" "markdown-command")
  (which-key-add-major-mode-key-based-replacements 'markdown-mode "C-c C-s" "markdown-style")
  (which-key-add-major-mode-key-based-replacements 'markdown-mode "C-c C-t" "markdown-header")
  (which-key-add-major-mode-key-based-replacements 'markdown-mode "C-c C-x" "markdown-toggle")

  (which-key-add-major-mode-key-based-replacements 'gfm-mode "C-c C-a" "markdown-link")
  (which-key-add-major-mode-key-based-replacements 'gfm-mode "C-c C-c" "markdown-command")
  (which-key-add-major-mode-key-based-replacements 'gfm-mode "C-c C-s" "markdown-style")
  (which-key-add-major-mode-key-based-replacements 'gfm-mode "C-c C-t" "markdown-header")
  (which-key-add-major-mode-key-based-replacements 'gfm-mode "C-c C-x" "markdown-toggle")

  (use-package which-key-posframe
    :diminish
    :functions posframe-poshandler-frame-center-near-bottom
    :custom-face
    (which-key-posframe ((t (:inherit tooltip))))
    (which-key-posframe-border ((t (:inherit posframe-border :background unspecified))))
    :init
    (setq which-key-posframe-border-width posframe-border-width
          which-key-posframe-poshandler #'posframe-poshandler-frame-center-near-bottom
          which-key-posframe-parameters '((left-fringe . 8)
                                          (right-fringe .8)))
    (which-key-posframe-mode 1)))

(provide 'init-base)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-base.el ends here
