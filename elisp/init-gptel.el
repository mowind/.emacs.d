;;; init-gptel.el KIMI configurations. -*- lexical-binding: t -*-
;;;
;;; Commentary:

;;; Code:

(use-package gptel
  :ensure t
  :config
  (setq gptel-model "moonshot-v1-8k")
  (setq gptel-default-mode 'org-mode)
  (setq gptel-backend
        (gptel-make-openai "MoonshotAI"
          :key 'gptel-api-key
          :models '("moonshot-v1-8k"
                    "moonshot-v1-32k"
                    "moonshot-v1-128k")
          :host "api.moonshot.cn"))
  (setq gptel-use-curl nil))

(defun gptel+ ()
  (interactive)
  (let ((locale-coding-system 'utf-8))
    (call-interactively #'gptel)))

(provide 'init-gptel)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-gptel.el ends here
