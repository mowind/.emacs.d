;;; init-ui.el --- UI settings -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

;; Optimization
(setq idle-update-delay 1.0)

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t)
(setq redisplay-skip-fontification-on-input t)

(use-package ef-themes
  :bind ("C-c t" . ef-themes-toggle)
  :init
  ;; set two specific themes and switch between them
  (setq ef-themes-to-toggle '(ef-summer ef-elea-dark))
  ;;set org headings and function syntax
  (setq ef-themes-headings
        '((0 . (bold 1))
          (1 . (bold 1))
          (2 . (rainbow bold 1))
          (3 . (rainbow bold 1))
          (4 . (rainbow bold 1))
          (t . (rainbow bold 1))))
  (setq ef-themes-region '(intense no-extend neutral))
  ;; Disable all other themes to avoid awkward blending:
  (mapc #'disable-theme custom-enabled-themes))

;;(load-theme 'ef-elea-dark t))

(use-package solaire-mode
  :hook (after-init . solaire-global-mode))

(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :init (load-theme 'doom-dracula t)
  :config
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; WORKAROUND: Visual bell on 29+
  ;; @see https://github.com/doomemacs/themes/issues/733
  (with-no-warnings
    (defun my-doom-themes-visual-bell-fn ()
      "Blink the mode-line red briefly. Set `ring-bell-function' to this to use it."
      (let ((buf (current-buffer))
            (cookies (mapcar (lambda (face)
                               (face-remap-add-relative face 'doom-themes-visual-bell))
                             (if (facep 'mode-line-active)
                                 '(mode-line-active solaire-mode-line-active-face)
                               '(mode-line solaire-mode-line-face)))))
        (force-mode-line-update)
        (run-with-timer 0.15 nil
                        (lambda ()
                          (with-current-buffer buf
                            (mapc #'face-remap-remove-relative cookies)
                            (force-mode-line-update))))))
    (advice-add #'doom-themes-visual-bell-fn :override #'my-doom-themes-visual-bell-fn)))

(use-package modus-themes)

(defun font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (find-font (font-spec :name font-name)))

(defun my-setup-fonts ()
  "Setup fonts."
  (when (display-graphic-p)
    ;; Sest default font
    (cl-loop for font in '("Source Code Pro" "Monaspace Neon" "Delugia PL Mono" "Cascadia Code" "IBM Plex Mono"
                           "Fira Code" "SF Mono")
             when (font-installed-p font)
             return (set-face-attribute 'default nil
                                        :family font
                                        :height 116)))

  ;; Specify font for all unicode characters
  (cl-loop for font in '("Segoe UI Symbol" "Symbola" "Symbol")
           when (font-installed-p font)
           return (if (< emacs-major-version 27)
                      (set-fontset-font "fontset-default" 'unicode font nil 'prepend)
                    (set-fontset-font t 'symbol (font-spec :fmaily font) nil 'prepend)))

  ;; Emoji
  (cl-loop for font in '("Noto Color Emoji" "Apple Color Emoji" "Segoe UI Emoji")
           when (font-installed-p font)
           return (cond
                   ((< emacs-major-version 27)
                    (set-fontset-font "fontset-default" 'uncode font nil 'prepend))
                   ((< emacs-major-version 28)
                    (set-fontset-font t 'symbol (font-spec :fmaily font) nil 'prepend))
                   (t
                    (set-fontset-font t 'emoji (font-spec :fmaily font) nil 'prepend))))

  ;; Specify font for Chinese characters
  (cl-loop for font in '("LXGW Neo XiHei" "WenQuanYi Micro Hei Mono" "LXGW WenKai Screen")
           when (font-installed-p font)
           return (progn
                    (setq face-font-rescale-alist `((,font . 1.3)))
                    (set-fontset-font t 'han (font-spec :family font)))))

(my-setup-fonts)
(add-hook 'window-setup-hook #'my-setup-fonts)

;; Easily adjust the font size in all frames
(use-package default-text-scale
  :hook (after-init . default-text-scale-mode)
  :bind (:map default-text-scale-mode-map
         ("s-="   . default-text-scale-increase)
         ("s--"   . default-text-scale-decrease)
         ("s-0"   . default-text-scale-reset)
         ("C-s-=" . default-text-scale-increase)
         ("C-s--" . default-text-scale-decrease)
         ("C-s-0" . default-text-scale-reset)))

;; 设置窗口大小，仅仅在图形界面需要设置
(when (display-graphic-p)
  (let ((frame (selected-frame)))
    (set-frame-width frame (/ (display-pixel-width) 2) nil 'pixelwise)
    (set-frame-height frame (/ (display-pixel-height) 2) nil 'pixelwise)
    (set-frame-position frame (/ (display-pixel-width) 4) 0)))

;; 禁用一些 GUI 特性
(setq use-dialog-box nil)               ; 鼠标操作不使用对话框
(setq inhibit-default-init nil)         ; 不加载 `default' 库
(setq inhibit-startup-screen nil)       ; 不加载启动画面
(setq inhibit-startup-message nil)      ; 不加载启动消息
(setq inhibit-startup-buffer-menu nil)  ; 不显示缓冲区列表

(unless (daemonp)
  (advice-add #'display-startup-echo-area-message :override #'ignore))

;; 草稿缓冲区默认文字设置
(setq initial-scratch-message (concat ";; Happy hacking, "
                                      (capitalize user-login-name) " - Emacs ♥ you!\n\n"))

;; 设置缓冲区的文字方向为从左到右
(setq bidi-paragraph-direction 'left-to-right)
;; 禁止使用双向括号算法

;; 设置自动折行宽带为 80 字符，默认值为 70
(setq-default fill-column 80)

;; 设置文件阈值为 100MB，默认 10MB
(setq large-file-warning-threshold 100000000)

;; 以 16 进制显示字节数
(setq display-raw-bytes-as-hex t)
;; 有输入时禁止 `fontification' 相关的函数钩子，能让滚动更顺滑
(setq redisplay-skip-fontification-on-input t)

;; 禁止响铃
(setq ring-bell-function 'ignore)

;; 禁止闪烁光标
(blink-cursor-mode -1)

;; 在光标处而非鼠标所在位置粘贴
(setq mouse-yank-at-point t)

;; 拷贝粘贴设置
(setq select-enable-primary nil)  ; 选择文字时不拷贝
(setq select-enable-clipboard t)  ; 拷贝时使用剪贴板

;; 鼠标滚动设置
(when (display-graphic-p)
  (setq mouse-wheel-scroll-amount '(1 ((shift) . hscroll))
        mouse-wheel-scroll-amount-horizontal 1
        mouse-wheel-progressive-speed nil))
(setq scroll-step 1)
(setq scroll-margin 0)
(setq scroll-conservatively 1000000)
;;(setq scroll-up-aggressively 0.01)
;;(setq scroll-down-aggressively 0.01)
(setq scroll-preserve-screen-position t)

;; Good pixel line scrolling
(if (fboundp 'pixel-scroll-precision-mode)
    (pixel-scroll-precision-mode t))


;; 对于高的行禁止自动垂直滚动
(setq auto-window-vscroll nil)

;; 设置新分屏打开的位置的阈值
(setq split-width-threshold (assoc-default 'width default-frame-alist))
(setq split-height-threshold nil)

;; TAB 键设置，在 Emacs 里不使用 TAB 键，所有的 TAB 键默认为 4 个空格
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; yes 或 no 提示设置，通过下面这个函数设置当前缓存区名字匹配到预设的字符串时自动回答 yes
(setq original-y-or-n-p 'y-or-n-p)
(defalias 'original-y-or-n-p (symbol-function 'y-or-n-p))
(defun default-yes-sometimes (prompt)
  "automatically say y when buffer name match following string"
  (if (or
       (string-match "has a running process" prompt)
       (string-match "does not exist; create" prompt)
       (string-match "modified; kill anyway" prompt)
       (string-match "Delete buffer using" prompt)
       (string-match "Kill buffer of" prompt)
       (string-match "still connected. Kill it?" prompt)
       (string-match "Shutdown the client's kernel" prompt)
       (string-match "kill them and exit anyway" prompt)
       (string-match "Revert buffer from file" prompt)
       (string-match "Kill Dired buffer of" prompt)
       (string-match "delete buffer using" prompt)
       (string-match "Kill all pass entry" prompt)
       (string-match "for all cursors" prompt)
       (string-match "Do you want edit the entry" prompt))
      t
    (original-y-or-n-p prompt)))
(defalias 'yes-or-no-p 'default-yes-sometimes)
(defalias 'y-or-n-p 'default-yes-sometimes)

;; 设置剪贴板历史长度 200，默认为 60
(setq kill-ring-max 200)

;; 在剪贴板不存储重复内容
(setq kill-do-not-save-duplicates t)

;; 设置位置记录长度为 6，默认为 16
;; 可以使用 `counsel-mark-ring' or `consult-mark' (C-x j) 来访问光标位置记录
;; 使用 C-x C-SPC 执行 `pop-global-mark' 直接跳到上一个全局位置处
(setq mark-ring-max 6)
(setq global-mark-ring-max 6)

;; 设置 emacs-lisp 的限制
(setq max-lisp-eval-depth 10000)  ; 默认值为 800
(setq max-specpdl-size 10000)     ; 默认值为 1600

;; 启用 `list-timers', `list-threads' 两个命令
(put 'list-timers 'disabled nil)
(put 'list-threads 'disabled nil)

;; 在命令行里支持鼠标
(xterm-mouse-mode 1)

;; 退出 Emacs 时进行确认
(setq confirm-kill-emacs 'y-or-n-p)

;; 在模式栏上显示当前光标的列号
(column-number-mode t)

;; 配置所有的编码为 UTF-8，参考:
;; https://thraxys.wordpress.com/2016/01/13/utf-8-in-emacs-everywhere-forever/
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

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init
  (setq doom-modeline-icon t
        doom-modeline-minor-modes t))

(use-package hide-mode-line
  :hook (((treemacs-mode
           eshell-mode shell-mode
           term-mode vterm-mode
           embark-collect-mode
           pdf-annot-list-mode) . turn-on-hide-mode-line-mode)
         (dired-mode . (lambda ()
                         (and (bound-and-true-p hide-mode-line-mode)
                              (turn-off-hide-mode-line-mode))))))

(use-package minions
  :hook (doom-modeline-mode . minions-mode))


  ;; awesome-tray
  ;;(use-package awesome-tray
  ;;  :straight '(awesome-tray
  ;;              :type git
  ;;              :host github
  ;;              :repo "manateelazycat/awesome-tray"
  ;;              :files ("*" (:exclude ".git"))
  ;;              :build (:not compile))
  ;;  :init
  ;;  (awesome-tray-mode 1)
  ;;  :custom
  ;;  (awesome-tray-active-modules '("location" "pdf-view-page" "belong" "file-path" "mode-name" "last-command" "battery" "date"))
  ;;  (awesome-tray-info-padding-right 1))

(use-package nerd-icons
  :config
  (when (and (display-graphic-p)
             (not (find-font (font-spec :name nerd-icons-font-family))))
    (nerd-icons-install-fonts t)))

;; Show line numbers
(use-package display-line-numbers
  :ensure nil
  :hook ((prog-mode yaml-mode conf-mode) . display-line-numbers-mode)
  :init (setq display-line-numbers-width-start t))

;; Directional window-selection routines
(use-package windmove
  :ensure nil
  :hook (after-init . (lambda ()
                        (windmove-default-keybindings 'super))))

;; Quickly switch windows
(use-package ace-window
  :custom-face
  (aw-leading-char-face ((t (:inherit font-lock-keyword-face :foreground unspecified :bold t :height 3.0))))
  (aw-minibuffer-leading-char-face ((t (:inherit font-lock-keyword-face :bold t :height 1.0))))
  (aw-mode-line-face ((t (:inherit mode-line-emphasis :bold t))))
  :bind (([remap other-window] . ace-window))
  :hook (emacs-startup-hook . ace-window-display-mode)
  :config
  (defun toggle-window-split ()
    (interactive)
    (if (= (count-windows) 2)
        (let* ((this-win-buffer (window-buffer))
               (next-win-bffer (window-buffer (next-window)))
               (this-win-edges (window-edges (selected-window)))
               (next-win-edges (window-edges (next-window)))
               (this-win-2nd (not (and (<= (car this-win-edges)
                                           (car next-win-edges))
                                       (<= (cadr this-win-edges)
                                           (cadr next-win-edges)))))
               (splitter
                (if (= (car this-win-edges)
                       (car (window-edges (next-window))))
                    'split-window-horizontally
                  'split-window-vertically)))
          (delete-other-windows)
          (let ((first-win (selected-window)))
            (funcall splitter)
            (if this-win-2nd (other-window 1))
            (set-window-buffer (selected-window) this-win-buffer)
            (set-window-buffer (next-window) next-win-bffer)
            (select-window first-win)
            (if this-win-2nd (other-window 1))))
      (user-error "`toggle-window-split' only supports two windows")))

  ;; Select window via `M-1'...`M-9'
  (defun aw--select-window (number)
    "Select the specified window."
    (when (numberp number)
      (let ((found nil))
        (dolist (win (aw-window-list))
          (when (and (window-live-p win)
                     (eq number
                         (string-to-number
                          (window-parameter win 'ace-window-path))))
            (setq found t)
            (aw-switch-to-window win)))
        (unless found
          (message "No specified window: %d" number)))))
  (dotimes (n 9)
    (bind-key (format "M-%d" (1+ n))
              (lambda ()
                (interactive)
                (aw--select-window (1+ n))))))

(use-package popper
  :custom
  (popper-group-function #'popper-group-by-directory)
  (popper-echo-dispatch-actions t)
  :bind (:map popper-mode-map
              ("C-h z" . popper-toggle)
              ("C-<tab>" . popper-cycle)
              ("C-M-<tab>" . popper-toggle-type))
  :hook (emacs-startup . popper-echo-mode)
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "\\*Async Shell Command\\*"
          help-mode
          helpful-mode
          occur-mode
          pass-view-mode
          "^\\*eshell.*\\*$" eshell-mode
          "^\\*shell.*\\*$" shell-mode
          (compilation-mode . hide)
          ;; derived from `fundamental-mode' and fewer than 10 lines will be considered a popup
          (lambda (buf) (with-current-buffer buf
                          (and (derived-mode-p 'fundamental-mode)
                               (< (count-lines (point-min) (point-max))
                                  10))))))

  (with-eval-after-load 'doom-modeline
    (setq popper-mode-line
          '(:eval (let ((face (if (doom-modeline--active)
                                  'doom-modeline-emphasis
                                'doom-modeline)))
                    (if (and (bound-and-true-p doom-modeline-icon)
                             (bound-and-true-p doom-modeline-mode))
                        (format " %s "
                                (nerd-icons-octicon "nf-oct-pin" :face face))
                      (propertize " POP " 'face face))))))
  :config
  (with-no-warnings
    (defun my-popper-fit-window-height (win)
      "Determine the height of popup window WIN by fitting it to the buffer's content."
      (fit-window-to-buffer
       win
       (floor (frame-height) 3)
       (floor (frame-height) 3)))
    (setq popper-window-height #'my-popper-fit-window-height)

    (defun popper-close-window-hack (&rest _)
      "Close popper window via `C-g'."
      ;; `C-g' can deactivate region
      (when (and (called-interactively-p 'interactive)
                 (not (region-active-p))
                 popper-open-popup-alist)
        (let ((window (caar popper-open-popup-alist)))
          (when (window-live-p window)
            (delete-window window)))))
    (advice-add #'keyboard-quit :before #'popper-close-window-hack)))

(when (not (or noninteractive
               emacs-basic-display
               (not (display-graphic-p))))
  (use-package posframe
    :hook (after-load-theme . posframe-delete-all)
    :init
    (defface posframe-border
      '((t (:inhibit region)))
      "Face used by the `posframe' border."
      :group 'posframe)
    (defvar posframe-border-width 2
      "Default posframe border width.")
    :config
    (with-no-warnings
      (defun my-posframe--prettify-frame (&rest _)
        (set-face-background 'fringe nil posframe--frame))
      (advice-add #'posframe--create-posframe :after #'my-posframe--prettify-frame)

      (defun posframe-poshandler-frame-center-near-bottom (info)
        (cons (/ (- (plist-get info :parent-frame-width)
                    (plist-get info :posframe-width))
                 2)
              (/ (+ (plist-get info :parent-frame-height)
                    (* 2 (plist-get info :font-height)))
                 2))))))

(use-package iscroll
  :diminish
  :hook (image-mode . iscroll-mode))

(use-package mixed-pitch
  :diminish)

(use-package page-break-lines
  :diminish
  :hook (after-init . global-page-break-lines-mode))

(provide 'init-ui)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-ui.el ends here
