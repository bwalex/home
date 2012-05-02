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
	'(cssh el-get coffee-mode color-theme cheat switch-window vkill xcscope yasnippet popup auto-complete-ruby auto-complete-yasnippet auto-complete-clang ac-octave ac-dabbrev csv-mode dsvn gist git-emacs gnuplot-mode haml-mode highlight-parentheses jquery-doc json lua-mode magit magithub markdown-mode matlab-mode php-mode python-mode regex-tool ruby-mode ruby-block scss-mode sudo-save sunrise-commander sunrise-x-buttons sunrise-x-tree yaml-mode undo-tree )
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
