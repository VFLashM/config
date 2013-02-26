(setq config-dir (file-name-directory load-file-name))

(add-to-list 'load-path config-dir)
(add-to-list 'load-path (concat config-dir "ac"))
(add-to-list 'load-path (concat config-dir "yasnippet"))

(load-file (concat config-dir "tomorrow-night-colorful-theme.el"))
(load-file (concat config-dir "config.el"))

(load-file (concat config-dir "base-edit-functions.el"))

(load-file (concat config-dir "ide-projects.el"))
(load-file (concat config-dir "ide-functions.el"))
(load-file (concat config-dir "ide-fast-search.el"))
(load-file (concat config-dir "ide-search-in-project.el"))

(load-file (concat config-dir "keybindings.el"))
