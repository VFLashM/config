(require 'misc) ; for forward-to-word backward-to-word

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

(defun smart-forward-to-word ()
  "like forward to word, but does stop at the end of the line"
  (interactive)
  (let ((p (point))
	(line (what-line)))
	
	(forward-to-word 1)
	(if (not (equal line (what-line)))
	    (progn 
	      (goto-char p)
	      (smart-end-of-line)
	      )
	  )
	)
)

(defun smart-backward-to-word ()
  "like forward to word, but does stop at the beginning of the line"
  (interactive)
  (let ((p (point))
	(line (what-line)))
	
	(backward-word 1)
	(if (not (equal line (what-line)))
	    (progn 
	      (goto-char p)
	      (smart-beginning-of-line)
	      )
	  )
	)
)
