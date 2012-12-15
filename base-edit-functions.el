;(require 'misc) ; for forward-to-word backward-to-word

;; (defun yank-replace-region ()
;;   "Yank and repalce current region"
;;   (interactive)
;;   (if mark-active (delete-region (region-beginning) (region-end)))
;;   (yank))

(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive) ; Use (interactive "^") in Emacs 23 to make shift-select work
  (let ((oldpos (point)))
    
    (back-to-indentation)
    (if (or (= oldpos (point)) (> (point) oldpos))
         (beginning-of-line)))
  )

(defun smart-end-of-line ()
  "??"
  (interactive) ; Use (interactive "^") in Emacs 23 to make shift-select work
  (let ((oldpos (point)))
         (end-of-line))
  )

(setq jump-forward-regexp     "\\([A-Z0-9_][^A-Z0-9_ \t]\\|[ \t][^ \t]\\)")
(setq jump-backward-regexp    "\\([^A-Z0-9_ \t][A-Z0-9_]\\|[ \t][^ \t]\\)")

(defun smart-forward-to-word ()
  "like forward to word, but does stop at the end of the line"
  (interactive "^")
  (if (= (point) (line-end-position))
      (progn
	(next-line)
	(beginning-of-line))
    (let ((pos (point))
	  (line (line-number-at-pos)))
      (search-forward-regexp jump-forward-regexp)
      (backward-char)
      (if (not (equal line (line-number-at-pos)))
	  (progn
	    (goto-char pos)
	    (end-of-line)
	    )
	  )
      )
    )
)

(defun smart-backward-to-word ()
  "like forward to word, but does stop at the beginning of the line"
  (interactive "^")
  (if (= (point) (line-beginning-position))
      (progn
	(previous-line)
	(end-of-line))
    (let ((pos (point))
	  (line (line-number-at-pos)))
      (search-backward-regexp jump-backward-regexp)
      (forward-char)
      (if (not (equal line (line-number-at-pos)))
	  (progn
	    (goto-char pos)
	    (beginning-of-line)
	    )
	  )
      )
    )
)

(defun select-first-file-buffer (list)
  (if list
      (progn
	(if (buffer-file-name (car list))
	    (car list)
	  (select-first-file-buffer (cdr list))
	  )
	)
    )
  )

(defun shift-list (list)
  (append (cdr list) (cons (car list) '()))
  )

(defun select-next-file-buffer (list)
  (if (equal (current-buffer) (car list))
      (select-first-file-buffer 
        (shift-list list)
       )
    (select-next-file-buffer (shift-list list))
    )
  )

(defun set-buffer-if-not-nil (buffer)
  (if buffer 
      (set-window-buffer (selected-window) (buffer-name buffer)))
  )

(defun cycle-buffers-next ()
  "switching to the next buffer, burying previous one"
  (interactive)
  (set-buffer-if-not-nil (select-next-file-buffer (buffer-list)))
  )

(defun cycle-buffers-prev()
  "switching to the prev buffer, burying previous one"
  (interactive)
  (set-buffer-if-not-nil (select-next-file-buffer (reverse (buffer-list))))
  )

(defun smart-delete-word-backward ()
  ""
  (interactive)
  (let (
	(pos (point))
	)
    (smart-backward-to-word)
    (delete-region pos (point))
    )
  )
  
(defun smart-delete-word-forward ()
  ""
  (interactive)
  (let (
	(pos (point))
	)
    (smart-forward-to-word)
    (delete-region pos (point))
    )
  )
  
