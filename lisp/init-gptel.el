;;; init-gptel.el deepseek configurations. -*- lexical-binding: t -*-
;;;
;;; Commentary:

;;; Code:

(use-package gptel
  :straight '(gptel
              :type git
              :host github
              :repo "karthink/gptel")
  :config
  (setq gptel-default-mode 'org-mode)
  (setq gptel-model   'ep-20250213152151-qtssm
        gptel-backend
        (gptel-make-openai "Volces-DeepSeek"     ;Any name you want
          :host "ark.cn-beijing.volces.com/api/v3"
          :endpoint "/chat/completions"
          :stream t
          :key 'gptel-api-key             ;can be a function that returns the key
          :models '(ep-20250213152151-qtssm))))
;;(setq gptel-model   'deepseek-chat
;;      gptel-backend
;;      (gptel-make-openai "DeepSeek"     ;Any name you want
;;        :host "api.deepseek.com"
;;        :endpoint "/chat/completions"
;;        :stream t
;;        :key 'gptel-api-key             ;can be a function that returns the key
;;        :models '(deepseek-chat))))

(defun gptel+ ()
  (interactive)
  (let ((locale-coding-system 'utf-8))
    (call-interactively #'gptel)))

(provide 'init-gptel)
;;; init-gptel.el ends here
