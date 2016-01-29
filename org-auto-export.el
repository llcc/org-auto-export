;;; org-auto-export.el --- automatically and asynchronously export org to pdf by ox-latex

;; Copyright (C) 2016 by Zhe Lei.
;;
;; Author: Zhe Lei
;; Version: 0.1
;; Package-Version: 20160129
;; Package-Requires: ((org "8.3.3"))
;;
;; This file is not part of GNU emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;;; Code:

(require 'org)
(require 'ox-latex)

(defvar-local org-auto-export-interval 600)

(defvar-local org-auto-export-timer nil)

;;;###autoload
(define-minor-mode org-auto-export-mode
  "Minor mode to export current org file automatically."
  :init-value nil
  :global t
  :variable org-auto-export-mode
  :lighter " AE"
  :group 'org
  (if (and (derived-mode-p 'org-mode) org-auto-export-mode)
      (setq org-auto-export-timer
            (run-at-time nil org-auto-export-interval
                         (lambda () (interactive)
                           (save-buffer)
                           (org-latex-export-to-pdf t))))
    (when org-auto-export-timer
      (cancel-timer org-auto-export-timer)
      (setq org-auto-export-timer nil)
      (user-error "Org auto export mode off!")))
  (when (and (called-interactively-p 'interactive)
             org-auto-export-mode)
    (run-with-idle-timer 0 nil 'message
			 (format
			  "Org file exported every %s sec."
			  org-auto-export-interval))))

(provide 'org-auto-export)
;;; org-auto-export.el ends here
