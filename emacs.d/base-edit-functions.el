(require 'aux)                                        

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

(setq jump-forward-regexp     "\\([A-Z0-9_][^A-Z0-9_ \t]\\|[ \t][^ \t]\\|\\'\\)")
(setq jump-backward-regexp    "\\([^A-Z0-9_ \t][A-Z0-9_]\\|[ \t][^ \t]\\|\\`\\)")

(defun smart-forward-to-word ()
  "like forward to word, but does stop at the end of the line"
  (interactive "^")
  (if (= (point) (line-end-position))
      (unless (= (point) (buffer-size))
        (progn
          (next-line)
          (beginning-of-line)))
    (let ((pos (point))
          (line (line-number-at-pos)))
      (search-forward-regexp jump-forward-regexp)
      (unless (= (point) (buffer-size))
        (backward-char))
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
      (unless (= (point) 1)
        (progn
          (previous-line)
          (end-of-line)))
    (let ((pos (point))
          (line (line-number-at-pos)))
      (search-backward-regexp jump-backward-regexp)
      (unless (= (point) 1)
        (forward-char))
      (if (not (equal line (line-number-at-pos)))
          (progn
            (goto-char pos)
            (beginning-of-line)
            )
        )
      )
    )
)

(defun smart-delete-word-backward ()
  ""
  (interactive)
  (let ((pos (point)))
    (smart-backward-to-word)
    (delete-region pos (point))))
  
(defun smart-delete-word-forward ()
  ""
  (interactive)
  (let ((pos (point)))
    (smart-forward-to-word)
    (delete-region pos (point))))

;;; buffer manipulation

(defun set-buffer-if-not-nil (buffer)
  (if buffer 
      (set-window-buffer
       (selected-window)
       (buffer-name buffer))))

(defun cycle-buffers-next ()
  "switching to the next buffer, burying previous one"
  (interactive)
  (set-buffer-if-not-nil (aux-next-cycle-element (buffer-list) (current-buffer))))

(defun cycle-buffers-prev()
  "switching to the prev buffer, burying previous one"
  (interactive)
  (set-buffer-if-not-nil (aux-next-cycle-element (reverse (buffer-list)) (current-buffer))))

;;; kbd macro

(setq recording-kbd-macro nil)
(defun trigger-kbd-macro ()
  (interactive)
  (if recording-kbd-macro
      (progn
        (end-kbd-macro)
        (setq recording-kbd-macro nil))
    (progn
        (start-kbd-macro nil)
        (setq recording-kbd-macro t))))
