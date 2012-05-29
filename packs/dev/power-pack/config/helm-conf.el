(live-add-pack-lib "helm")

(require 'helm-config)

(global-set-key (kbd "C-;") 'helm-mini)

(helm-mode 1)

(live-add-pack-lib "helm-git")
(require 'helm-git)
