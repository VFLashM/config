(setq package-list '(yasnippet
                     lua-mode
                     flycheck
                     cl
                     cl-lib
                     ;pymacs
                     auto-complete
                     popup
                     markdown-mode
                     python-environment
                     jedi
		     magit
                     f))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(setq config-dir (file-name-directory load-file-name))

;(add-to-list 'load-path config-dir)
(add-to-list 'load-path (concat config-dir "tomorrow-theme"))

(load-file (concat config-dir "tomorrow-theme/tomorrow-night-eighties-theme.el"))
(load-file (concat config-dir "config.el"))

(load-file (concat config-dir "auxfun.el"))
(load-file (concat config-dir "fs.el"))
(load-file (concat config-dir "base-edit-functions.el"))

(load-file (concat config-dir "ide-functions.el"))
(load-file (concat config-dir "ide-fast-search.el"))

(load-file (concat config-dir "keybindings.el"))

(load-file (concat config-dir "rust-mode.el"))

(add-hook 'after-init-hook 'setup-ide)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
