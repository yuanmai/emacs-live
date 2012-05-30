(live-add-pack-lib "color-theme")
(require 'color-theme)

(global-hl-line-mode 1)
(set-face-background 'hl-line "#333333")

;; use blackbored colour theme
(load-file (concat (live-pack-lib-dir) "cyberpunk.el"))
(load-file (concat (live-pack-lib-dir) "gandalf.el"))
(load-file (concat (live-pack-lib-dir) "zenburn.el"))

(color-theme-zenburn)

(set-cursor-color "yellow")

(set-face-attribute 'default nil :height 145)
(set-face-attribute 'default nil :family "Monaco")
