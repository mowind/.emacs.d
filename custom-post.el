;;; custome-post.el -- user custom packages configurations. -*- lexical-binding: t -*-
;;
;;; Commentary:

;;; Code:

;; Format all
(use-package format-all
  :commands format-all-mode
  :hook ((prog-mode . format-all-mode)
         (format-all-mode . format-all-ensure-formatter))
  :bind
  (:map prog-mode-map
   ("C-c f" . format-all-buffer))
  :config
  (setq-default format-all-formatters
                '(("Go" goimports)
                  ("Haskell" stylish-haskell))))

;; ef-theme
(use-package ef-themes
  ;;:init
  ;;(load-theme 'ef-spring :no-confirm)
  :config
  (setq ef-themes-variable-pitch-ui t
        ef-themes-mixed-fonts t
        ef-themes-headings ; read the manual's entry of the doc string
        '((0 . (variable-pitch light 1.9))
          (1 . (variable-pitch light 1.8))
          (2 . (variable-pitch regular 1.7))
          (3 . (variable-pitch regular 1.6))
          (4 . (variable-pitch regular 1.5))
          (5 . (variable-pitch 1.4)) ; absence of weight means `bold'
          (6 . (variable-pitch 1.3))
          (7 . (variable-pitch 1.2))
          (agenda-date . (semilight 1.5))
          (agenda-structure . (variable-pitch light 1.9))
          (t . (variable-pitch 1.1))))

  (defun my-ef-themes-mode-line ()
    "Tweak the style of the mode lines."
    (ef-themes-with-colors
     (custom-set-faces
      `(mode-line ((,c :background ,bg-active :foreground ,fg-main :box (:line-width 1 :color ,fg-dim))))
      `(mode-line-inactive ((,c :box (:line-width 1 :color ,bg-active)))))))

  (add-hook 'ef-themes-post-load-hook #'my-ef-themes-mode-line)

  ;; Disable all other themes to avoid awkward blending:
  (mapc #'disable-theme custom-enabled-themes))

;; modus-themes
(use-package modus-themes
  ;;:init
  ;;(load-theme 'modus-vivendi-tinted :no-confirm)
  :config
  ;; In all of the following, WEIGHT is a symbol such as `semibold',
  ;; `light', `bold', or anything mentioned in `modus-themes-weights'.
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t
        modus-themes-variable-pitch-ui t
        modus-themes-custom-auto-reload t
        modus-themes-disable-other-themes t

        ;; Options for `modus-themes-prompts' are either nil (the
        ;; default), or a list of properties that may include any of those
        ;; symbols: `italic', `WEIGHT'
        modus-themes-prompts '(bold)

        ;; The `modus-themes-completions' is an alist that reads two
        ;; keys: `matches', `selection'.  Each accepts a nil value (or
        ;; empty list) or a list of properties that can include any of
        ;; the following (for WEIGHT read further below):
        ;;
        ;; `matches'   :: `underline', `italic', `WEIGHT'
        ;; `selection' :: `underline', `italic', `WEIGHT'
        modus-themes-completions
        '((matches . (extrabold))
          (selection . (semibold italic text-also)))

        ;; modus-themes-org-blocks 'gray-background ; {nil,'gray-background,'tinted-background}

        ;; The `modus-themes-headings' is an alist: read the manual's
        ;; node about it or its doc string.  Basically, it supports
        ;; per-level configurations for the optional use of
        ;; `variable-pitch' typography, a height value as a multiple of
        ;; the base font size (e.g. 1.5), and a `WEIGHT'.
        modus-themes-headings
        '((1 . (variable-pitch 1.5))
          (2 . (1.3))
          (agenda-date . (1.3))
          (agenda-structure . (variable-pitch light 1.8))
          (t . (1.1))))

  (mapc #'disable-theme custom-enabled-themes))

;;(load-theme 'modus-vivendi-tinted :no-confirm)

(use-package color-theme-sanityinc-tomorrow)

(use-package rose-pine
  :straight '(rose-pine
              :type git
              :host github
              :repo "LuciusChen/rose-pine"))

(disable-theme 'doom-one :no-confirm)
(load-theme 'rose-pine-night :no-confirm)

;; telega
(use-package telega
  :straight '(telega
              :type git
              :host github
              :repo "LuciusChen/telega.el")
  :commands (telega)
  :config
  (telega-mode-line-mode 1)
  (telega-chat-auto-fill-mode -1)
  (setq telega-proxies '((:server "127.0.0.1" :port 7890 :enable t :type (:@type "proxyTypeSocks5"))))
  (setq telega-open-file-function 'org-open-file
        telega-chat-fill-column 90
        telega-sticker-size '(6 . 24)
        ;; 替代两行头像，防止头像因为字符高度不统一裂开。
        telega-avatar-workaround-gaps-for '(return t)
        ;; 以下都是 telega-symbols-emojify 中的 telega-symbol
        ;; telega-symbol
        ;; remove iterm from `telega-symbols-emojify`
        telega-translate-to-language-by-default "zh"
        telega-msg-save-dir "~/Downloads"
        telega-chat-input-markups '("markdown2" "org")
        telega-emoji-use-images nil
        telega-chat-show-deleted-messages-for '(not saved-messages)
        ;;telega-root-default-view-function 'telega-view-folders
        telega-root-keep-cursor 'track
        telega-root-show-avatars nil
        telega-root-buffer-name "*Telega Root*"
        ;; remove chat folder icons
        telega-chat-folders-insexp (lambda () nil)
        telega-filters-custom nil
        telega-root-fill-column 70 ; fill-column
        telega-filter-custom-show-folders nil
        telega-url-shorten-regexps
        ;; telega-url-shorten
        (list `(too-long-link
                :regexp "^\\(https?://\\)\\(.\\{55\\}\\).*?$"
                :symbol ""
                :replace "\\1\\2..."))

        telega-symbols-emojify
        (cl-reduce (lambda (emojify key)
                     (assq-delete-all key emojify))
                   '(verified vertical-bar checkmark forum heavy-checkmark reply reply-quote horizontal-bar forward button-close)
                   :initial-value telega-symbols-emojify)
        telega-symbol-button-close (nerd-icons-mdicon "nf-md-close")
        telega-symbol-verified (nerd-icons-codicon "nf-cod-verified_filled" :face 'telega-blue)
        telega-symbol-vertical-bar "│" ;; U+2502 Box Drawings Light Vertical
        telega-symbol-saved-messages-tag-end (nerd-icons-faicon "nf-fa-tag")
        telega-symbol-forum (nerd-icons-mdicon "nf-md-format_list_text")
        telega-symbol-flames (nerd-icons-mdicon "nf-md-delete_clock")
        telega-symbol-mark (propertize " " 'face 'telega-button-highlight)
        telega-symbol-reply (nerd-icons-faicon "nf-fa-reply")
        telega-symbol-reply-quote (nerd-icons-faicon "nf-fa-reply_all")
        telega-symbol-forward (nerd-icons-faicon "nf-fa-mail_forward")
        telega-symbol-checkmark (nerd-icons-mdicon "nf-md-check")
        telega-symbol-heavy-checkmark (nerd-icons-codicon "nf-cod-check_all")
        ;; palettes 根据使用主题的配色去置换
        telega-builtin-palettes-alist '((light
                                         ((:outline "#b4637a") (:foreground "#b4637a"))
                                         ((:outline "#ea9d34") (:foreground "#ea9d34"))
                                         ((:outline "#907aa9") (:foreground "#907aa9"))
                                         ((:outline "#568D68") (:foreground "#568D68"))
                                         ((:outline "#286983") (:foreground "#286983"))
                                         ((:outline "#56949f") (:foreground "#56949f"))
                                         ((:outline "#d7827e") (:foreground "#d7827e")))
                                        (dark
                                         ((:outline "#eb6f92") (:foreground "#eb6f92"))
                                         ((:outline "#f6c177") (:foreground "#f6c177"))
                                         ((:outline "#b294bb") (:foreground "#b294bb"))
                                         ((:outline "#95b1ac") (:foreground "#95b1ac"))
                                         ((:outline "#81a2be") (:foreground "#81a2be"))
                                         ((:outline "#9ccfd8") (:foreground "#9ccfd8"))
                                         ((:outline "#ebbcba") (:foreground "#ebbcba"))))))

;; utf-8 setting
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))


;; eee.el: Extended Emacs With External Tui application
;; eee.el configurations
(use-package eee
  :straight '(eee
              :type git
              :host github
              :repo "eval-exec/eee.el"
              :files (:defaults "*.el" "*.sh"))
  :bind-keymap
  ("s-e" . ee-keymap))

(use-package solidity-mode)

(use-package koishi-theme
  :straight '(koishi-theme
              :type git
              :host github
              :repo "gynamics/koishi-theme.el"
              :files (:defaults "*.el")
              :build (:not compile))
  :init
  ;; load a sweet color theme
  ;; currently koishi-theme is not suitable for 8-color terminal
  ;;(when (or (daemonp) (>= (display-color-cells) 256))
  ;;(load-theme 'koishi))
  ;; background transparency in TUI mode
  (unless (or (daemonp) (display-graphic-p))
    (setf (alist-get 'background-color default-frame-alist) nil))
  )

;;(load-theme 'doom-one :no-confirm)

(provide 'custom-post)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; custom-post.el ends here
