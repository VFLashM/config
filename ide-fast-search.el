(setq last-search-string "")

(defun word-under-cursor ()
  (let ((pos (point))
	min
	max)
    (search-backward-regexp "[^A-Za-z_]")
    (setq min (+ (point) 1))
    (goto-char pos)
    (search-forward-regexp "[^A-Za-z_]")
    (setq max (- (point) 1))
    (goto-char pos)
    (buffer-substring min max)
    )
  )

(defun mark-search-string ()
  (push-mark (- (point) (length last-search-string)))
  (activate-mark)
  (setq transient-mark-mode (only . t))
  )

(defun init-fast-search ()
  "init fast search"
  (if mark-active
      (setq last-search-string (buffer-substring (region-beginning) (region-end)))
    (setq last-search-string (word-under-cursor))
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
  (if (> (length last-search-string) 0)
      (progn
	(search-forward last-search-string nil t)
	(mark-search-string)
	)
    )
)

(defun fast-search-prev ()
  "do fast search backward"
  (interactive)
  (deactivate-mark)
  (if (> (length last-search-string) 0)
      (progn
	(backward-char)
	(let ((pos (point)))
	  (search-backward last-search-string nil t)
	  (if (= pos (point))
	      (forward-char)
	      (forward-char (length last-search-string))
	      )
	  )
	(mark-search-string)
	)
    )
)