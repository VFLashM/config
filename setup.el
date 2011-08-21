(setq config-dir "c:/Programming/EmacsConfig/")

;;(load-file (concat config-dir "cedet-1.0/common/cedet.el"))
;;(global-ede-mode t)

(load-file (concat config-dir "config.el"))

(load-file (concat config-dir "base-edit-functions.el"))

(load-file (concat config-dir "ide-functions.el"))
(load-file (concat config-dir "ide-fast-search.el"))

(load-file (concat config-dir "keybindings.el"))
