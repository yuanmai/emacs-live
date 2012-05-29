(live-add-pack-lib "expectations-mode")
(require 'clojure-mode)
(require 'clojure-test-mode)
(require 'expectations-mode)

(add-hook 'clojure-mode-hook 'expectations-mode)
