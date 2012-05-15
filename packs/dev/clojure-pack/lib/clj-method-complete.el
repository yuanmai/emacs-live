;;; clj-method-complete.el --- Method completion for Clojure

;; Copyright (C) 2012  mst

;; Author: Mark Triggs <mark@dishevelled.net>

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

;;; Commentary:

;; Evals the form before the point and, based on reflection on the resulting
;; object, tab completes its method calls.  Choosing a method shows the
;; available method signatures for that method.

;;; Code:


(require 'paredit)
(require 'slime)
(require 'cl)


(defun clj-popup-buffer (buffer message)
  (with-current-buffer (get-buffer-create buffer)
    (erase-buffer)
    (insert "\n" message "\n\n")
    (fit-window-to-buffer (display-buffer (current-buffer)))
    (setq cursor-type nil)))


(defun clj-format-parameter-list (result buffer)
  (destructuring-bind (output value) result
    (let ((value (first (read-from-string value))))
      (when (and value
                 (not (equal value '(()))))
        (clj-popup-buffer
         buffer
         (mapconcat (lambda (arglist)
                      (format "(%s)"
                              (mapconcat 'identity arglist ", ")))
                    value
                    "\n"))))))


(defun clj-show-static-args ()
  (interactive)
  (save-excursion
    (backward-sexp 1)
    (destructuring-bind
        (class method)
        (split-string (remove-properties-from-string (thing-at-point 'symbol))
                      "/")
      (slime-eval-async
          `(swank:eval-and-grab-output
            ,(format "(try (doall (keep (fn [method]
                                            (when (and (java.lang.reflect.Modifier/isStatic (.getModifiers method))
                                                  (= (.getName method) \"%s\"))
                                             (map #(.getName %%) (.getParameterTypes method))))
                                                  (.getMethods (ns-resolve *ns* '%s))))
                             (catch Exception _ ()))"
                     method class))
        (lambda (result)
          (clj-format-parameter-list result "*Methods*"))))))


(defun clj-show-constructors ()
  (interactive)
  (save-excursion
    (backward-sexp 1)
    (let ((class (remove-properties-from-string (replace-regexp-in-string "\\.$" "" (thing-at-point 'symbol)))))
      (slime-eval-async
          `(swank:eval-and-grab-output
            ,(format "(try (doall (map (fn [constructor] (map #(.getName %%) (.getParameterTypes constructor)))
                                         (.getConstructors (ns-resolve *ns* '%s))))
                             (catch Exception _ ()))"
                     class))
        (lambda (result)
          (clj-format-parameter-list result "*Constructors*"))))))


;;; Hook into SLIME so we show a parameter list for constructors and statics
;;; after lingering for a moment
(defadvice slime-space (before slime-space-with-constructors activate)
  (mapc (lambda (entry)
          (when (looking-back (car entry))
            (lexical-let ((entry entry))
              (run-at-time 0.5 nil
                           (lambda ()
                             (when (looking-back (car entry))
                               (funcall (cdr entry))))))))
        '(("\\.[\t ]*" . clj-show-constructors)
          ("/[a-zA-Z]+ *" . clj-show-static-args))))


(defun clj-insert-method-call ()
  (interactive)
  (let ((expr (slime-last-expression)))
    (slime-eval-async
        `(swank:eval-and-grab-output
          ,(format
            "(doall (map (fn [[method sigs]] (conj sigs method))
                         (apply merge-with concat
                                (map (fn [m] {(str \".\" (.getName m))
                                              (list (str m))})
                                      (.getMethods (class %s))))))"
            expr))
      (lambda (result)
        (destructuring-bind (output value) result
          (condition-case nil
              (let* ((methods (first (read-from-string value)))
                     (selected (completing-read "Method call?: "
                                                methods nil t ".")))
                (when selected
                  (backward-sexp 1)
                  (paredit-wrap-sexp 1)
                  (insert selected)
                  (insert " ")
                  (forward-sexp 1)
                  (insert " ")
                  (clj-popup-buffer "*Methods*"
                                    (mapconcat 'identity
                                               (cdr (assoc selected methods))
                                               "\n"))))
            (quit nil)))))))


(define-key clojure-mode-map (kbd "C-c m") 'clj-insert-method-call)



(provide 'clj-method-complete)
;;; clj-method-complete.el ends here
