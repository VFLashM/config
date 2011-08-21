(defun yank-replace-region ()
  "Yank and repalce current region"
  (interactive)
  (if mark-active (delete-region (region-beginning) (region-end)))
  (yank))
