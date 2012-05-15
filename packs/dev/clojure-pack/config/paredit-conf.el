(eval-after-load 'paredit
  ;; need a binding that works in the terminal
  '(progn
     (define-key paredit-mode-map (kbd "M-)") 'paredit-forward-slurp-sexp)

      (dolist (binding (list (kbd "C-j")))
       (define-key paredit-mode-map binding nil))))

(require 'paredit)
