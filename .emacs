(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))

;;(add-hook 'c-mode-common-hook 
;;  (lambda()
;;    (require 'dtrt-indent)
;;    (dtrt-indent-mode t)))






;;;Add the following custom-set-variables to use 'lazy' modes
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



















(require 'cc-mode)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
(c-add-style "openbsd"
              '("bsd"
                (indent-tabs-mode . t)
                (defun-block-intro . 8)
                (statement-block-intro . 8)
                (statement-case-intro . 8)
                (substatement-open . 4)
                (substatement . 8)
                (arglist-cont-nonempty . 4)
                (inclass . 8)
                (knr-argdecl-intro . 8)))

(setq c-default-style "openbsd")



(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (let (el-get-master-branch)
     (end-of-buffer)
     (eval-print-last-sexp)))))






;; show trailing whitespace
(setq-default whitespace-style
'(trailing
space-before-tab))
(require 'whitespace)
(global-whitespace-mode t)

;; save history across invocations
(setq-default savehist-additional-variables
'(kill-ring search-ring regexp-search-ring))
(savehist-mode 1)

;; needed for auto-indent-mode
(require 'shrink-whitespaces)
;; automatically indent
(setq-default auto-indent-untabify-on-save-file nil
              auto-indent-blank-lines-on-move nil)




;;(require 'auto-indent-mode)
;;(auto-indent-global-mode 1)







;; So the idea is that you copy/paste this code into your *scratch* buffer,
;; hit C-j, and you have a working developper edition of el-get.
(url-retrieve
 "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
 (lambda (s)
   (let (el-get-master-branch)
     (end-of-buffer)
     (eval-print-last-sexp))))











(let ((cedet-dir (expand-file-name "cedet" el-get-dir)))
  (add-to-list 'load-path (expand-file-name
                           "common" cedet-dir))
  (add-to-list 'load-path (expand-file-name
                           "speedbar" cedet-dir))
  (require 'inversion nil t))




;; local sources
(setq el-get-sources
      '((:name magit
               :after (lambda () (global-set-key (kbd "C-x C-z") 'magit-status)))

        (:name asciidoc
               :type elpa
               :after (lambda ()
                        (autoload 'doc-mode "doc-mode" nil t)
                        (add-to-list 'auto-mode-alist '("\\.adoc$" . doc-mode))
                        (add-hook 'doc-mode-hook '(lambda ()
                                                    (turn-on-auto-fill)
                                                    (require 'asciidoc)))))

        (:name lisppaste        :type elpa)))


(setq my-packages
      (append
	'(cssh
	   el-get
	   coffee-mode
	   color-theme
	   cheat
	   switch-window
	   vkill
	   xcscope
	   yasnippet
	   popup
	   auto-complete-ruby
	   auto-complete-yasnippet
	   auto-complete-clang
	   ac-octave
	   ac-dabbrev
	   csv-mode
	   dsvn
	   gist
	   git-emacs
	   gnuplot-mode
	   haml-mode
	   highlight-parentheses
	   jquery-doc
	   json
	   lua-mode
	   magit
	   magithub
	   markdown-mode
	   matlab-mode
	   php-mode
	   python-mode
	   regex-tool
	   inf-ruby
	   ruby-electric
	   ruby-mode
	   ruby-block
	   ruby-end
	   scss-mode
	   sudo-save
	   sunrise-commander
	   sunrise-x-buttons
	   sunrise-x-tree
	   yaml-mode
	   undo-tree
	   )
       (mapcar 'el-get-source-name el-get-sources)))

(el-get 'sync my-packages)

(setq yas/snippet-dirs '("~/.emacs.d/snippets" "~/.emacs.d/el-get/yasnippet/extras/imported" "~/.emacs.d/el-get/yasnippet/snippets"))
(yas/global-mode 1)
(global-undo-tree-mode)

(color-theme-initialize)
(load-file "~/.emacs.d/themes/color-theme-blackboard.el")
(color-theme-blackboard)


     (add-hook 'haml-mode-hook
               (lambda ()
                 (setq indent-tabs-mode nil)
                 (define-key haml-mode-map "\C-m" 'newline-and-indent)))

(defun my-verilog-hook ()
    (setq indent-tabs-mode nil)
    (setq tab-width 2))
 (add-hook 'verilog-mode-hook 'my-verilog-hook)



(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(defun custom-ruby-hook ()
  "Customize ruby-mode."
  (interactive)
  (setq indent-tabs-mode nil)
  (define-key ruby-mode-map (kbd "M-l") 'insert-hashrocket))

(defun insert-hashrocket ()
  "Inserts a hashrocket at point."
  (interactive)
  (unless (or (looking-at "\\s*=>\\s*") (looking-back "\\s*=>\\s*"))
    (delete-horizontal-space)
    (insert " => ")))

(add-hook 'ruby-mode-hook 'custom-ruby-hook)

(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))



;;; starter-kit-ruby.el --- Some helpful Ruby code
;;
;; Part of the Emacs Starter Kit

(eval-after-load 'ruby-mode
  '(progn
     ;; work around possible elpa bug
     (ignore-errors (require 'ruby-compilation))
     (setq ruby-use-encoding-map nil)
     (add-hook 'ruby-mode-hook 'inf-ruby-keys)
     (define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
     (define-key ruby-mode-map (kbd "C-M-h") 'backward-kill-word)
     (define-key ruby-mode-map (kbd "C-c l") "lambda")))

(global-set-key (kbd "C-h r") 'ri)

;; Rake files are ruby, too, as are gemspecs, rackup files, etc.
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))

;; We never want to edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")

;;; Rake

(defun pcomplete/rake ()
  "Completion rules for the `ssh' command."
  (pcomplete-here (pcmpl-rake-tasks)))

(defun pcmpl-rake-tasks ()
  "Return a list of all the rake tasks defined in the current
projects.  I know this is a hack to put all the logic in the
exec-to-string command, but it works and seems fast"
  (delq nil (mapcar '(lambda(line)
                       (if (string-match "rake \\([^ ]+\\)" line) (match-string 1 line)))
                    (split-string (shell-command-to-string "rake -T") "[\n]"))))

(defun rake (task)
  (interactive (list (completing-read "Rake (default: default): "
                                      (pcmpl-rake-tasks))))
  (shell-command-to-string (concat "rake " (if (= 0 (length task)) "default" task))))



;; Rinari (Minor Mode for Ruby On Rails)
(setq rinari-major-modes
      (list 'mumamo-after-change-major-mode-hook 'dired-mode-hook 'ruby-mode-hook
            'css-mode-hook 'yaml-mode-hook 'javascript-mode-hook))

;; TODO: set up ri
;; TODO: electric

(provide 'starter-kit-ruby)
;; starter-kit-ruby.el ends here
