;; init-window.el --- Initialize window configurations.
;;
;; Author: Vincent Zhang <seagle0128@gmail.com>
;; Version: 2.0.0
;; URL: https://github.com/seagle0128/.emacs.d
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;             Window configurations.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

;; Directional window-selection routines
(use-package windmove
  :defer t
  :init (add-hook 'window-setup-hook 'windmove-default-keybindings))

;; Restore old window configurations
(use-package winner
  :defer t
  :init (add-hook 'window-setup-hook 'winner-mode))

;; Quickly switch windows
(use-package ace-window
  :defer t
  :bind ("C-x o" . ace-window))

;; Numbered window shortcuts
(use-package window-numbering
  :defer t
  :init (add-hook 'after-init-hook 'window-numbering-mode))

;; Zoom window like tmux
(use-package zoom-window
  :defer t
  :bind ("C-x C-z" . zoom-window-zoom)
  :init (setq zoom-window-mode-line-color "DarkGreen"))

;; Popup Window Manager
(use-package popwin
  :defer t
  :commands popwin-mode
  :init (add-hook 'after-init-hook 'popwin-mode)
  :config (bind-key "C-z" popwin:keymap))

;; Easy window config switching
(use-package eyebrowse
  :defer t
  :init (add-hook 'after-init-hook 'eyebrowse-mode))

(provide 'init-window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-window.el ends here
