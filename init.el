;;; init.el --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  pxel8063

;; Author: pxel8063 <pxel8063@gmail.com>
;; Version:    0.0.1
;; Keywords:   lisp
;; Package-Requires: ((emacs "27.1") (leaf "4.5.5") (leaf-keywords "1.1.0"))

;; URL: https://github.com/pxel8063/emacs.d

;; This program is free software: you can redistribute it and/or modify
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

;; My init.el.

;;; Code:

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'leaf)
(straight-use-package 'leaf-keywords)
(leaf-keywords-init)

(leaf hydra :straight t)
(leaf el-get :straight t)  ;; '(el-get-git-shallow-clone t)
(leaf blackout :straight t)

;; ここにいっぱい設定を書く

(leaf leaf
  :config
  (leaf leaf-convert :straight t)
  (leaf leaf-tree
    :straight t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

(leaf macrostep
  :straight t
  :bind (("C-c e" . macrostep-expand)))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(prefer-coding-system 'utf-8)

(leaf cus-starup
  :custom
  '(
    (js-indent-level . 2)
    (tool-bar-mode          . nil)
    (menu-bar-mode          . nil)
    (truncate-lines         . t)
    (fill-column . 79)
    (inhibit-startup-screen . t)
    (visible-bell . t)
    (ring-bell-function . 'ignore)
    (desktop-save-mode        . nil)
    (save-abbrevs . nil)
    (mail-host-address . "gmail.com")
    (send-mail-function . (quote sendmail-send-it))
    (safe-local-variable-values . '((eval setq skk-kutouten-type 'jp)))))

(leaf recentf
  :global-minor-mode t)

(leaf vertico
  :doc "VERTical Interactive COmpletion"
  :req "emacs-27.1"
  :tag "emacs>=27.1"
  :url "https://github.com/minad/vertico"
  :added "2022-06-04"
  :emacs>= 27.1
  :straight t
  :global-minor-mode vertico-mode savehist-mode)

(leaf orderless
  :doc "Completion style for matching regexps in any order"
  :req "emacs-26.1"
  :tag "extensions" "emacs>=26.1"
  :url "https://github.com/oantolin/orderless"
  :added "2022-06-04"
  :emacs>= 26.1
  :straight t
  :custom ((completion-styles . '(orderless basic))
           (completion-category-defaults . nil)
           (completion-category-overrides '((file (styles partial-completion))))))

(leaf marginalia
  :straight t
  ;; Either bind `marginalia-cycle' globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         (:minibuffer-local-map
         ("M-A" . marginalia-cycle)))

  ;; The :init configuration is always executed (Not lazy!)
  ;;:init
  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  :global-minor-mode marginalia-mode)

(leaf embark
  :doc "Conveniently act on minibuffer completions"
  :req "emacs-26.1"
  :tag "convenience" "emacs>=26.1"
  :url "https://github.com/oantolin/embark"
  :added "2022-06-04"
  :emacs>= 26.1
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim))
  :straight t
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(leaf consult
  :doc "Consulting completing-read"
  :req "emacs-27.1" "compat-28.1"
  :tag "emacs>=27.1"
  :url "https://github.com/minad/consult"
  :added "2022-06-04"
  :emacs>= 27.1
  :straight t
  :bind (("C-s" . consult-line)
         ;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org
         (:org-mode-map
          ("M-g o" . consult-org-heading))         ;; Alternative: consult-outline
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         (:isearch-mode-map
          ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
          ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
          ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
          ("M-s L" . consult-line-multi))          ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         (:minibuffer-local-map
          ("M-s" . consult-history)                 ;; orig. next-matching-history-element
          ("M-r" . consult-history)))               ;; orig. previous-matching-history-element

  :hook ((completion-list-mode . consult-preview-at-point-mode))
  :after org)

(leaf embark-consult
  :doc "Consult integration for Embark"
  :req "emacs-27.1" "embark-0.17" "consult-0.17"
  :tag "convenience" "emacs>=27.1"
  :url "https://github.com/oantolin/embark"
  :added "2022-06-04"
  :emacs>= 27.1
  :straight t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(leaf wgrep
  :doc "For great editting experience by embark and consult"
  :straight t)

(leaf citar
  :doc "Citation-related commands for org, latex, markdown"
  :req "emacs-27.1" "parsebib-3.0" "org-9.5" "citeproc-0.9"
  :tag "emacs>=27.1"
  :url "https://github.com/bdarcus/citar"
  :added "2022-06-04"
  :emacs>= 27.1
  :straight t
  :custom ((org-cite-global-bibliography . '("~/org/bibliography/references.bib"))
           (org-cite-insert-processor . 'citar)
           (org-cite-follow-processor . 'citar)
           (org-cite-activate-processor . 'citar)
           (citar-bibliography . '("~/org/bibliography/references.bib"))
           (citar-open-note-functions '(orb-edit-citation-note)))
  :bind (("C-c b" . citar-insert-citation)
         (:minibuffer-local-map
          ("M-b" . citar-insert-preset))))

(leaf citar-embark
  :doc "Integration citar and embark"
  :straight t
  :blackout t
  :global-minor-mode t)

(leaf ddskk
  :doc "Simple Kana to Kanji conversion program."
  :req "ccc-1.43" "cdb-20141201.754"
  :added "2020-06-16"
  :straight t
  :defvar skk-large-jisyo
  :bind (("C-x C-j" . skk-auto-fill-mode)
         ("C-x t" . skk-tutorial))
  :config
  (setq default-input-method "japanese-skk")
  (setq skk-large-jisyo "~/.emacs.d/skk/SKK-JISYO.L")
  :custom((skk-user-directory . "~/.emacs.d/skk")
          ;;(skk-jisyo-edit-user-accepts-editing . t)
          (skk-isearch-mode-enable . t)
          (skk-server-host . "localhost")
          (skk-server-portnum . 1178)
          (skk-jisyo-code . 'utf-8)
          (skk-egg-like-newline . t)
          (skk-use-auto-kuouten . t)
          (skk-use-azik . t)
          (skk-azik-keyboard-type . 'us101)
          (skk-auto-insert-paren . t)
          (skk-search-katakana . t)
          (skk-search-sagyo-henkaku . t)
          (skk-extra-jisyo-file-list .
                                     '("~/.emacs.d/skk-get-jisyo/SKK-JISYO.jinmei" "~/.emacs.d/skk-get-jisyo/SKK-JISYO.fullname"))))

(leaf yasnippet
  :doc "Yet another snippet extension for Emacs"
  :req "cl-lib-0.5"
  :tag "emulation" "convenience"
  :added "2021-07-21"
  :url "http://github.com/joaotavora/yasnippet"
  :straight t
  :global-minor-mode yas-global-mode)
(leaf yasnippet-snippets
  :doc "Collection of yasnippet snippets"
  :req "yasnippet-0.8.0"
  :tag "snippets"
  :added "2021-07-21"
  :url "https://github.com/AndreaCrotti/yasnippet-snippets"
  :straight t
  :after yasnippet)

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "dash-20210826" "git-commit-20211004" "magit-section-20211004" "transient-20210920" "with-editor-20211001"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :added "2022-01-01"
  :url "https://github.com/magit/magit"
  :emacs>= 25.1
  :straight t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch)))

(leaf flycheck
  :straight t
  :defvar web-mode-content-type
  :defun flycheck-add-mode
  :hook ((web-mode-hook . (lambda ()
                            (when (or
                                   (equal web-mode-content-type "jsx")
                                   (equal web-mode-content-type "typescript")
                                   (equal web-mode-content-type "javascript"))
                              (flycheck-add-mode 'javascript-eslint 'web-mode)))))
  :custom ((elpy-modules . (delq 'elpy-module-flymake elpy-modules))
           (flycheck-sass-compass . t)
           (flycheck-stylelintrc . "/Users/yoka/.stylelintrc.json")
           (flycheck-global-modes . '(not org-mode)))
  ;; Workaround for eslint loading slow
  ;; https://github.com/flycheck/flycheck/issues/1129#issuecomment-319600923
  :config (advice-add 'flycheck-eslint-config-exists-p :override (lambda() t))
  :global-minor-mode global-flycheck-mode)

(leaf exec-path-from-shell
  :straight t
  :defun exec-path-from-shell-initialize
  :when (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

(leaf *browse-url
  :custom
  (browse-url-browser-function . (quote browse-url-generic))
  (browse-url-generic-program . "/Applications/Firefox.app/Contents/MacOS/firefox"))

(leaf midnight
  :custom ((clean-buffer-list-delay-general . 1)))

(leaf scroll-bar-mode*
  :config
  (set-scroll-bar-mode nil))

(leaf show-paren-mode
  :custom((show-paren-style . 'mixed))
  :global-minor-mode t)

(leaf date2name
  :straight t
  :defvar date2name-datetime-regexp date2name-datetime-format
  :config
  (setq date2name-datetime-regexp
                 "^[0-9]\\{4\\}[0-1][0-9][0-3][0-9]T[0-2][0-9][0-5][0-9][0-5][0-9]")
  (setq date2name-datetime-format
                 "%Y%m%dT%H%M%S"))

(put 'narrow-to-region 'disabled nil)

(leaf regex-tool
  :straight t)

(leaf savehist  :global-minor-mode t)

(leaf super-save
  :straight t
  :global-minor-mode t
  :blackout super-save-mode
  :custom
  (auto-save-default . nil)
  (super-save-auto-save-when-idle . t)
  (super-save-idle-duration . 1)
  (super-save-exclude . '(".gpg")))

(leaf ddskk-posframe
  :doc "Show Henkan tooltip for ddskk via posframe"
  :straight t
  :global-minor-mode ddskk-posframe-mode
  :blackout ddskk-posframe-mode)

(leaf request
  :straight t)

(leaf org-roam
  :doc "A database abstraction layer for Org-mode"
  :req "emacs-26.1" "dash-2.13" "f-0.17.2" "org-9.4" "emacsql-3.0.0" "emacsql-sqlite-1.0.0" "magit-section-3.0.0"
  :tag "convenience" "roam" "org-mode" "emacs>=26.1"
  :url "https://github.com/org-roam/org-roam"
  :added "2021-12-29"
  :emacs>= 26.1
  :defvar org-roam-v2-ack org-roam-directory
  :init (setq org-roam-v2-ack t)
  :straight t
  :require org-roam-protocol magit-section
  :preface
  (defun  org-roam-ripgrep ()
    "Search only org-roam-directory."
    (interactive)
    (consult-ripgrep
    org-roam-directory))
  :custom `((org-roam-directory . ,(file-truename "~/org/RoamNotes"))
            (org-roam-completion-everywhere . t)
            (org-roam-dailies-directory . "daily/")
            (org-roam-dailies-capture-templates
             . '(("d" "default" entry
                  "* %?\n"
                  :target (file+head "%<%Y%m%d>.org"
                                     "#+title: %<%Y%m%d>\n#+filetags: :journal:\n")
                  :unnarrowed t)))
            (org-roam-capture-ref-templates
             . '(("r" "ref" plain "* ${title}\n${ref}\nEntered on %U\n${body}\n%?" :target
                  (file+head "references/${slug}.org" "#+title: ${title}\n")
                  :unnarrowed t)))
            (org-roam-capture-templates
             . '(("d" "default" plain "\n* link\n\n* reference\n%?" :target
                  (file+head "%<%Y%m%dT%H%M%S>-${slug}.org" "#+title: ${title}\n")
                  :unnarrowed t)))
            (org-roam-extract-new-file-path . "%<%Y%m%dT%H%M%S>-${slug}.org"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n k" . org-roam-ripgrep)
         (:org-mode-map
          ("C-M-i" . completion-at-point))
         ("C-c n d Y" . org-roam-dailies-capture-yesterday)
         ("C-c n d T" . org-roam-dailies-capture-tomorrow)
         ("C-c n d t" . org-roam-dailies-capture-today))
  :config
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-direction)
                 (direction . right)
                 (window-width . 0.33)
                 (window-height . fit-window-to-buffer)))
  :global-minor-mode org-roam-db-autosync-mode)

(leaf org-roam-bibtex
  :doc "Org Roam meets BibTeX"
  :req "emacs-27.2" "org-roam-2.0.0" "bibtex-completion-2.0.0" "org-ref-3.0"
  :tag "wp" "outlines" "hypermedia" "bib" "emacs>=27.2"
  :url "https://github.com/org-roam/org-roam-bibtex"
  :added "2021-12-30"
  :emacs>= 27.1
  :straight t
  :blackout t
  :defvar org-roam-capture-templates
  :custom ((orb-insert-interface . 'generic)
           (orb-roam-ref-format . 'org-cite))
  :bind (("C-c B" . orb-edit-citation-note))
  :config (add-to-list 'org-roam-capture-templates
                       '("r"
                         "bibliography reference" plain "%?"
                         :target
                         (file+head  "references/${citekey}.org" "#+title: ${title}\n")
                         :unnarrowed t))
  :global-minor-mode org-roam-bibtex-mode)

(leaf org-roam-ui
  :doc "User Interface for Org-roam"
  :req "emacs-27.1" "org-roam-2.0.0" "simple-httpd-20191103.1446" "websocket-1.13"
  :tag "outlines" "files" "emacs>=27.1"
  :url "https://github.com/org-roam/org-roam-ui"
  :added "2022-04-02"
  :emacs>= 27.1
  :straight t
  :after org-roam websocket)

(leaf org
  :mode (("\\.txt\\'" . org-mode)
         ("\\.txt_archive\\'" . org-mode)
         ("\\.org_archive\\'" . org-mode))
  :defun bw/org-add-update-ids-to-headlines-in-file
  :defun org-back-to-heading bh/find-project-task org-agenda-redo
  :defun outline-next-heading  bh/is-project-p org-get-tags
  :defun bh/skip-non-stuck-projects  bh/is-project-subtree-p  bh/is-task-p
  :defun org-is-habit-p  bh/is-subproject-p
  :defun org-up-heading-safe org-heading-components org-end-of-subtree
  :defun org-get-todo-state
  :defun org-map-entries
  :defvar org-done-keywords org-todo-keywords-1
  :defvar org-tags-match-list-sublevels org-agenda-restrict-begin
  :straight t
  :require org-habit
  :preface

  (leaf leaf-convert
    :require org-tempo)
  (leaf org-contrib
    :straight t)

  (defun bw/org-add-update-ids-to-headlines-in-file ()
    "Add ID properties to all visible headlines in the
  current file which do not already have one.  Change the IDs of
  those that already have them. See
    https://emacs.stackexchange.com/questions/26083/org-mode-function-to-duplicate-current-header-and-change-id"
    (interactive)
    (org-map-entries '(lambda () (org-id-get-create t))))

  :bind (("C-c l" . org-store-link) ;; Set global-set-key based on the Org Manual 1.3 Activation.
         ("C-c a" . org-agenda)
         ("<f12>" . org-agenda)
         ("s-=" . org-agenda)
         ("C-c c" . org-capture))
  :defun org-mobile-pull org-mobile-push org-mobile-sync-enable show-org-buffer
  :custom (
           ;;
           (org-adapt-indentation . t)
           ;; Open pdf as an internal link
           (org-file-apps . '((auto-mode . emacs)
                              (directory . emacs)
                              ("\\.mm\\'" . default)
                              ("\\.x?html?\\'" . default)
                              ("\\.pdf\\'" . emacs)))
           ;; Allow single character alphabetical bullets
           (org-list-allow-alphabetical . t)
           ;; Always org-indent-mode on
           (org-startup-indented . t)
           ;; Hide leading starts in headings
           (org-hide-leading-stars . t)
           ;; Do not honer startup options when visiting an ageda file for the first time, which is good for building agenda.
           (org-agenda-inhibit-startup . t)
           ;; Inhibit the dimming of blocked tasks for speed up agenda
           (org-agenda-dim-blocked-tasks . nil)
           ;; The following setting hides blank lines between headings which keeps folded view nice and compact.
           (org-cycle-separator-lines . 0)
           ;; Set to the name of the file where new notes will be stored
           (org-mobile-inbox-for-pull . "~/org/flagged.org")
           ;; Set to <your Dropbox root directory>/MobileOrg.
           (org-mobile-directory . "~/Dropbox/アプリ/MobileOrg")
           ;; Tags with fast selection keys
           ;; The startgroup - endgroup (@XXX) tags are mutually exclusive - selecting one removes a similar tag already on the task.
           (org-tag-persistent-alist .
                                     (quote ((:startgroup . nil)
                                             ("@errand" . ?e)
                                             ("@home" .?h)
                                             (:endgroup . nil)
                                             ("WAITING" . ?W)
                                             ("HOLD" . ?H)
                                             ("UNDONE" . ?d)
                                             ("CANCELLED" . ?C)
                                             ("FLAGGED" .??)
                                             ("NOTE" . ?n)
                                             ("weekly" . ?w)
                                             ("active" . ?v)
                                             ("feedback" . ?f))))
           (org-todo-state-tags-triggers .
                                         (quote (("CANCELLED" ("CANCELLED" . t))
                                                 ("WAITING" ("WAITING" . t))
                                                 ("HOLD" ("WAITING") ("HOLD" . t))
                                                 (done ("WAITING") ("HOLD"))
                                                 ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                                                 ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                                                 ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

           (org-todo-keywords . (quote ((sequence "TODO(t)" "PRESELECT(p)" "|" "DONE(d)")
                                        (sequence "WAITING(w/!)" "HOLD(h/!)" "|" "CANCELLED(c/!)"))))
           (org-treat-S-cursor-todo-selection-as-state-change . nil)
           ;; This allows changing todo states with S-left and S-right
           ;; skipping all of the normal processing when entering or
           ;; leaving a todo state.  This cycles through the todo states
           ;; but skips setting timestamps and entering notes which is very
           ;; convenient when all you want to do is fix up the status of an
           ;; entry.
           (org-todo-keyword-faces .
                                   (quote (("TODO" :foreground "orange" :weight bold)
                                           ("NEXT" :foreground "violet" :weight bold)
                                           ("DONE" :foreground "green" :weight bold)
                                           ("WAITING" :foreground "cyan" :weight bold)
                                           ("HOLD" :foreground "magenta" :weight bold)
                                           ("CANCELLED" :foreground "base03" :weight bold))))

           ;; Compact the block agenda view
           (org-agenda-compact-blocks . t)
           (org-agenda-skip-additional-timestamps-same-entry . nil)
           (system-time-locale . "C")
           (org-icalendar-use-scheduled . '(event-if-todo))
           (org-icalendar-store-UID . t)
           (org-agenda-skip-deadline-prewarning-if-scheduled . t)
           (org-agenda-files . (quote
                                ("~/org/draft.org"
                                 "~/org/fvp.org"
                                 "~/org/flagged.org")))
           (org-agenda-custom-commands .
                                       '(
                                         ("=" "my"
                                          ((todo "BACKLOG"
                                                 ((org-agenda-overriding-header "Backlogs")))
                                           (tags "REFILE"
                                                 ((org-agenda-overriding-header "Tasks to Refile")
                                                  (org-tags-match-list-sublevels nil)))
                                           (agenda "" nil)))))

           ;; Keep tasks with dates on the global todo lists
           (org-agenda-todo-ignore-with-date . nil)

           ;; Keep tasks with deadlines on the global todo lists
           (org-agenda-todo-ignore-deadlines . nil)

           ;; Keep tasks with scheduled dates on the global todo lists
           (org-agenda-todo-ignore-scheduled . nil)

           ;; Keep tasks with timestamps on the global todo lists
           (org-agenda-todo-ignore-timestamp . nil)

           ;; Remove completed deadline tasks from the agenda view
           (org-agenda-skip-deadline-if-done . t)

           ;; Remove completed scheduled tasks from the agenda view
           (org-agenda-skip-scheduled-if-done . t)

           ;; Remove completed items from search results
           (org-agenda-skip-timestamp-if-done . t)

           ;; Habit Display
           (org-habit-graph-column . 60)

           (org-agenda-start-on-weekday . 1)

           ;; Archive
           (org-archive-mark-done . nil)
           (org-archive-location . "%s_archive::* Archived Tasks")

           ;; org mode clock settings
           (org-deadline-warning-days . 14)
           (org-default-notes-file . "~/org/notes.org")
           (org-directory . "~/org")

           (org-log-done . (quote time))
           (org-log-into-drawer . t)
           (org-log-state-notes-insert-after-drawers . nil)

           (org-refile-targets . (quote
                                  (("~/vercelhugo/org/posts.org" :level . 1)
                                   ("~/org/admin.org" :level . 2)
                                   ("~/org/project.org" :maxlevel . 3)
                                   ("~/org/errand.org" :level . 2)
                                   ("~/org/notes.org" :level . 3)
                                   ("~/org/journal.org" :level . 1)
                                   ("~/org/study.org" :maxlevel . 2)
                                   ("~/org/startup.org" :maxlevel . 2)
                                   ("~/org/someday.org" :maxlevel . 2))))
           (org-reverse-note-order . nil)  ;; Notes at the top

           (org-show-following-heading . t)
           (org-show-hierarchy-above . t)
           (org-show-siblings . (quote ((default))))
           ;; 18.7.6 Searching and showing results

           ;; Org-mode's searching capabilities are really effective at
           ;; finding data in your org files. C-c / / does a regular
           ;; expression search on the current file and shows matching
           ;; results in a collapsed view of the org-file.  I have
           ;; org-mode show the hierarchy of tasks above the matched
           ;; entries and also the immediately following sibling task
           ;; (but not all siblings) with the following settings:

           (org-link-abbrev-alist .
                                  '(("tsfile" . "~/org/memacs/files.org_archive::/\*.*%s/")
                                    ("google" . "http://www.google.com/search?q="))))
  )  ;; leaf org block ends here.

(leaf org-agenda-mode-hook*
  :if (eq system-type 'darwin)
  :hook (org-agenda-mode-hook . org-mobile-pull))

(leaf my-babel*
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages '((R . t)
                               (haskell .t)
                               (dot . t)
                               (shell . t)
                               (ditaa . t))))

(leaf ox-tufte-latex
  :tag "out-of-MELPA"
  :added "2021-10-26"
  :url "https://github.com/tsdye/tufte-org-mode"
  :straight (ox-tufte-latex :type git :host github :repo "tsdye/tufte-org-mode")
  :require t)

(leaf org-structure-template*
  :defvar org-structure-template-alist
  :config
  (add-to-list 'org-structure-template-alist
               '("d" . "description")))

(leaf *orgcature
  :defvar org-capture-templates
  :config
  ;; Populates only the EXPORT_FILE_NAME property in the inserted headline.
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
  See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_HUGO_BUNDLE: " fname)
                   ":EXPORT_FILE_NAME: index"
                   ":END:"
                   "#+begin_src yaml :front_matter_extra t"
                   "  showtoc: false"
                   "  cover:"
                   "    image: \"wance-paleri-Uo40KRVStJo-unsplash.jpg\""
                   "    alt: \"cover image\""
                   "    caption: \"Photo by Wance Paleri\""
                   "    relative: true"
                   "#+end_src"
                   "%?\n")          ;Place the cursor here finally
                 "\n")))
  (add-to-list 'org-capture-templates
               '("H"                ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
                 (file+olp "~/vercelhugo/org/posts.org" "Blog")
                 (function org-hugo-new-subtree-post-capture-template)))

  ;; move from (leaf org block

  (add-to-list 'org-capture-templates
               '("t"
                 "Inbox todo"
                 entry
                 (file "~/org/flagged.org")
                 "* TODO %?
    %i
    %a"))

  (add-to-list 'org-capture-templates
               '("n"
                 "Note"
                 entry
                 (file+olp+datetree "~/org/notes.org")
                 "* %? :NOTE:\nEntered on %U\n%i\n%a\n"
                 ))
  (add-to-list 'org-capture-templates
               '("J"
                 "Journal from MobileOrg.  Please put headline into kill ring."
                 entry
                 (file+olp+datetree "~/org/notes.org")
                 "%c"))

  (add-to-list 'org-capture-templates
               '("w"
                 "Weekly Review "
                 entry
                 (file+olp+datetree "~/org/notes.org")
                 "* Weekly Review entered on %U\n** Ask yourself following questions and take note
     - How do I feel I did this week overall?
       %?
     - What enabled me to reach my goals this week?

     - Has anything stopped me from reaching my goals this week?

     - Which actions did I take this week that will propel me towards my long-term goals?

     - How can I improve for next week?

     - What should I plan for in the next month? Year? 5 Years?

     - What can I do next week that will set me up for my long-term goals?
    %i
    %a"))

(leaf *ox-hugo--capture
  :require org-capture org-id
  :defvar (org-capture-templates)
  :config
  (add-to-list 'org-capture-templates
               '("b" "Create new blog post" entry
                 (file+headline "~/hugo/content-org/all-posts.org" "Blog")
                 "** TODO %?
:PROPERTIES:
:EXPORT_HUGO_BUNDLE: %(apply 'org-id-uuid nil)
:EXPORT_FILE_NAME: index
:END:
" :prepend t)))
  :after org-capture)

(leaf *ox-journal--capture
  :require org-capture org-id
  :defvar (org-capture-templates)
  :config
  (add-to-list 'org-capture-templates
               '("j"
                 "Journal"
                 entry
                 (file+headline "~/org/journal.org" "journal")
                 "** %?
   Entered on %U
   %i
   %a")))

(leaf org-protocol-capture-template*
  :defvar org-capture-templates
  :require org-protocol
  :custom ((org-protocol-default-template-key . "w"))
  :config
  (add-to-list 'org-capture-templates
               '("w"
                 "org-protocol"
                 entry
                 (file "~/org/test.org")
                 "* TODO Review %a\n%U\n%:initial\n")))

(leaf ox-pandoc
  :straight t)

(leaf ox-hugo
  :straight t
  :require t
  :after ox)

(leaf ox-gfm
  :doc "Github Flavored Markdown Back-End for Org Export Engine"
  :tag "github" "markdown" "wp" "org"
  :added "2021-11-03"
  :straight t
  :config
  (with-eval-after-load 'ox
    (require 'ox-gfm nil nil)))

(leaf ox-reveal
  :straight t
  :require t
  :config
  (leaf htmlize
    :straight t))

(leaf koma-latex*
  :require ox-latex
  :defvar org-latex-default-class
  :defvar org-latex-classes
  :setq ((org-latex-default-class . "bxjsarticle"))
  :custom ((org-latex-compiler . "lualatex"))
  :config
  (add-to-list 'org-latex-classes
               '("jsarticle" "\\documentclass[uplatex,dvipdfmx,a4paper]{jsarticle}
\\usepackage{newpxtext}
\\usepackage{bxpapersize}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("koma-article" "\\documentclass{scrartcl}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("koma-jarticle" "\\documentclass{scrartcl}\n               \\usepackage{amsmath}\n               \\usepackage{amssymb}\n                   \\usepackage{fixltx2e}\n               \\usepackage{graphicx}\n               \\usepackage{longtable}\n               \\usepackage{float}\n               \\usepackage{wrapfig}\n               \\usepackage{soul}\n               \\usepackage{hyperref}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("tufte-handout" "\\RequirePackage{luatex85}\n\\documentclass[twoside,nobib]{tufte-handout}\n  [NO-DEFAULT-PACKAGES]\n"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")))
  (add-to-list 'org-latex-classes
               '("tufte-book" "\\RequirePackage{luatex85}\n\\documentclass[twoside,nobib]{tufte-book}\n  [NO-DEFAULT-PACKAGES]\n"
                 ("\\part{%s}" . "\\part*{%s}")
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}"))))

(leaf solarized-theme
  :doc "The Solarized color theme"
  :req "emacs-24.1"
  :tag "solarized" "themes" "convenience" "emacs>=24.1"
  :url "http://github.com/bbatsov/solarized-emacs"
  :added "2022-01-30"
  :emacs>= 24.1
  :when (string= system-type 'darwin)
  :defvar solarized-height-minus-1 solarized-height-plus-1
  :defvar solarized-height-plus-2 solarized-height-plus-3
  :defvar solarized-height-plus-4 solarized-distinct-fringe-background
  :defvar solarized-use-less-bold solarized-use-more-italic
  :defvar solarized-use-variable-pitch
  :straight t
  :config
  (progn (setq solarized-height-minus-1 1.0)
         (setq solarized-height-plus-1 1.0)
         (setq solarized-height-plus-2 1.0)
         (setq solarized-height-plus-3 1.0)
         (setq solarized-height-plus-4 1.0)

         (setq solarized-distinct-fringe-background t)

         (setq solarized-use-less-bold t)

         ;; Use more italics
         (setq solarized-use-more-italic t)

         (setq solarized-use-variable-pitch nil))
  (load-theme 'solarized-light t))

(leaf frame-set
  :config
  (cond
   ((string-equal (system-name) "MacBookWorld.local")
    (progn
      (setq initial-frame-alist
            (append (list
                     '(width . 155)
                     '(height . 50)
                     '(top . 0)
                     '(left . 0)
                     )
                    initial-frame-alist))
      (setq default-frame-alist initial-frame-alist)))
   ((string-equal (system-name) "MacBookProWorld.local")
    (setq initial-frame-alist
          (append (list
                   '(width . 175)
                   '(height . 50)
                   '(top . 0)
                   '(left . 0)
                   )
                  initial-frame-alist))
    (setq default-frame-alist initial-frame-alist))))

;; Font setting
;; [[https://ja.osdn.net/projects/macemacsjp/lists/archive/users/2011-January/001686.html]]
(leaf font-setting
  :config
  (cond
   ((eq window-system 'ns)
    (progn
      (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")
      (set-fontset-font "fontset-menlokakugo" 'unicode (font-spec :family "Hiragino Kaku Gothic ProN" ) nil 'append)
      (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))
      (setq face-font-rescale-alist '((".*Hiragino.*" . 1.2) (".*Menlo.*" . 1.0)))
      ))))

(leaf ansi-color
  :defun ansi-color-apply-on-region
  :config
  (defun colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))
  (add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
  :straight t)

(leaf japanese-holidays
  :straight t
  :defvar japanese-holidays calendar-holidays
  :hook ((calendar-today-visible-hook . japanese-holiday-mark-weekend)
         (calendar-today-invisible-hook . japanese-holiday-mark-weekend)
         ;; “きょう”をマークするには以下の設定を追加します。
         (calendar-today-visible-hook . calendar-mark-today))
  :config
  (setq calendar-holidays  ; 他の国の祝日も表示させたい場合は適当に調整
        (append japanese-holidays holiday-local-holidays holiday-other-holidays))
  :custom ((calendar-week-start-day . 1)  ;; 月曜始まり
           (calendar-mark-holidays-flag . t)   ;; 祝日をカレンダーに表示
           ;; 土曜日・日曜日を祝日として表示する場合、以下の設定を追加します。
           ;; 変数はデフォルトで設定済み
           (japanese-holiday-weekend . '(0 6)) ;; 土日を祝日として表示
           (japanese-holiday-weekend-marker .  ;; 土曜日を水色で表示
                                            '(holiday nil nil nil nil nil japanese-holiday-saturday))))

(leaf pdf-tools
  :when (string= system-type 'darwin)
  :straight t
  :bind ((pdf-view-mode-map
          ("C-s" . isearch-forward)))
  :require t
  :defvar pdf-annot-activate-created-annotations pdf-view-resize-factor
  :setq ((pdf-annot-activate-created-annotations . t)
         (pdf-view-resize-factor . 1.1))
  :config
  (pdf-tools-install))

(leaf org-pdftools
  :straight t
  :hook (org-load . org-pdftools-setup-link))

(leaf ob-ditaa
  :custom (
           ;; http://misohena.jp/blog/2017-10-26-how-to-use-code-block-of-emacs-org-mode.html#org5f14dce
           (org-ditaa-jar-path . "~/.jditaa/jditaa.jar")))

(leaf dired*
  :bind ((dired-mode-map
          :package dired
          ("E" . wdired-change-to-wdired-mode))))

(leaf dired-recent
  :straight t
  :global-minor-mode t)

(leaf elmacro
  :doc "Convert keyboard macros to emacs lisp"
  :req "s-1.11.0" "dash-2.13.0"
  :tag "convenience" "elisp" "macro"
  :added "2021-01-05"
  :url "https://github.com/Silex/elmacro"
  :straight t)

(leaf notmuch
  :doc "run notmuch within emacs"
  :added "2021-02-14"
  :url "https://notmuchmail.org"
  :bind
  ("C-c m" . notmuch)
  :custom
  (message-kill-buffer-on-exit . t)
  (mail-specify-envelope-from . t)
  (message-sendmail-envelope-from . 'header)
  (mail-envelope-from . 'header)  ;; See notmuch documentation Tips and Tricks for using Notmuch with Emacs section
  (message-auto-save-directory . "~/.mail/draft")
  (notmuch-fcc-dirs . nil)
  (message-from-style . nil)
  :straight t)

(leaf ol-notmuch
  :straight t
  :require notmuch ol )

(leaf web-mode
  :straight t
  :custom ((web-mode-markup-indent-offset . 2)
           (web-mode-css-indent-offset . 2)
           (web-mode-code-indent-offset . 2))
  :mode (("\\.js\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.ts\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)))

(leaf yaml-mode
  :doc "Major mode for editing YAML files"
  :req "emacs-24.1"
  :tag "yaml" "data" "emacs>=24.1"
  :added "2021-09-29"
  :url "https://github.com/yoshiki/yaml-mode"
  :emacs>= 24.1
  :straight t)

(leaf leaf-convert
  :custom ((css-indent-offset . 2)))

(leaf systemd
  :straight t)

(leaf elpy
  :straight t
  :init (elpy-enable)
  :custom ((python-indent-guess-indent-offset-verbose . nil)
           (python-indent-offset . 4)
           (elpy-rpc-virtualenv-path . (quote current))
           (elpy-test-runner . (quote elpy-test-pytest-runner))
           (elpy-django-test-runner-args . (quote ("test" "--noinput")))))

(leaf wc-mode
  :doc "Running word count with goals (minor mode)"
  :req "emacs-24.1"
  :tag "emacs>=24.1"
  :url "https://github.com/bnbeckwith/wc-mode"
  :added "2022-03-29"
  :emacs>= 24.1
  :custom (wc-modeline-format . "WC[%C%c/%tc]")
  :straight t
  :global-minor-mode wc-mode)

(leaf add-node-modules-path
  :doc "Add node_modules to your exec-path"
  :tag "eslint" "node_modules" "node" "javascript"
  :added "2021-09-26"
  :url "https://github.com/codesuki/add-node-modules-path"
  :hook ((web-mode-hook . add-node-modules-path))
  :straight t)

(leaf ess
  :doc "Emacs Speaks Statistics"
  :req "emacs-25.1"
  :tag "emacs>=25.1"
  :added "2021-11-03"
  :url "https://ess.r-project.org/"
  :emacs>= 25.1
  :when (string= system-type 'darwin)
  :defun straight-use-package
  :straight t)

(leaf citar-org-roam
  :straight t
  :blackout t
  :custom
  (citar-notes-source . 'orb-citar-source)
  :config
  (citar-register-notes-source
   'orb-citar-source (list :name "Org-Roam Notes"
                           :category 'org-roam-node
                           :items #'citar-org-roam--get-candidates
                           :hasitems #'citar-org-roam-has-notes
                           :open #'citar-org-roam-open-note
                           :create #'orb-citar-edit-note
                           :annotate #'citar-org-roam--annotate))
  :global-minor-mode citar-org-roam-mode
  :after citar org-roam)

(leaf consult-org-roam
  :doc "Consult integration for org-roam"
  :req "emacs-27.1" "org-roam-2.2.0" "consult-0.16"
  :tag "emacs>=27.1"
  :url "https://github.com/jgru/consult-org-roam"
  :added "2022-11-06"
  :emacs>= 27.1
  :straight t
  :disabled t
  :after org-roam consult
  :global-minor-mode consult-org-roam-mode
  :custom
  ;; Use `ripgrep' for searching with `consult-org-roam-search'
   (consult-org-roam-grep-func . #'consult-ripgrep)
   ;; Configure a custom narrow key for `consult-buffer'
   (consult-org-roam-buffer-narrow-key . ?r)
   ;; Display org-roam buffers right after non-org-roam buffers
   ;; in consult-buffer (and not down at the bottom)
   (consult-org-roam-buffer-after-buffers . t)
   :config
   ;; Eventually suppress previewing for certain functions
   (consult-customize
    consult-org-roam-forward-links
    :preview-key (kbd "M-.")))

(leaf mylisp
  :straight (mylisp :type git :host github :repo "pxel8063/mylisp")
  :bind (("<f7>" . sf/switch-term-buffer)))

(leaf anki-editor
  :doc "Minor mode for making Anki cards with Org"
  :req "emacs-25" "request-0.3.0" "dash-2.12.0"
  :tag "emacs>=25"
  :url "https://github.com/louietan/anki-editor"
  :added "2022-01-09"
  :emacs>= 25
  :straight t)

(leaf org-fc
  :require t org-fc-hydra
  :disabled t
  :when (string= system-type 'darwin)
  :load-path "~/.emacs.d/lisp/org-fc/"
  :custom `((org-fc-directories . '("~/org/"))
           (org-fc-review-history-file . ,(expand-file-name "org-fc-reviews.tsv" "~/org/")))
  :after org hydra)

(leaf ediff
  :custom ((ediff-diff-options . "-w")
           (ediff-split-window-function . 'split-window-horizontally)
           (ediff-window-setup-function . 'ediff-setup-windows-plain)))

(leaf xterm-mouse-blink*
  :doc "Use copy and paste on Blink.sh"
  :when (not (string= system-type 'darwin))
  :global-minor-mode  xterm-mouse-mode
  :config
  (leaf clipetty
    :straight t
    :hook ((after-init-hook . global-clipetty-mode))))

(leaf haskell-mode
  :straight t)

(leaf ace-link
  :straight t
  :config
  (ace-link-setup-default))

(leaf server
  :defun server-running-p
  :config
  (add-hook 'after-init-hook
            (lambda ()
              (require 'server)
              (unless (server-running-p)
                (server-start)))))

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
