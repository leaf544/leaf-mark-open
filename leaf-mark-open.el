;; --- * leaf-mark-open.el * ---

;; Created: 7/7/2022

(require 'f)

(defvar mark-file (concat user-emacs-directory "marked")
  "Where marked files are stored.")

(defun get-living-buffers ()
  "Return a list of current file buffers"
  (seq-filter
   (lambda (b)
     (buffer-file-name b))
   (buffer-list)))

(defun get-window-buffers ()
  "Return a list of current window buffers"
  (seq-filter
   (lambda (elt)
     (memq elt (mapcar 'window-buffer (window-list))))
   (buffer-list)))

(defun write-to-marked-file (obj append)
  "Write OBJ to `mark-file', if APPEND is t then append OBJ to
`mark-file', if APPEND is nil then erase `mark-file' contents and
write to `mark-file'"
  (write-region obj nil mark-file append))

(defun retrieve-marked (marked)
  (mapc #'find-file marked)
  (write-to-marked-file "" nil)) 

(defun leaf/mark-buffer-file (obj)
  "Mark the current file buffer"
  (interactive "i")
  (write-to-marked-file (concat (buffer-file-name obj) "\n") t)
  (and current-prefix-arg (restart-emacs)))

(defun leaf/mark-directory (obj)
  "Mark the current `default-directory'"
  (interactive "i")
  (write-to-marked-file (concat default-directory "\n") t)
  (and current-prefix-arg (restart-emacs)))

(defun leaf/mark-living-buffers (obj)
  "Mark all living buffers, this function uses `get-living-buffers'"
  (interactive "i")
  (mapc #'leaf/mark-buffer-file (get-living-buffers))
  (and current-prefix-arg (restart-emacs)))

(defun leaf/mark-window-buffers (obj)
  "Mark all living window buffers, this function uses `get-window-buffers'"
  (interactive "i")
  (mapc #'leaf/mark-buffer-file (get-window-buffers))
  (and current-prefix-arg (restart-emacs)))

(defun mark-open-procedure-default-function ()
  "Default function for `mark-open-procedure'"
  (let ((marked
	 (split-string (f-read-text mark-file) "\n")))
    (and marked
	 (retrieve-marked marked))))

(defvar mark-open-procedure
  #'mark-open-procedure-default-function
  "Standard instructions for retrieving marked files")

(defalias 'mf #'leaf/mark-buffer-file)
(defalias 'md #'leaf/mark-directory)
(defalias 'mlb #'leaf/mark-living-buffers)
(defalias 'mw #'leaf/mark-window-buffers)

(provide 'leaf-mark-open)
