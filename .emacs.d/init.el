(setq gc-cons-threshold (* 1024 1024 1024))
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold (* 1 1024 1024))))
(setq garbage-collection-messages t)

(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "~/bin")
(add-to-list 'load-path "~/.emacs.d/elisp")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)


(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)
  )

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(setq debug-on-error t)

(set-language-environment 'japanese)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

(use-package cl
  :ensure t
  :defer t)

;; タイトルバーにファイル名を表示する
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;;選択領域のハイライト
(transient-mark-mode 1)
;; メニューバーを消す
(menu-bar-mode -1)
;; スクロールバーを消す
(scroll-bar-mode -1)
;; ツールバー（アイコン）を消す
(tool-bar-mode 0)
(column-number-mode t)
;; 1行ずつスクロール
(setq scroll-step 1)
;; 対応するカッコを色表示する
(show-paren-mode 1)
;; 行表示
(global-linum-mode t)
(setq linum-format "%4d ")
;; 時間表示
(display-time-mode 1)
;; ヴィジュアルベル無効
(setq visible-bell nil)
;; ビープ音無効
(setq ring-bell-function '(lambda ()))
;;インデントはスペースにする
(setq-default indent-tabs-mode nil)
;;インデント幅
(setq-default c-basic-offset 2)
;;タブ幅
(setq-default default-tab-width 2)
(setq-default tab-width 2)
;; 自動バックアップファイルの未作成
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq backup-inhibited t)
;; 色つける
(global-font-lock-mode t)
(setq-default transient-mark-mode t)

(ffap-bindings)

;; (use-package dired
;;   :ensure nil
;;   :commands (dired)
;;   :custom
;;   (dired-dwim-target t "Enable side-by-side `dired' buffer targets.")
;;   (dired-recursive-copies 'always "Better recursion in `dired'.")
;;   (dired-recursive-deletes 'top)
;;   (dired-listing-switches "-lahp"))

;; wdired
;; (use-package wdired
;;   :ensure t
;;   :defer t
;;   :bind (:map dired-mode-map ("r" . wdired-change-to-wdired-mode))
;;   )

;;  (advice-add 'dired-find-file :after 'delete-other-windows)

;; 改行マーク/全角スペースマーク/タブマーク
(use-package whitespace
  :ensure t
  :config
  (progn
    (global-whitespace-mode 1)
    (set-face-foreground 'whitespace-space "#555555")
    (set-face-background 'whitespace-space nil)
    (set-face-foreground 'whitespace-tab "#555555")
    (set-face-background 'whitespace-tab nil)
    (setq whitespace-style
      '(tabs tab-mark spaces space-mark trailing face))
    (setq whitespace-space-regexp "\\(\x3000+\\)")
    (setq whitespace-display-mappings
          '((space-mark ?\x3000 [?\□])
            (tab-mark   ?\t   [?\xBB ?\t])))
    ))

;; 行末の空白をめだたせる M-x delete-trailing-whitespace で削除出来る
(when (boundp 'show-trailing-whitespace) (setq-default show-trailing-whitespace t))
;; yes/no -> y/n
(fset 'yes-or-no-p 'y-or-n-p)

(define-key isearch-mode-map (kbd "C-h") 'isearch-del-char)

;; tramp
(use-package tramp
  :ensure t
  :defer t
  :config
  (progn
    (setq tramp-default-method "ssh")))

;; esup
(use-package esup
  :ensure t
  :defer t)

;; recentf
(recentf-mode t)
;; open-junk-file
(defun open-junk-file ()
  (interactive)
  (let* ((file (expand-file-name
                (format-time-string
                 "%Y/%m/%Y-%m-%d-%H%M%S." (current-time))
                "~/memo/junk/"))
         (dir (file-name-directory file)))
    (make-directory dir t)
    (find-file-other-window (read-string "Junk Code: " file))))
(global-set-key (kbd "C-x C-z") 'open-junk-file)

(find-function-setup-keys)

;; popwin
(use-package popwin
  :ensure t
  :defer t
  :init
  (progn
   (setq display-buffer-function 'popwin:display-buffer)))

;; migemo
;; https://gist.github.com/4176883
(use-package migemo
  :ensure t
  :defer t
  :config
  (prong
     (setq migemo-command "cmigemo")
     (setq migemo-options '("-q" "--emacs"))
     (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
     (setq migemo-user-dictionary nil)
     (setq migemo-regex-dictionary nil)
     (setq migemo-coding-system 'utf-8-unix)
     (load-library "migemo")
     (migemo-init)))

;; cua-mode
(use-package cua-base
  :ensure t
  :defer t
  :init
  (cua-mode t)
  :bind
  (("C-x SPC" . cua-set-rectangle-mark))
  :config
  (progn
    (setq cua-enable-cua-keys nil)))

;; ddskk
(use-package ddskk
  :ensure t
  :defer t
  :bind ("C-x C-j" . skk-mode))

;;;;;;;;;;;;;;;;;;;;
;; Keybinds

(global-set-key "\C-h" 'backward-delete-char-untabify)

;; backward-delete-word
;; http://www.emacswiki.org/emacs/BackwardDeleteWord
(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word. With argument, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the end of a word. With argument, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

(global-set-key "\M-h" 'backward-delete-word)

;;C-x C-gで、指定行に飛ぶ
(global-set-key "\C-x\C-g" 'goto-line)
;;bs-showでバッファ選択する。
(global-set-key "\C-x\C-b" 'bs-show)

(global-set-key "\C-c\g" 'moccur-grep-find)
(global-set-key "\C-j" 'eval-print-last-sexp)

;; window resizer
;; http://d.hatena.ne.jp/mooz/20100119/p1
(defun window-resizer ()
  "Control window size and position."
  (interactive)
  (let ((window-obj (selected-window))
    (current-width (window-width))
    (current-height (window-height))
    (dx (if (= (nth 0 (window-edges)) 0) 1
          -1))
    (dy (if (= (nth 1 (window-edges)) 0) 1
          -1))
    c)
  (catch 'end-flag
    (while t
      (message "size[%dx%dy]"
               (window-width) (window-height))
      (setq c (read-char))
      (cond ((= c ?f)
             (enlarge-window-horizontally dx))
            ((= c ?b)
             (shrink-window-horizontally dx))
            ((= c ?n)
             (enlarge-window dy))
            ((= c ?p)
             (shrink-window dy))
            (t
             (message "Quit")
             (throw 'end-flag t)))))))

(define-key global-map "\C-q" (make-sparse-keymap))
(global-set-key "\C-q\C-q" 'quoted-insert)
(global-set-key "\C-q\C-r" 'window-resizer)
(global-set-key "\C-q\C-f" 'windmove-right)
(global-set-key "\C-q\C-b" 'windmove-left)
(global-set-key "\C-q\C-p" 'windmove-up)
(global-set-key "\C-q\C-n" 'windmove-down)

;; helm
(use-package helm
  :ensure t
  :bind  (("M-x"     . helm-M-x)
          ("C-c f"   . helm-mini)
          ("C-c C-s" . helm-ag)
          ("C-c C-f" . helm-find-files)
          ("C-c b"   . helm-buffers-list)
          ("C-c i"   . helm-imenu)
          ("C-c o"   . helm-occur)
          :map helm-map
          ("C-h" . delete-backward-char)
          :map helm-find-files-map
          ("C-h" . delete-backward-char))
  :init (progn
          (use-package helm-config)
          (helm-mode 1)))

(use-package helm-swoop
  :ensure t)

(use-package helm-ag
  :ensure t
  :defer t)

(use-package helm-projectile
  :ensure t
  :defer t)

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-global-mode t)
  (helm-projectile-on))

;; neotree
(use-package neotree
  :ensure t
  :defer t
  :after
  projectile
  :custom
  (neo-theme 'nerd2)
  :bind
  (([f8] . neotree-toggle)))


;; company
(use-package company
  :ensure t
  :defer t
  :bind
  (:map company-active-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
        ("C-s" . company-filter-candidates)
        ("C-i" . company-filter-selection))
  (:map company-search-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous))
  (:map emacs-lisp-mode-map
        ("C-M-i" . company-complete)))

;; flycheck
(use-package flycheck
  :ensure t
  :defer t)

(use-package magit
  :ensure t
  :defer t)

;; git-gutter+
(use-package git-gutter+
  :ensure t
  :init (global-git-gutter+-mode)
  :config (progn
            (define-key git-gutter+-mode-map (kbd "C-x n") 'git-gutter+-next-hunk)
            (define-key git-gutter+-mode-map (kbd "C-x p") 'git-gutter+-previous-hunk)
            (define-key git-gutter+-mode-map (kbd "C-x v =") 'git-gutter+-show-hunk)
            (define-key git-gutter+-mode-map (kbd "C-x r") 'git-gutter+-revert-hunks)
            (define-key git-gutter+-mode-map (kbd "C-x t") 'git-gutter+-stage-hunks)
            (define-key git-gutter+-mode-map (kbd "C-x c") 'git-gutter+-commit)
            (define-key git-gutter+-mode-map (kbd "C-x C") 'git-gutter+-stage-and-commit)
            (define-key git-gutter+-mode-map (kbd "C-x C-y") 'git-gutter+-stage-and-commit-whole-buffer)
            (define-key git-gutter+-mode-map (kbd "C-x U") 'git-gutter+-unstage-whole-buffer))
  :diminish (git-gutter+-mode . "gg"))

;; yasnipet
(use-package yasnippet
  :ensure t
  :config (progn (yas-global-mode 1)))

 ;; autoinsert
(auto-insert-mode 1)
(setq auto-insert-directory "~/.emacs.d/templates/")
(setq auto-insert-alist
      (nconc '(
               ("\\.html$" . "tmpl.html")
               ("\\.py$" . "tmpl.py")
               ("\\.pl$" . "tmpl.pl")
               ("\\.rb$" . "tmpl.rb")
               ("\\.php$" . "tmpl.php")
               ("\\.tsx$" . "tmpl.tsx")
               ) auto-insert-alist))

(add-hook 'find-file-not-found-hooks 'auto-insert)

 ;; ESS
(use-package ess
  :ensure t
  :init (require 'ess))

 ;; stan
(use-package stan-snippets
  :ensure t
  :defer t)

 (use-package stan-mode
  :ensure t
  :defer t)

 (use-package octave
  :defer t
  :config
  (add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))
  (setf octave-block-offset 4))

(use-package w3m
  :ensure t
  :config
  (setq w3m-coding-system 'utf-8
        w3m-file-coding-system 'utf-8
        w3m-file-name-coding-system 'utf-8
        w3m-input-coding-system 'utf-8
        w3m-output-coding-system 'utf-8
        w3m-terminal-coding-system 'utf-8)
  (setq w3m-command "/usr/bin/w3m")
  (setq browse-url-browser-function 'w3m-browse-url)
  (autoload 'w3m-browse-url "w3m")
  (global-set-key "\C-xm" 'browse-url-at-point)
  (setq w3m-use-cookies t)
  (setq w3m-default-display-inline-images t))


(setq package-check-signature nil)

;; lsp-mode
(use-package lsp-mode
  :ensure t
  :defer t
  :hook (prog-major-mode . lsp-prog-major-mode-enable))

(use-package lsp-ui
  :ensure t
  :defer t
  :commands lsp-ui-mode
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  ;; :custom
    ;;   ;; lsp-ui-doc
    ;; (lsp-ui-doc-enable t)
    ;; (lsp-ui-doc-header t)
    ;; (lsp-ui-doc-include-signature t)
    ;; (lsp-ui-doc-position 'top) ;; top, bottom, or at-point
    ;; (lsp-ui-doc-max-width 150)
    ;; (lsp-ui-doc-max-height 30)
    ;; (lsp-ui-doc-use-childframe t)
    ;; (lsp-ui-doc-use-webkit t)
    ;; ;; lsp-ui-flycheck
    ;; (lsp-ui-flycheck-enable nil)
    ;; ;; lsp-ui-sideline
    ;; (lsp-ui-sideline-enable nil)
    ;; (lsp-ui-sideline-ignore-duplicate t)
    ;; (lsp-ui-sideline-show-symbol t)
    ;; (lsp-ui-sideline-show-hover t)
    ;; (lsp-ui-sideline-show-diagnostics nil)
    ;; (lsp-ui-sideline-show-code-actions nil)
    ;; ;; lsp-ui-imenu
    ;; (lsp-ui-imenu-enable nil)
    ;; (lsp-ui-imenu-kind-position 'top)
    ;; ;; lsp-ui-peek
    ;; (lsp-ui-peek-enable t)
    ;; (lsp-ui-peek-peek-height 20)
    ;; (lsp-ui-peek-list-width 50)
    ;; (lsp-ui-peek-fontify 'on-demand) ;; never, on-demand, or always
    )

(use-package company-lsp
  :ensure t
  :defer t
  :commands company-lsp
  :after (lsp-mode company yasnippet))

(require 'w3m)

;; elisp
(use-package lispxmp
  :ensure t
  :defer t
  :bind (:map emacs-lisp-mode-map ("C-c C-d" . lispxmp)))

(use-package paredit
  :ensure t
  :defer t
  ; :diminish paredit-mode
  :bind (:map paredit-mode-map (("C-j" . eval-print-last-sexp)
                                ("M-p" . paredit-splice-sexp-killing-backward)))
  :hook ((emacs-lisp-mode lisp-interaction-mode lisp-mode ielm-mode scheme-mode extempore-mode) . enable-paredit-mode))

;; Scheme / Gauche
(setq process-coding-system-alist
      (cons '("gosh" utf-8 . utf-8) process-coding-system-alist))

(setq scheme-program-name "gosh -i")
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run ad inferior Scheme process." t)

(defun scheme-other-window ()
  "Run scheme on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

(define-key global-map
  "\C-cs" 'scheme-other-window)

;; Ruby
;; TODO: basic configure only
(use-package ruby-mode
  :ensure t
  :defer t
  :config
  (progn
    (setq ruby-indent-level 2)
    (setq ruby-indent-tabs-mode nil)
    (setq auto-mode-alist (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
    (setq auto-mode-alist (append '(("\\.rake$" . ruby-mode)) auto-mode-alist))
    (setq auto-mode-alist (append '(("\\.ru$" . ruby-mode)) auto-mode-alist))
    (setq auto-mode-alist (append '(("\\.gemspec$" . ruby-mode)) auto-mode-alist))
    (setq auto-mode-alist (append '(("Gemfile$" . ruby-mode)) auto-mode-alist))
    (setq auto-mode-alist (append '(("Rakefile$" . ruby-mode)) auto-mode-alist))
    (setq auto-mode-alist (append '(("Guardfile$" . ruby-mode)) auto-mode-alist))
    (setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
    ))

(use-package inf-ruby
  :ensure t
  :defer t
  :hook (ruby-mode . inf-ruby-minor-mode))

(use-package ruby-block
  :ensure t
  :defer t
  :config
  (progn
    (ruby-block-mode t)
    (setq ruby-block-highlight-toggle t)))

;; haskell
(use-package haskell-mode
  :ensure t
  :defer t
  :mode (("\\.hs$" . haskell-mode)
         ("\\.lhs$" . literate-haskell-mode)
         ("\\.cabal\\'" . haskell-cabal-mode))
  :interpreter (("runghc" . haskell-mode)
                ("runhaskell" . haskell-mode))
  :hook (haskell-mode . (lambda ()
                          (turn-on-haskell-indentation)
                          (turn-on-haskell-doc-mode)
                          (font-lock-mode)
                          (imenu-add-menubar-index))))

;; rust
;; flycheck
(use-package flycheck-rust
  :ensure t
  :defer t)

(use-package racer
  :ensure t
  :defer t)

(use-package rust-mode
  :ensure t
  :defer t
  :hook ((rust-mode . (lambda ()
                        (racer-mode)
                        (flycheck-rust-setup)
                        ))
         (racer-mode . eldoc-mode)
         (racer-mode . (lambda ()
                         (company-mode)
                         (set (make-variable-buffer-local 'company-idle-delay) 0.3)
                         (set (make-variable-buffer-local 'company-minimum-prefix-length) 1))))
  :init
  (progn
    (add-to-list 'exec-path (expand-file-name "~/.cargo/bin")))
  :config
  (progn
    (setq-default rust-format-on-save t)))

;; python
(use-package py-autopep8
  :ensure t
  :defer t
  :hook (python-mode . py-autopep8-enable-on-save)
  :config
  (progn
    (setq py-autopep8-options '("--max-line-length=100"))))

;; golang
(use-package company-go
  :ensure t
  :defer t)

(use-package exec-path-from-shell
  :ensure t
  :defer t)

(use-package go-mode
  :ensure t
  :defer t
  :hook ((before-save . gofmt-before-save)
         (go-mode . (lambda ()
                      (let ((envs '("GOROOT" "GOPATH")))
                        (exec-path-from-shell-copy-envs envs))
                      (local-set-key (kbd "M-.") 'godef-jump)
                      (set (make-local-variable 'company-backends) '(company-go))
                      (company-mode)
                      (lsp)
                      (setq gofmt-command "goimports")
                      (setq indent-tabs-mode nil)
                      (setq c-basic-offset 4)
                      (setq tab-width 4))))
  :init
  (progn
    (add-to-list 'exec-path (expand-file-name "~/bin"))))

;; javascript
;; (use-package js2-mode
;;   :ensure t
;;   :defer t
;;   :mode "\\.js$"
;;   :config
;;   (progn
;;     (setq js2-strict-missing-semi-warning nil)
;;     (setq js2-missing-semi-one-line-override nil))
;;   :hook ((js2-mode . (lambda ()
;;                        (setq js2-basic-offset 2)
;;                        (setq prettier-js-args
;;                              '(
;;                                "--tab-width" "2"
;;                                "--single-quote" "true"
;;                                "--semi" "true"
;;                                ))
;;                        ))
;;          ; (js2-mode . ac-js2-mode)
;;          (js-mode . js2-minor-mode)))


(use-package js2-mode
  :ensure t
  :defer t
  :mode "\\.js$"
  :config
  (progn
    (setq js2-strict-missing-semi-warning nil)
    (setq js2-missing-semi-one-line-override nil))
  :hook ((js2-mode . (lambda ()
                       (setq js2-basic-offset 2)))
         ; (js2-mode . ac-js2-mode)
         (js-mode . js2-minor-mode)))


(use-package json-mode
  :ensure t
  :defer t
  :mode "\\.tss$"
  :hook ((json-mode . electric-pair-mode)
         (json-mode . (lambda ()
                        (setq js-indent-level 2)))))

;; typescript
(use-package tide
  :ensure t
  :defer t)

(use-package typescript-mode
  :ensure t
  :defer t
  :hook
  ((before-save . tide-format-before-save)
  (typescript-mode . (lambda ()
                             (tide-setup)
                             (flycheck-mode t)
                             (setq flycheck-check-syntax-automatically '(save mode-enabled))
                             (setq company-tooltip-align-annotations t)
                             (eldoc-mode t)
                             (tide-hl-identifier-mode t)
                             (company-mode t)
                             (lsp)
                             ))))

(defun enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
  (if (buffer-file-name)
      (if (string-match (car my-pair) buffer-file-name)
      (funcall (cdr my-pair)))))

(use-package prettier-js
  :ensure t
  :defer t)

;; web-mode
(defun my-web-mode-hook ()
  (let ((i 2))
    (cond ((string-equal "tsx" (file-name-extension buffer-file-name))
           (setq i 4)
           (setq prettier-js-args '(
                                    "--tab-width" "4"
                                    "--single-quote" "true"
                                    "--semi" "true"
                                    ))))
    (setq web-mode-attr-indent-offset nil)
    (setq web-mode-markup-indent-offset i)
    (setq web-mode-css-indent-offset i)
    (setq web-mode-code-indent-offset i)
    (setq web-mode-sql-indent-offset i)
    (setq indent-tabs-mode nil)
    (setq tab-width i)))

(use-package web-mode
  :ensure t
  :defer t
  :mode (("\\.phtml$"     . web-mode)
         ("\\.tpl\\.php$" . web-mode)
         ("\\.jsp$"       . web-mode)
         ("\\.erb$"       . web-mode)
         ("\\.html?$"     . web-mode)
         ("\\.php$"       . web-mode)
         ("\\.jsx$"       . web-mode)
         ("\\.tsx$"       . web-mode))
  :hook (web-mode . my-web-mode-hook)
  :config
  (progn
    (defadvice web-mode-highlight-part (around tweak-jsx activate)
      (if (equal web-mode-content-type "jsx")
          (let ((web-mode-enable-part-face nil))
            ad-do-it)
        ad-do-it))))


(use-package kotlin-mode
  :ensure t
  :defer t)

;; supercollider
(use-package sclang
  :load-path "elisp/scel"
  ; :bind (:map sclang-mode-map ("C-j" . sclang-eval-defun))
  :config
  (progn
    (custom-set-variables
     '(sclang-indent-level 2)
     '(sclang-library-configuration-file "~/.local/share/SuperCollider/sclang_conf.yaml"))))

(use-package highlight-numbers
  :ensure t
  :defer t
  :hook (tidal-mode . highlight-numbers-mode))

(use-package tidal
  ;; :load-path "elisp/tidal"
  :ensure t
  :defer t
  :bind (:map tidal-mode-map ("C-o" . tidal-run-multiple-lines))
  :config
  (progn
    (setq tidal-interpreter "stack")
    (setq tidal-interpreter-arguments (list "exec" "--package" "tidal" "--" "ghci"))
    ;; (setq tidal-interpreter-arguments (list "ghci" "--ghc-options" "-XOverloadedStrings"))
    (setq tidal-boot-script-path "~/.tidal/BootTidal.hs"
          )))

(add-hook 'font-lock-mode-hook
          '(lambda ()
             (set-face-foreground 'font-lock-constant-face "magenta")))

;; faust
(use-package faust-mode
  :ensure t
  :defer t)

;; GLSL
(use-package glsl-mode
  :ensure t
  :defer t
  :mode (("\\.glsl$" . glsl-mode)
         ("\\.vert$" . glsl-mode)
         ("\\.frag$" . glsl-mode)
         ("\\.geom$" . glsl-mode)))

;; extempore
(use-package extempore-mode
  :ensure t
  :defer t)

;; Makefile
(use-package make-mode
  :ensure t
  :defer t
  :hook
  (setq indent-tabs-mode nil))

;; docker
(use-package dockerfile-mode
  :ensure t
  :defer t)

;; terraform
(use-package terraform-mode
  :ensure t
  :defer t)

;; yaml
(use-package yaml-mode
  :ensure t
  :defer t)

;; toml
(use-package toml-mode
  :ensure t
  :defer t)

;; markdown
(use-package markdown-mode
  :ensure t
  :defer t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (progn
          (setq
           markdown-command "/usr/local/bin/multimarkdown"
           markdown-css-paths '("https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css"
                                "http://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github.min.css")
           markdown-xhtml-header-content "
<meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
<style>
body {
  box-sizing: border-box;
  max-width: 740px;
  width: 100%;
  margin: 40px auto;
  padding: 0 10px;
}
</style>
<script src='http://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js'></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
  document.body.classList.add('markdown-body');
  document.querySelectorAll('pre[lang] > code').forEach((code) => {
    code.classList.add(code.parentElement.lang);
    hljs.highlightBlock(code);
  });
});
</script>
")))

;; org
;; (use-package org
;;   :ensure t
;;   :defer t
;;   :commands (org-remember-insinuate)
;;   :mode ("\\.org$" . org-mode)
;;   :bind (("\C-cl" . org-store-link)
;;          ("\C-ca" . org-agenda)
;;          ("\C-cr" . org-remember))
;;   :hook (org-mode . turn-on-font-lock)
;;   :config
;;   (progn
;;     ;; 見出しの余分な*を消す
;;     (setq org-hide-leading-stars t)
;;     ;; org-default-notes-file のディレクトリ
;;     (setq org-directory "~/Dropbox/org/")
;;     ;; org-default-notes-file のファイル名
;;     (setq org-default-notes-file "notes.org")
;;     ;; TODO 状態
;;     (setq org-todo-keywords
;;           '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "SOMEDAY(s)")))
;;     ;; DONE の時刻を記録
;;     (setq org-log-done 'time)
;;     ;; org-remember を使う
;;     (org-remember-insinuate)
;;     ;; org-remember のテンプレート
;;     (setq org-remember-templates
;;           '(("Note" ?n "* %?\n  %i\n  %a" nil "Tasks")
;;             ("Todo" ?t "* TODO %?\n  %i\n  %a" nil "Tasks")))))

;;;;;;;;
;; TODO
;; tags
;; flymake
;; yasnippet


;; for mac
(when (eq system-type 'darwin)
  ;; key bind
  (setq mac-command-modifier 'super)
  (setq mac-option-modifier 'meta)

  ;; copy & paste sharing OS
  (defun copy-from-osx ()
    (let ((tramp-mode nil)
          (default-directory "~"))
      (shell-command-to-string "pbpaste")))

  (defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))

  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx))

(cond (window-system
  (setq x-select-enable-clipboard t)
  ))

(setq select-enable-primary nil)
(setq select-enable-clipboard t)

(use-package xclip
  :ensure t
  :init (progn
          (xclip-mode 1)))

;; theme
(use-package doom-themes
  :ensure t
  :custom
    (doom-themes-enable-italic t)
    (doom-themes-enable-bold t)
    :custom-face
    (doom-modeline-bar ((t (:background "#6272a4"))))
  :config
  (load-theme 'doom-vibrant t)
  (doom-themes-neotree-config)
  (doom-themes-org-config)
  (doom-themes-visual-bell-config))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(when (memq window-system '(mac ns x))
  (set-frame-parameter nil 'alpha 95)
  )

;; Font
(set-face-attribute 'default nil  :height 125)

(set-fontset-font (frame-parameter nil 'font)
                  'japanese-jisx0208
                  (cons "Ricty Discord" "iso10646-1"))

(set-fontset-font (frame-parameter nil 'font)
                  'japanese-jisx0212
                  (cons "Ricty Discord" "iso10646-1"))

(set-fontset-font (frame-parameter nil 'font)
                  'katakana-jisx0201
                  (cons "Ricty Discord" "iso10646-1"))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :hook (after-init . which-key-mode))

(use-package hydra
  :ensure t
  :defer t)

(use-package highlight-indent-guides
  :ensure t
  :diminish
  :hook
  ((prog-mode yaml-mode) . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-auto-enabled t)
  (highlight-indent-guides-responsive t)
  (highlight-indent-guides-method 'character)) ; column


(use-package volatile-highlights
  :ensure t
  :diminish
  :hook
  (after-init . volatile-highlights-mode))

(use-package org-pomodoro
  :ensure t
  ;; :after org-agenda
  :custom
  (org-pomodoro-ask-upon-killing t)
  (org-pomodoro-format "%s")
  (org-pomodoro-short-break-format "%s")
  (org-pomodoro-long-break-format  "%s")
  :custom-face
  (org-pomodoro-mode-line ((t (:foreground "#ff5555"))))
  (org-pomodoro-mode-line-break   ((t (:foreground "#50fa7b"))))
  :hook
  (org-pomodoro-started . (lambda () (notifications-notify
                                      :title "org-pomodoro"
                                      :body "Let's focus for 25 minutes!")))
  (org-pomodoro-finished . (lambda () (notifications-notify
                                       :title "org-pomodoro"
                                       :body "Well done! Take a break.")))
  :config
  :bind (:map org-agenda-mode-map
             ("p" . org-pomodoro)))


;; aspell
(setq-default ispell-program-name "aspell")
(eval-after-load "ispell"
  (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;; emacs server
(use-package server
  :ensure t
  :defer t
  :init
  (server-mode 1)
  :config
  (progn
    (unless (server-running-p)
    (server-start))))
