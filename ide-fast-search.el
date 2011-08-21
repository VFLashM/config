(setq last-search-string "")

(defun init-fast-search ()
  "init fast search"
  (if mark-active
      (setq last-search-string (buffer-substring (region-beginning) (region-end)))
    (setq last-search-string "")
  )
  (deactivate-mark)
)

(defun fast-search-forward ()
  "init fast search forward"
  (interactive)
  (init-fast-search)
  (fast-search-next)
)

(defun fast-search-backward ()
  "init fast search backward"
  (interactive)
  (init-fast-search)
  (fast-search-prev)
)

(defun fast-search-next ()
  "do fast search forward"
  (interactive)
  (deactivate-mark)
  (if (> (length last-search-string) 0)
      (let ()
	(search-forward last-search-string nil t)
	(push-mark (- (point) (length last-search-string)))
	)
    )
)

(defun fast-search-prev ()
  "do fast search backward"
  (interactive)
  (deactivate-mark)
  (if (> (length last-search-string) 0)
      (let ()
	(search-backward last-search-string nil t)
	(push-mark (+ (point) (length last-search-string)))
	;(transient-mark-mode t)
	)
    )
)