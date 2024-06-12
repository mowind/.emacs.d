;; init-dict.el --- Initalize dicionaries. -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Multiple dictionaries.
;;

;;; Code:

;; A multi dictionaries interface
(use-package fanyi
  :bind (("C-c d f" . fanyi-dwim)
         ("C-c d d" . fanyi-dwim2)
         ("C-c d h" . fanyi-from-history))
  :custom (fanyi-providers '(fanyi-haici-provider
                             fanyi-youdao-thesaurus-provider
                             fanyi-etymon-provider
                             fanyi-longman-provider)))

(use-package go-translate
  :bind (("C-c g" . gt-do-translate)
         ("C-c G" . gt-multi-dict-translate)
         ("C-c u" . gt-do-text-utility)
         ("C-c y" . gt-youdao-dict-translate-dwim)
         ("C-c Y" . gt-youdao-dict-translate)
         ("C-c d b" . gt-bing-translate-dwim)
         ("C-c d B" . gt-bing-translate)
         ("C-c d g" . gt-do-translate)
         ("C-c d G" . gt-multi-dict-translate)
         ("C-c d m" . gt-multi-dict-translate-dwim)
         ("C-c d M" . gt-multi-dict-translate)
         ("C-c d y" . gt-youdao-dict-translate-dwim)
         ("C-c d Y" . gt-youdao-dict-translate)
         ("C-c d s" . gt-do-setup)
         ("C-c d u" . gt-do-text-utility))
  :init
  (setq gt-langs '(en zh)
        gt-buffer-render-follow-p t
        gt-buffer-render-window-config
        '((display-buffer-reuse-window display-buffer-in-direction)
          (direction . bottom)
          (window-height . 0.4)))

  (setq gt-pop-posframe-forecolor (face-foreground 'tooltip nil t)
        gt-pop-posframe-backcolor (face-background 'tooltip nil t))
  (when (facep 'posframe-border)
    (setq gt-pin-posframe-bdcolor (face-background 'posframe-border nil t)))
  :config
  ;; Tweak child frame
  (with-no-warnings
    ;; Translators
    (setq gt-preset-translators
          `((default          . ,(gt-translator :taker   (cdar (gt-ensure-plain gt-preset-takers))
                                                :engines (cdar (gt-ensure-plain gt-preset-engines))
                                                :render  (cdar (gt-ensure-plain gt-preset-renders))))
            (youdao-dict      . ,(gt-translator :taker (gt-taker :langs '(en zh) :text 'word :prompt t)
                                                :engines (gt-youdao-dict-engine)
                                                :render (gt-buffer-render)))
            (youdao-dict-dwim . ,(gt-translator :taker (gt-taker :langs '(en zh) :text 'word)
                                                :engines (gt-youdao-dict-engine)
                                                :render (if (display-graphic-p)
                                                            (gt-posframe-pop-render
                                                             :frame-params (list :accept-focus nil
                                                                                 :width 70
                                                                                 :height 15
                                                                                 :left-fringe 16
                                                                                 :right-fringe 16
                                                                                 :border-width 1
                                                                                 :border-color gt-pin-posframe-bdcolor))
                                                          (gt-buffer-render))))
            (multi-dict       . ,(gt-translator :taker (gt-taker :langs '(en zh) :prompt t)
                                                :engines (list (gt-bing-engine)
                                                               (gt-youdao-dict-engine)
                                                               (gt-youdao-suggest-engine)
                                                               (gt-google-engine))
                                                :render (gt-buffer-render)))
            (multi-dict-dwim  . ,(gt-translator :taker (gt-taker :langs '(en zh))
                                                :engines (list (gt-bing-engine)
                                                               (gt-youdao-dict-engine)
                                                               (gt-youdao-suggest-engine)
                                                               (gt-google-engine))
                                                :render (gt-buffer-render)))
            (Text-Utility     . ,(gt-text-utility :taker (gt-taker :pick nil)
                                                  :render (gt-buffer-render)))))
    (setq gt-default-translator (alist-get 'multi-dict-dwim gt-preset-translators))

    (defun gt--do-translate (dict)
      "Translate using DICT from preset translators."
      (gt-start (alist-get dict gt-preset-translators)))

    (defun gt-youdao-dict-translate ()
      "Translate using Youdao dictionary."
      (interactive)
      (gt--do-translate 'youdao-dict))

    (defun gt-youdao-dict-translate-dwim ()
      "Translate using Youdao dictionary without any prompt."
      (interactive)
      (gt--do-translate 'youdao-dict-dwim))

    (defun gt-bing-translate ()
      "Translate using Bing."
      (interactive)
      (gt--do-translate 'bing))

    (defun gt-bing-translate-dwim ()
      "Translate using Bing without any prompt."
      (gt--do-translate 'bing-dwim))

    (defun gt-multi-dict-translate ()
      "Translate using multiple dictionaries."
      (interactive)
      (gt--do-translate 'multi-dict))

    (defun gt-multi-dict-translate-dwim ()
      "Translate using multiple dictionaries without any prompt."
      (interactive)
      (gt--do-translate 'multi-dict-dwim))

    (defun gt-do-text-utility ()
      "Handle the texts with the utilities."
      (interactive)
      (gt--do-translate 'Text-Utility))))

;; Youdao Dictionary
(use-package youdao-dictionary
  :bind (("C-c y" . my-youdao-dictionary-search-at-point)
         ("C-c d Y" . my-youdao-dictionary-search-at-point)
         ("C-c d y" . youdao-dictionary-search-async)
         :map youdao-dictionary-mode-map
         ("h"       . my-youdao-dictionary-help)
         ("?"       . my-youdao-dictionary-help))
  :init
  (setq url-automatic-caching t)
  (setq youdao-dictionary-use-chinese-word-segmentation t) ; 中文分词
  :config
  (with-no-warnings
    (with-eval-after-load 'hydra
      (defhydra youdao-dictionary-hydra (:color blue)
        ("p" youdao-dictionary-play-voice-of-current-word "play voice of current word")
        ("y" youdao-dictionary-play-voice-at-point "play voice at point")
        ("q" quit-window "quit")
        ("C-g" nil nil)
        ("h" nil nil)
        ("?" nil nil))
      (defun my-youdao-dictionary-help ()
        "Show help in `hydra'."
        (interactive)
        (let ((hydra-hint-display-type 'message))
          (youdao-dictionary-hydra/body))))

    (defun my-youdao-dictionary-search-at-point ()
      "Search word at point and display result with `posframe', `pos-tip' or buffer."
      (interactive)
      (if (posframe-workable-p)
          (youdao-dictionary-search-at-point-posframe)
        (youdao-dictionay-search-at-point)))

    (defun my-youdao-dictionary--posframe-tip (string)
      "Show STRING using `posframe-show'."
      (unless (posframe-workable-p)
        (error "Posframe not workable"))

      (if-let ((word (youdao-dictionary--region-or-word)))
          (progn
            (with-current-buffer (get-buffer-create youdao-dictionary-buffer-name)
              (let ((inhibit-read-only t))
                (erase-buffer)
                (youdao-dictionary-mode)
                (insert string)
                (set (make-local-variable 'youdao-dictionary-current-buffer-word) word)))
            (posframe-show
             youdao-dictionary-buffer-name
             :position (point)
             :left-fringe 8
             :right-fringe 8
             :max-width (/ (frame-width) 2)
             :max-height (/ (frame-height) 2)
             :background-color (face-background 'tooltip nil t)
             :internal-border-color (face-background 'posframe-border nil t)
             :internal-border-width 1)
            (unwind-protect
                (push (read-event) unread-command-events)
              (progn
                (posframe-hide youdao-dictionary-buffer-name)
                (other-frame 0)))
            (message "Nothing to look up"))))
    (advice-add #'youdao-dictionary--posframe-tip
                :override #'my-youdao-dictionary--posframe-tip)))

(provide 'init-dict)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-dict.el ends here
