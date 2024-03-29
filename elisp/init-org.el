;; init-org.el --- Org mode configurations. -*- lexical-binding: t -*-
;;
;;; Commentary:

;;; Code:

(use-package org
  :ensure nil
  :custom-face
  (org-ellipsis ((t (:foreground unspecified))))
  (org-document-title ((t (:height 1.75 :weight bold))))
  (org-level-1 ((t (:height 1.2 :weight bold))))
  (org-level-2 ((t (:height 1.15 :weight bold))))
  (org-level-3 ((t (:height 1.1 :weight bold))))
  (org-level-4 ((t (:height 1.05 :weight bold))))
  (org-level-5 ((t (:height 1.0 :weight bold))))
  (org-level-6 ((t (:height 1.0 :weight bold))))
  (org-level-7 ((t (:height 1.0 :weight bold))))
  (org-level-8 ((t (:height 1.0 :weight bold))))
  (org-level-9 ((t (:height 1.0 :weight bold))))
  ;; 设置代码块用上下边线包裹
  (org-block-begin-line ((t (:underline t :background unspecified))))
  (org-block-end-line ((t (:overline t :underline nil :background unspecified))))
  :bind (("C-c a" . org-agenda)
         ("C-c b" . org-switchb)
         ("C-c x" . org-capture))
  :hook (((org-babel-after-execute org-mode) . org-redisplay-inline-images) ; display image
         (org-indent-mode . (lambda ()
                              (diminish 'org-indent-mode)
                              ;; HACK: Prevent text moving around while using brackets
                              ;; @see https://github.com/seagle0128/.emacs.d/issues/88
                              (make-variable-buffer-local 'show-paren-mode)
                              (setq show-paren-mode nil)))
         (org-mode . my/org-prettify-symbols))
  :config
  (defun my/org-prettify-symbols ()
    (setq prettify-symbols-alist
          (mapcan (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
                  '(
                    ("#+end_src"        . 9633)         ; □
                    ("#+begin_example"  . 129083)       ; 🠻
                    ("#+end_example"    . 129081)       ; 🠹
                    ("#+results:"       . 9776)         ; ☰
                    ("#+attr_latex:"    . "🄛")
                    ("#+attr_html:"     . "🄗")
                    ("#+attr_org:"      . "🄞")
                    ("#+name:"          . "🄝")         ; 127261
                    ("#+caption:"       . "🄒")         ; 127250
                    ("#+date:"          . "📅")         ; 128197
                    ("#+author:"        . "💁")         ; 128100
                    ("#+setupfile:"     . 128221)       ; 📝
                    ("#+email:"         . 128231)       ; 📧
                    ("#+startup:"       . 10034)        ; ✲
                    ("#+options:"       . 9965)         ; ⛭
                    ("#+title:"         . 10162)        ; ➲
                    ("#+subtitle:"      . 11146)        ; ⮊
                    ("#+downloaded:"    . 8650)         ; ⇊
                    ("#+language:"      . 128441)       ; 🖹
                    ("#+begin_quote"    . 187)          ; »
                    ("#+end_quote"      . 171)          ; «
                    ("#+begin_results"  . 8943)         ; ⋯
                    ("#+end_results"    . 8943)         ; ⋯
                    )))
    (setq prettify-symbols-unprettify-at-point t)
    (prettify-symbols-mode 1))

  ;; 提升latex预览的图片清晰度
  (plist-put org-format-latex-options :scale 1.8)

  (setq org-blank-before-new-entry '((heading t)
                                     (plain-list-item . auto)))

  (defun my-func/open-and-play-git-image (file &optional link)
    "Open and play GIF image `FILE' in Emacs buffer.

Optional for Org-mode file: `LINK'."
    (let ((gif-image (create-image file))
          (tmp-buf (get-buffer-create "*Org-mode GIF image animation*")))
      (switch-to-buffer tmp-buf)
      (erase-buffer)
      (insert-image gif-image)
      (image-animate gif-image nil t)
      (local-set-key (kbd "q") 'bury-buffer)))
  (setq org-file-apps '(("\\.png\\'" . default)
                        (auto-mode . emacs)
                        (directory . emacs)
                        ("\\.mm\\'" . default)
                        ("\\.x?html?\\'" . default)
                        ("\\.pdf\\'" . emacs)
                        ("\\.md\\'" . emacs)
                        ("\\.gif\\'" . my-func/open-and-play-gif-image)
                        ("\\.xlsx\\'" . default)
                        ("\\.svg\\'" . default)
                        ("\\.pptx\\'" . default)
                        ("\\.docx\\'" . default)))

  (setq org-confirm-babel-evaluate nil
        org-src-fontify-natively t
        org-src-tab-acts-natively t)

  (defconst load-language-alist
    '((emacs-lisp . t)
      (perl . t)
      (python . t)
      (ruby . t)
      (js . t)
      (css . t)
      (sass . t)
      (C . t)
      (java . t)
      (shell . t)
      (plantuml . t))
    "Alist of org ob languages.")

  (use-package ob-go
    :init (cl-pushnew '(go . t) load-language-alist))

  (use-package ob-rust
    :init (cl-pushnew '(rust . t) load-language-alist))

  ;; Install npm install -g @mermaid-js/mermaid-cli
  (use-package ob-mermaid
    :init (cl-pushnew '(mermaid . t) load-language-alist))

  (org-babel-do-load-languages 'org-babel-load-languages
                               load-language-alist)

  (use-package org-rich-yank
    :bind (:map org-mode-map
                ("C-M-y" . org-rich-yank)))

  ;; Table of contents
  (use-package toc-org
    :hook (org-mode . toc-org-mode))

  ;; Export text/html MIME emails
  (use-package org-mime
    :bind (:map message-mode-map
                ("C-c M-o" . org-mime-htmlize)
                :map org-mode-map
                ("C-c M-o" . org-mime-org-buffer-htmlize)))

  ;; Add graphical view of agenda
  (use-package org-timeline
    :hook (org-agenda-finalize . org-timeline-insert-timeline))

  ;; Auto-toggle Org LaTeX fragments
  (use-package org-fragtog
    :diminish
    :hook (org-mode . org-fragtog-mode))

  ;; Preview
  (use-package org-preview-html
    :diminish
    :bind (:map org-mode-map
                ("C-c C-h" . org-preview-html-mode))
    :init (when (featurep 'xwidget-internal)
            (setq org-preview-html-viewer 'xwidget)))
  :custom
  (org-directory "~/org")
  (org-default-notes-file (expand-file-name "capture.org" org-directory))
  (org-modules '(ol-bibtex ol-gnus ol-info ol-eww org-habit org-protocol))
  (org-fontify-whole-heading-line t)
  (org-ellipsis " ▾")
  (org-loop-over-headlines-in-active-region t)
  (org-fontify-todo-headline t)
  (org-fontify-done-headline t)
  (org-fontify-quote-and-verse-blocks t)
  (org-hide-macro-markers t)
  (org-hide-emphasis-markers t)
  (org-highlight-latex-and-related '(native script entities))
  (org-pretty-entities t)
  (org-indent-mode-turns-on-hiding-stars t)
  (org-startup-indented nil)
  (org-adapt-indentation nil)
  (org-startup-with-inline-images t)
  (org-startup-folded 'overview)
  (org-list-allow-alphabetical t)
  (org-list-demote-modify-bullet '(("-"  . "+")
                                   ("+"  . "1.")
                                   ("1." . "a.")))
  (org-fold-catch-invisible-edits 'smart)
  (org-insert-heading-respect-content nil)
  (org-image-actual-width nil)
  (org-imenu-depth 4)
  (org-return-follows-link nil)
  (org-use-sub-superscripts '{})
  (org-clone-delete-id t)
  (org-yank-adjusted-subtrees t)

  (org-todo-keywords '((sequence "TODO(t)" "HOLD(h!)" "WIP(i!)" "WAIT(w!)" "|" "DONE(d!)" "CANCELLED(c@/!)")
                       (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f!)")))

  (org-todo-keyword-faces '(("TODO" :foreground "#7c7c75" :weight bold)
                            ("HOLD" :foreground "#feb24c" :weight bold)
                            ("WIP"  :foreground "#0098dd" :weight bold)
                            ("WAIT" :foreground "#9f7efe" :weight bold)
                            ("DONE" :foreground "#50a14f" :weight bold)
                            ("CANCELLED" :foreground "#ff6480" :weight bold)
                            ("REPORT" :foreground "magenta" :weight bold)
                            ("BUG" :foreground "red" :weight bold)
                            ("KNOWNCAUSE" :foreground "yellow" :weight bold)
                            ("FIXED" :foreground "gree" :weight bold)))

  ;; 当标题行状态发生变化时标签同步发生的变化
  ;; Moving a task to CANCELLED adds a CANCELLED tag
  ;; Moving a task to WAIT adds a WAIT tag
  ;; Moving a task to HOLD adds WAIT and HOLD tag
  ;; Moving a task to a done state removes WAIT and HOLD tags
  ;; Moving a task to TODO removes WAIT, CANCELLED, and HOLD tags
  ;; Moving a task to DONE removes WAIT, CANCELLED, and HOLD tags
  (org-todo-state-tags-triggers
   (quote (("CANCELLED" ("CANCELLED" . t))
           ("WAIT" ("WAIT" . t))
           ("HOLD" ("WAIT") ("HOLD" . t))
           (done ("WAIT") ("HOLD"))
           ("TODO" ("WAIT") ("CANCELLED") ("HOLD"))
           ("DONE" ("WAIT") ("CANCELLED") ("HOLD")))))
  (org-use-fast-todo-selection 'expert)
  (org-enforce-todo-dependencies t)
  (org-priority-faces '((?A :foreground "red")
                        (?B :foreground "orange")
                        (?C :foreground "yellow")))
  ;; 标题行全局属性设置
  (org-global-properties '(("EFFORT_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 7:00 8:00")
                           ("APPT_WARNTIME_ALL" . "0 5 10 15 20 25 30 45 60")
                           ("RISK_ALL" . "Low Medium High")
                           ("STYLE_ALL" . "habit")))
  ;; Org columns的默认格式
  (org-columns-default-format "%25ITEM %TODO %SCHEDULED %DEADLINE %3PRIORITY %TAGS %CLOCKSUM %EFFORT{:}")
  (org-closed-keep-when-no-todo t)
  (org-log-done 'time)
  (org-log-repeat 'time)
  (org-log-redeadline 'note)
  (org-log-reschedule 'note)
  (org-log-into-drawer t)
  (org-log-state-notes-insert-after-drawers nil)

  (org-refile-use-cache t)
  (org-refile-targets '((org-agenda-files . (:maxlevel . 9))))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (org-refile-allow-creating-parent-nodes 'confirm)

  (org-auto-align-tags t)
  (org-use-tag-inheritance nil)
  (org-agenda-use-tag-inheritance nil)
  (org-use-fast-tag-selection t)
  (org-fast-tag-selection-single-key t)
  (org-track-ordered-property-with-tag t)
  (org-tag-persistent-alist '(("read" . ?r)
                              ("mail" . ?m)
                              ("emacs" . ?e)
                              ("study" . ?s)
                              ("work" . ?w)))
  (org-tag-alist '((:startgroup)
                   ("crypt" . ?c)
                   ("linux" . ?l)
                   ("apple" . ?a)
                   ("noexport" . ?n)
                   ("ignore" . ?i)
                   ("toc" . ?t)
                   (:endgroup)))

  (org-archive-location "%s_archive::datetree/"))

(use-package org-contrib)

(use-package org-modern
  :hook (after-init . (lambda ()
                        (setq org-modern-hide-stars 'leading)
                        (global-org-modern-mode t)))
  :config
  (setq org-modern-star ["◉" "○" "✸" "✳" "◈" "◇" "✿" "❀" "✜"])
  (setq-default line-spacing 0.1)
  (setq org-modern-label-border 1)
  (setq org-modern-table-vertical 2)
  (setq org-modern-table-horizontal 0)
  (setq org-modern-checkbox
        '((?X . #("▢✓" 0 2 (composition ((2)))))
          (?- . #("▢–" 0 2 (composition ((2)))))
          (?\s . #("▢" 0 1 (composition ((1)))))))
  (setq org-modern-list
        '((?- . "•")
          (?+ . "◦")
          (?* . "▹")))
  (setq org-modern-block-fringer t)
  (setq org-modern-block-name nil)
  (setq org-modern-keyword nil))

(use-package org-capture
  :ensure nil
  :hook ((org-capture-mode . (lambda ()
                               (setq-local org-complete-tags-always-offer-all-agenda-tags t)))
         (rog-capture-mode . delete-other-windows))
  :custom
  (org-capture-use-agenda-date nil)
  ;; define common template
  (org-capture-templates `(("t" "Tasks" entry (file+headline "gtd.org" "Reminders")
                            "* TODO %i?"
                            :empty-lines-after 1
                            :prepend t)
                           ("n" "Notes" entry (file+headline "capture.org" "Notes")
                            "* %? %^g\n%i\n"
                            :empty-lines-after 1)
                           ;; For EWW
                           ("b" "Bookmarks" entry (file+headline "capture.org" "Bookmarks")
                            "* %:description\n\n%a%?"
                            :empty-lines 1
                            :immediate-finish t)
                           ("d" "Diary")
                           ("dt" "Today's TODO list" entry (file+olp+datetree "diary.org")
                            "* Today's TODO list [/]\n%T\n\n** TODO %?"
                            :empty-lines 1
                            :jump-to-capture t))))

(provide 'init-org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-org.el ends here
