(live-add-pack-lib "slime")
(require 'slime)
(require 'clj-imports)
(require 'clj-method-complete)
(slime-setup '(slime-repl slime-scratch slime-editing-commands))
(setq slime-protocol-version 'ignore)

(define-key slime-mode-map (kbd "C-j") 'slime-eval-print-last-expression)

(add-hook 'slime-repl-mode-hook 'enable-paredit-mode)

(add-hook 'slime-repl-mode-hook (lambda ()
                                  (define-key slime-repl-mode-map
                                    (kbd "DEL") 'paredit-backward-delete)
                                  (define-key slime-repl-mode-map
                                    (kbd "{") 'paredit-open-curly)
                                  (define-key slime-repl-mode-map
                                    (kbd "}") 'paredit-close-curly)
                                  (modify-syntax-entry ?\{ "(}")
                                  (modify-syntax-entry ?\} "){")
                                  (modify-syntax-entry ?\[ "(]")
                                  (modify-syntax-entry ?\] ")[")))

(defun clojure-reset-namespace ()
  "Reloads the current Clojure namespace by first removing it and
then re-evaluating the slime buffer. Use this to remove old
symbol definitions and reset the namespace to contain only what
is defined in your current Emacs buffer."
  (interactive)
  (save-buffer)
  (slime-interactive-eval (concat "(remove-ns '" (slime-current-package) ")"))
  (slime-compile-and-load-file))

;;why isn't this working?
;; (eval-after-load 'slime-repl-mode
;;   '(add-to-list (make-local-variable 'paredit-space-for-delimiter-predicates)
;;                 (lambda (_ _) nil)))
