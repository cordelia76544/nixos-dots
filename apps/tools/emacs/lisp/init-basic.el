;;; init-basic.el --- basic behavior -*- lexical-binding: t; -*-

(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq ring-bell-function 'ignore)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default fill-column 100)

(column-number-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)

(setq use-short-answers t)
(setq confirm-kill-emacs 'y-or-n-p)

(setq scroll-conservatively 101)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)

;; TTY 下全局行号可能比较慢，只在 GUI 默认开启
(when (display-graphic-p)
  (global-display-line-numbers-mode 1))

(provide 'init-basic)