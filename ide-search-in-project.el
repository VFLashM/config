(defun search-in-project (regexp)
  "Search in files in project"
  (interactive
   (progn
     (list (read-shell-command "Search in project: "
                                   "" 'regexp)))
   )
  (cd project-path)
  (compilation-start
   (concat "find . -type f "
           "-not -iname '*.obj' -and "
           "-not -iname '*.o' -and "
           "-not -iname '*.pdb' -and "
           "-not -iname '*.exe' -and "
           "-not -iname '.*' -and "
           "-not -iname '*~' -and "
           "-not -iname '#*#' -and "
           "-not -ipath '*/.*/*' -and "
           "-not -iname 'BROWSE' "
           "-not -iname 'TAGS' "
           "-exec grep -n -H " regexp " {} \\;") 'grep-mode
   )
  )
