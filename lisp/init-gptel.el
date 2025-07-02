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
  ;;(setq gptel-default-mode 'org-mode)
  (gptel-make-deepseek "DeepSeek"
    :stream t
    :key #'gptel-api-key
    :models '(deepseek-chat
              deepseek-r1))
  (gptel-make-openai "Volces-DeepSeek"
    :host "ark.cn-beijing.volces.com/api/v3"
    :endpoint "/chat/completions"
    :stream t
    :key #'gptel-api-key             ;can be a function that returns the key
    :models '(ep-20250214105538-4ht6q))
  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :key #'gptel-api-key
    :models '(deepseek/deepseek-chat
              deepseek/deepseek-r1
              deepseek/deepseek-chat:free
              deepseek/deepseek-r1:free
              deepseek/deepseek-chat-v3-0324
              qwen/qwen-turbo
              qwen/qwen-plus
              qwen/qwen-max
              openai/chatgpt-4o-latest
              openai/o1
              openai/o3-mini-high
              anthropic/claude-3.7-sonnect:thinking
              anthropic/claude-3.7-sonnect
              anthropic/claude-3-opus
              google/gemini-2.0-pro-exp-02-05:free
              google/gemini-2.0-flash-thinking-exp:free
              google/gemini-2.5-pro-exp-03-25:free
              google/gemini-2.0-flash-001)
    :stream t))

(use-package gptel-aibo
  :after (gptel)
  :straight '(gptel-aibo
              :type git
              :host github
              :repo "dolmens/gptel-aibo")
  :config
  ;;(define-key gptel-aibo-mode-map
  ;;  (kbd "C-c /") #'gptel-aibo-apply-last-suggestions)

  ;;  (define-key gptel-aibo-complete-mode-map
  ;;  (kbd "C-c i") #'gptel-aibo-complete-at-point)
  (add-hook 'prog-mode-hook #'gptel-aibo-complete-mode))

(provide 'init-gptel)
;;; init-gptel.el ends here
