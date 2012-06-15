(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(add-to-list 'load-path "~/.emacs.d/vendor")

(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))


(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (let (el-get-master-branch)
     (end-of-buffer)
     (eval-print-last-sexp)))))



(setq el-get-sources
     '(
      (:name textmate
             :type git
             :url "git://github.com/defunkt/textmate.el"
             :load "textmate.el")
      (:name rcodetools
             :type git
             :url "git://github.com/tnoda/rcodetools.git")
      ))
   
(setq my-packages (append '(
			    coffee-mode
			    color-theme
			    cheat
			    cssh
			    el-get
			    switch-window
			    auto-complete
			    auto-complete-css
			    auto-complete-ruby
			    ac-octave
			    haml-mode
			    haskell-mode
			    ido-ubiquitous
			    ;inf-ruby
			    jquery-doc
			    json
			    lua-mode
			    magit
			    magithub
			    markdown-mode
			    ;nxhtml
			    ;pastebin
			    php-mode
			    ;python-mode
			    ;matlab-mode ;; fails to compile
			    scss-mode
			    rinari
			    rspec-mode
			    ruby-block
			    ruby-end
			    ruby-mode
			    ;ruby-compilation
			    ruby-electric
			    yaml-mode
			    yasnippet
			    ) (mapcar 'el-get-source-name el-get-sources))) (el-get 'sync my-packages)

(el-get 'sync my-packages)


(color-theme-initialize)
; Twilight, Blackboard, Sunburst
(load-file "~/.emacs.d/themes/color-theme-blackboard-custom.el")
(load-file "~/.emacs.d/themes/color-theme-twilight-custom.el")
(load-file "~/.emacs.d/themes/color-theme-sunburst-custom.el")
(color-theme-blackboard-custom)











(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(js-curly-indent-offset 2)
 '(js-expr-indent-offset 2)
 '(js-indent-level 2)
 '(js-paren-indent-offset 2)
 '(js-square-indent-offset 2)
 '(verilog-auto-delete-trailing-whitespace t)
 '(verilog-auto-lineup (quote all))
 '(verilog-indent-level 2)
 '(verilog-indent-level-behavioral 2)
 '(verilog-indent-level-declaration 2)
 '(verilog-indent-level-directive 0)
 '(verilog-indent-level-module 2))


;; show trailing whitespace
(require 'whitespace)
(setq-default whitespace-style '(face trailing))
(setq-default whitespace-line-column 80)
(global-whitespace-mode 1)



(ido-mode t)                                            ; file/buffer selector
(setq-default
 ido-enable-flex-matching t                             ; fuzzy matching for ido mode
 ; ido-create-new-buffer 'always                          ; create new buffer without prompt
 ido-everywhere t)                                      ; use ido where possible


(which-func-mode t)                       ; show current function
(show-paren-mode t)                       ; show matching paren
(transient-mark-mode t)                   ; show highlighting
(global-font-lock-mode t)                 ; syntax highlighting


(require 'starter-kit-ruby)
(require 'starter-kit-js)



(define-key global-map (kbd "RET") 'newline-and-indent)
(setq-default auto-indent-indentation-function 'newline-and-indent)


(add-hook 'haml-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (define-key haml-mode-map "\C-m" 'newline-and-indent)))



(setq yas/snippet-dirs '("~/.emacs.d/snippets" "~/.emacs.d/el-get/yasnippet/extras/imported" "~/.emacs.d/el-get/yasnippet/snippets"))
(yas/global-mode 1)
(setq yas/trigger-key "C-<tab>")


;;; PYTHON: included in Emacs
(autoload 'python-mode "python-mode.el" "Python mode." t)
(setq auto-mode-alist (append '(("/*.\.py$" . python-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("/*.\.tac$" . python-mode)) auto-mode-alist))

;(require 'auto-complete)
;(require 'auto-complete-config)
;(ac-config-default)


    (define-key ac-completing-map "\t" 'ac-complete)
    (define-key ac-completing-map "\r" nil)
    (define-key ac-mode-map "\r" nil)

(global-auto-complete-mode t)
    ;; AutoComplete keymap: standard keys (RET - TAB), but no auto-start
    ;(setq ac-auto-start nil)
    (setq ac-dwim t)
    ;(setq ac-use-menu-map t)
    ;(setq ac-override-local-map nil)        ;don't override local map
    ;(define-key ac-mode-map (kbd "<C-tab>") 'auto-complete)
    (define-key ac-completing-map "\t" 'ac-complete)
    (define-key ac-completing-map "\r" nil)
    (define-key ac-mode-map "\r" nil)

    ;(ac-set-trigger-key "TAB")
    ;(define-key ac-completing-map (kbd "C-M-n") 'ac-next)
    ;(define-key ac-completing-map (kbd "C-M-p") 'ac-previous)
    ;(define-key ac-completing-map "\t" 'ac-complete)
    ;(define-key ac-completing-map "\r" nil)

(defun my-verilog-hook ()
    (setq indent-tabs-mode nil)
    (setq tab-width 2))
 (add-hook 'verilog-mode-hook 'my-verilog-hook)

