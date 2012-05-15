(live-add-pack-lib "clojure-mode")

(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("(\\(fn\\)[\[[:space:]]"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "λ")
                               nil))))))

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\)("
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "ƒ")
                               nil))))))

(eval-after-load 'clojure-mode
  '(font-lock-add-keywords
    'clojure-mode `(("\\(#\\){"
                     (0 (progn (compose-region (match-beginning 1)
                                               (match-end 1) "∈")
                               nil))))))

(eval-after-load 'find-file-in-project
  '(add-to-list 'ffip-patterns "*.clj"))

(require 'clojure-mode)

;;command to align let statements
;;To use: M-x align-cljlet
(live-add-pack-lib "align-cljlet")
(require 'align-cljlet)

;;Treat hyphens as a word character when transposing words
(defvar clojure-mode-with-hyphens-as-word-sep-syntax-table
  (let ((st (make-syntax-table clojure-mode-syntax-table)))
    (modify-syntax-entry ?- "w" st)
    st))

(defun transpose-words-with-hyphens (arg)
  "Treat hyphens as a word character when transposing words"
  (interactive "*p")
  (with-syntax-table clojure-mode-with-hyphens-as-word-sep-syntax-table
    (transpose-words arg)))

(defun define-function ()
  (interactive)
  (let ((name (symbol-at-point)))
    (backward-paragraph)
    (insert "\n(defn " (symbol-name name) "\n [])\n" )
    (backward-char 3)))

(defun jsj-clojure-example (name)
  (interactive "sFunction (ex. clojure.set/join): ")
  (browse-url (concat "http://clojuredocs.org/clojure_core/" name "#examples")))

(define-key clojure-mode-map (kbd "M-t") 'transpose-words-with-hyphens)
(define-key clojure-mode-map (kbd "C-c f") 'define-function)
(define-key clojure-mode-map (kbd "C-c d") 'jsj-clojure-example)

(setq auto-mode-alist (append '(("\\.cljs$" . clojure-mode))
                              auto-mode-alist))
