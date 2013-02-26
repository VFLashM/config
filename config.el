(setq inhibit-startup-message t)
(set-language-environment 'UTF-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(setq-default indent-tabs-mode nil)
(setq-default tab-width global-tab-width)
(setq lua-indent-level global-tab-width)
(setq c-basic-offset global-tab-width)

(show-paren-mode t)
(define-coding-system-alias 'windows-1251 'cp1251)

(prefer-coding-system 'cp866)
(prefer-coding-system 'koi8-r-unix)
(prefer-coding-system 'windows-1251-dos)
(prefer-coding-system 'utf-8-unix)
(setq default-input-method 'russian-computer)

(mouse-wheel-mode 1)
(setq scroll-margin 10)                       ;; scroll
(setq scroll-conservatively 50)               ;; smooth scroll
(setq scroll-perspective-screen-position 't)

(set-face-attribute 'default nil :font "DejaVu Sans Mono-10")
;;(set-frame-font "-xos4-terminus-medium-r-normal--20-200-72-72-c-100-iso10646-1")
;;(set-frame-font "-*-terminus-medium-r-normal--20-*-*-*-c-*-*-*")

(menu-bar-mode -1)
(tool-bar-mode -1)

(setq tags-revert-without-query t)

(setq auto-mode-alist (cons '("\\.h$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.mm$" . objc-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("^CMakeLists.txt$" . sh-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.SConscript$" . python-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.SConstruct$" . python-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\SConstruct$" . python-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.bobj$" . xml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cobj$" . xml-mode) auto-mode-alist))

;(set-language-environment "Japanese")
;(load-library "anthy")
;(setq default-input-method "japanese-anthy")

;(autoload 'uim-mode "uim" nil t)
;(setq uim-default-im-engine "anthy")
;(global-set-key "\C-o" 'uim-mode)

(setq w32-get-true-file-attributes nil)
