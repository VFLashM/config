; terminal config
(setq inhibit-startup-message t)
(set-language-environment 'UTF-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

; tabs
(setq-default indent-tabs-mode nil)
(setq global-tab-width 4)
(setq-default tab-width global-tab-width)
(setq lua-indent-level global-tab-width)
(setq c-basic-offset global-tab-width)

; lang
(define-coding-system-alias 'windows-1251 'cp1251)
(prefer-coding-system 'cp866)
(prefer-coding-system 'koi8-r-unix)
(prefer-coding-system 'windows-1251-dos)
(prefer-coding-system 'utf-8-unix)
(setq default-input-method 'russian-computer)

; misc
(setq ring-bell-function 'ignore)
(delete-selection-mode 1)
(show-paren-mode t)
(mouse-wheel-mode 1)
(setq scroll-margin 10)                       ;; scroll
(setq scroll-conservatively 50)               ;; smooth scroll
(setq scroll-perspective-screen-position 't)

; gui
(setq-default line-spacing 5)
(setq graphics-init-done nil)
(defun setup-frame (&optional frame)
  (interactive)
  (if (and (not graphics-init-done) (display-graphic-p frame))
      (progn
        (set-frame-font "DejaVu Sans Mono-10")
        (set-face-attribute 'default nil :font "DejaVu Sans Mono-10")
        (set-face-attribute 'default nil :height 95)
        (setq graphics-init-done t))))
;(add-hook 'after-make-frame-functions 'setup-frame)
(setup-frame)
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq tags-revert-without-query t)

(setq auto-mode-alist (cons '("\\.h$" . c++-mode) auto-mode-alist))
;(setq auto-mode-alist (cons '("\\.c$" . c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.mm$" . objc-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("^CMakeLists.txt$" . sh-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.SConscript$" . python-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.SConstruct$" . python-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\SConstruct$" . python-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.prc$" . sql-mode) auto-mode-alist))

(setq w32-get-true-file-attributes nil)
(setq diff-switches "-u")

(setq flycheck-highlighting-mode 'lines)
(global-flycheck-mode)
(if (not (eq system-type 'windows-nt))
    (progn
      (setq-default flycheck-disabled-checkers '(python-flake8)) ; disable flake8, use pylint instead
      (set-face-attribute 'flycheck-error nil :underline "red")
      (set-face-attribute 'flycheck-warning nil :underline "orange")))

(yas-global-mode 1)
(global-company-mode)

(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'racer-mode-hook 'eldoc-mode)
(add-hook 'python-mode-hook 'eldoc-mode)
(add-hook 'python-mode-hook
          (lambda ()
            (jedi:setup)

            (setq yas/indent-line 'fixed)
            (define-key yas-minor-mode-map (kbd "<tab>") nil)
            (define-key yas-minor-mode-map (kbd "TAB") nil)
            (define-key yas-minor-mode-map (kbd "C-`") 'yas-expand)
            
            (local-set-key (kbd "<C-return>") 'jedi:goto-definition)
            ))
