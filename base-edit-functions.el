(defun yank-replace-region ()
  "Yank and repalce current region"
  (interactive)
  (if mark-active (delete-region (region-beginning) (region-end)))
  (yank))


;; (defun isearch-region-forward ()
;;   "Search current region forward"
;;   (interactive)
;;   (if mark-active 
;;       (let ()
;;         (setq isearch-string "a")
;; ;        (kill-ring-save (region-beginning) (region-end))
;;         (isearch-forward)
;;         (isearch-yank-string "abc")
;;         (isearch-search-and-update)
;; ;        (yank)
;;         )
;;     (isearch-forward))
;;     ))