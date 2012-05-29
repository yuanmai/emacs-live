(require 'dircolors)
(require 'smooth-scrolling)
(require 'buffer-move)

(live-load-config-file "backup-dir-conf.el")
(live-load-config-file "util-fns.el")
(live-load-config-file "built-in.el")
(live-load-config-file "cosmetic.el")
(live-load-config-file "ido-conf.el")
(live-load-config-file "smex-conf.el")
(live-load-config-file "tramp-conf.el")
(live-load-config-file "mouse-conf.el")
(live-load-config-file "ibuffer-git-conf.el")
(live-load-config-file "key-chord-conf.el")
(live-load-config-file "window-number-conf.el")
(live-load-config-file "recentf-conf.el")
(live-load-config-file "magit-conf.el")

(when (eq system-type 'darwin)
  (live-load-config-file "osx.el"))
