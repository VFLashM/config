(setq config-dir (file-name-directory load-file-name))

(load-file (concat config-dir "config.el"))

(load-file (concat config-dir "base-edit-functions.el"))

(load-file (concat config-dir "ide-functions.el"))
(load-file (concat config-dir "ide-fast-search.el"))
(load-file (concat config-dir "ide-search-in-project.el"))

(load-file (concat config-dir "keybindings.el"))
