(setq user-emacs-directory (file-truename "./.emacs.d/"))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(straight-use-package '(org :type git
       :repo "https://code.orgmode.org/bzg/org-mode.git"
       :local-repo "org"
       :depth full
       :pre-build (straight-recipes-org-elpa--build)
       :build (:not autoloads)
       :files (:defaults "lisp/*.el" ("etc/styles/" "etc/styles/*"))))

(straight-use-package '(org-contrib))

(use-package ox-plumhtml
  :straight (:host github :repo "C-xC-c/ox-plumhtml"))

(use-package htmlize)

(use-package esxml
  ;:straight (:host github :repo "tali713/esxml")
  :ensure t)

(use-package org-roam
  :custom 
  (org-roam-directory (file-truename "./org/"))
  (org-roam-db-location "./.org-roam.db")
  :config
  (cl-defmethod org-roam-node-slug ((node org-roam-node))
    "Return the slug of NODE."
    (let ((title (org-roam-node-title node))
          (slug-trim-chars '(;; Combining Diacritical Marks https://www.unicode.org/charts/PDF/U0300.pdf
                             768 ; U+0300 COMBINING GRAVE ACCENT
                             769 ; U+0301 COMBINING ACUTE ACCENT
                             770 ; U+0302 COMBINING CIRCUMFLEX ACCENT
                             771 ; U+0303 COMBINING TILDE
                             772 ; U+0304 COMBINING MACRON
                             774 ; U+0306 COMBINING BREVE
                             775 ; U+0307 COMBINING DOT ABOVE
                             776 ; U+0308 COMBINING DIAERESIS
                             777 ; U+0309 COMBINING HOOK ABOVE
                             778 ; U+030A COMBINING RING ABOVE
                             780 ; U+030C COMBINING CARON
                             795 ; U+031B COMBINING HORN
                             803 ; U+0323 COMBINING DOT BELOW
                             804 ; U+0324 COMBINING DIAERESIS BELOW
                             805 ; U+0325 COMBINING RING BELOW
                             807 ; U+0327 COMBINING CEDILLA
                             813 ; U+032D COMBINING CIRCUMFLEX ACCENT BELOW
                             814 ; U+032E COMBINING BREVE BELOW
                             816 ; U+0330 COMBINING TILDE BELOW
                             817 ; U+0331 COMBINING MACRON BELOW
                             )))
      (cl-flet* ((nonspacing-mark-p (char)
                                    (memq char slug-trim-chars))
                 (strip-nonspacing-marks (s)
                                         (ucs-normalize-NFC-string
                                          (apply #'string (seq-remove #'nonspacing-mark-p
                                                                      (ucs-normalize-NFD-string s)))))
                 (cl-replace (title pair)
                             (replace-regexp-in-string (car pair) (cdr pair) title)))
        (let* ((pairs `(("[^[:alnum:][:digit:]]" . "-") ;; convert anything not alphanumeric
                        ("--*" . "-")                   ;; remove sequential underscores
                        ("^-" . "")                     ;; remove starting underscore
                        ("-$" . "")))                   ;; remove ending underscore
               (slug (-reduce-from #'cl-replace (strip-nonspacing-marks title) pairs)))
          (downcase slug))))))

(use-package org-special-block-extras
  :ensure t
  :init
  (org-special-block-extras-mode t)
  :hook (org-export-before-parsing-hook 'o--support-special-blocks-with-args))

(use-package s)

(use-package dash)

(use-package citeproc)

;(use-package oc :ensure nil :straight nil)
(use-package citeproc-org)

(setq org-cite-global-bibliography '("./biblio/references.bib"))

(setq org-cite-export-processors '((t csl))
      org-cite-csl-styles-dir "./biblio/styles/"
      org-cite-csl-locales-dir "./biblio/locales/")

(use-package citar
   :custom
  (citar-bibliography '("./biblio/references.bib"))
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  :config
  (setq citar-citeproc-csl-style "chicago-note.csl"))

(setq make-backup-files nil)

(setq org-id-link-to-org-use-id t)
;; (org-roam-db-autosync-mode)

(setq org-id-extra-files (org-roam-list-files))

(defvar site-attachments
  (regexp-opt '("jpg" "jpeg" "gif" "png" "svg"
                "ico" "cur" "css" "js" "woff" "html" "pdf" "otf" "ttf"))
  "File types that are published as static files.")

(setq jh/site-title "Broken Thrones"
      jh/site-url "https://brokenthrones.jhilker.com/"
      jh/site-tagline "A world of historical fantasy awaits."
      jh/site-banner "img/brokenthronesbanner.png")

(setq jh/site-socials 
      (esxml-to-xml 
       `(div ((class . "mt-2 flex space-x-2.5 text-xl"))
             (a ((href . "https://jhilker.com/" )
                 (class . "transition-colors duration-75 hover:text-heraldic-blue"))
                (i ((class . "fas fa-globe"))""))
             (a ((href . "https://gitlab.com/jhilker" )
                 (class . "transition-colors duration-75 hover:text-heraldic-blue"))
                (i ((class . "fab fa-gitlab"))""))
             (a ((href . "https://github.com/jhilker1" )
                 (class . "transition-colors duration-75 hover:text-heraldic-blue"))
                (i ((class . "fab fa-github"))""))
             (a ((href . "https://linkedin.com/in/jhilker" )
                 (class . "transition-colors duration-75 hover:text-heraldic-blue"))
                (i ((class . "fab fa-linkedin"))""))
             (a ((href . "https://dev.to/jhilker" )
                 (class . "transition-colors duration-75 hover:text-heraldic-blue"))
                (i ((class . "fab fa-dev"))""))
             (a ((href . "https://codepen.io/hilkerj" )
                 (class . "transition-colors duration-75 hover:text-heraldic-blue"))
                (i ((class . "fab fa-codepen"))""))
             (a ((href . "https://jhilker.com/blog/feed.xml" )
                 (class . "transition-colors duration-75 hover:text-heraldic-blue"))
                (i ((class . "fas fa-rss"))""))
             (a ((href . "mailto:jacob.hilker2@gmail.com" )
                 (class . "transition-colors duration-75 hover:text-heraldic-blue"))
                (i ((class . "fas fa-envelope"))"")))))

(setq org-publish-use-timestamps-flag t
      org-publish-timestamp-directory "./.org-cache/"
      org-export-with-section-numbers nil
      org-export-with-broken-links 'mark
      org-export-use-babel nil
      org-export-with-smart-quotes t
      org-export-with-sub-superscripts nil
      org-export-with-tags 'not-in-toc
      org-export-with-toc t
      org-html-link-use-abs-url t
      org-id-track-globally t
      org-id-locations-file-relative t
      org-id-locations-file "./.org-id-locations")

(defun jh/org-html-header ()
  (concat 
   (esxml-to-xml 
    `(header ((class . "z-10 items-center bg-gray-200 grid-in-header"))
             (div ((class . "flex items-center justify-between h-[52px] 2xl:h-[62px]"))
                  (nav ((class . "items-center hidden h-full space-x-3 lg:flex"))
                       (a ((class . "block h-full p-3 2xl:p-4 transition duration-100 hover:bg-gray-400")
                           (href . "/")) "Home")
                       (a ((class . "block h-full p-3 2xl:p-4 transition duration-100 hover:bg-gray-400")
                           (href . "/faq/")) "FAQ")))))))

(defun jh/org-html-fixed-sidebar ()
  (concat 
   (esxml-to-xml 
    `(aside ((class . "flex-col items-center hidden bg-slate-300 dark:bg-slate-700 dark:text-gray-100 grid-in-sidebar lg:flex"))
                      (span ((class . "p-2 font-semibold uppercase")) "Broken Thrones Wiki")
                           (img ((src . ,(concat jh/site-url "img/jhilker.jpg"))
                                 (class . "object-cover rounded-full h-44 w-44 object-right")))
                           (p ((class . "p-2 mx-auto mt-2 text-sm text-center text-gray-700")) ,jh/site-tagline)
                           ,jh/site-socials))))

(defun jh/org-html-template (content info)
  "Returns the HTML template for my site"
  (let((page-type (cdar (org-collect-keywords '("PAGETYPE")))))
  (concat 
   "<!DOCTYPE html>"
   (esxml-to-xml
    `(html ()
           (head ()
           (title () ,(concat (org-export-data (plist-get info :title) info) " - Broken Thrones"))
           (meta ((author . "Jacob Hilker")))
           (meta ((charset . "utf-8")))
           (meta ((name . "viewport")
                  (content . "width=device-width, initial-scale=1.0")))
           (link ((rel . "stylesheet")
                  (href . ,(concat jh/site-url "css/style.css"))))
           (link ((rel . "stylesheet")
                  (href . "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css")
                  (integrity . "sha512-iBBXm8fW90+nuLcSKlbmrPcLa0OT92xO1BIsZ+ywDWZCvqsWgccV3gFoRBv0z+8dLJgyAHIhR35VZc2oM/gI1w==")
                  (crossorigin . "anonymous"))))
           
    (body ()
          (div ((class . "grid h-screen grid-areas-mobile grid-rows-layout lg:grid-areas-desktop grid-cols-layout"))
               ,(jh/org-html-header)
               ,(jh/org-html-fixed-sidebar)
               (main ((class . "p-3 grid-in-main max-w-none prose prose-base prose-manuscript bg-[#f0e3d1]"))
                     ,(if (equal nil page-type)
                          (esxml-to-xml
                         `(h1 () ,(org-export-data (plist-get info :title) info)))
                        (esxml-to-xml 
                         `(figure ((class . "not-prose -mx-3 -mt-3"))
                                  (img ((src . ,(concat jh/site-url jh/site-banner)))))))
                     ,content))))))))

(o-defblock character (name nil) (image nil born nil died nil)
  "Returns an `HTML' infobox for a character."
  (esxml-to-xml
   `(aside ((class . "infobox not-prose"))
           (header ((class . "text-lg font-bold text-center text-white bg-blue-500")) ,name)
           (figure ()
                   (img ((src . ,image))))
           (table ((class . "w-full"))
                  (tr ()
                      (td ((class . "first:!pl-2 first:font-bold")) "Born")
                      (td ((class . "!pr-0 !py-0")) ,born))))))

(defun jh/sitemap-format-entry (entry style project)
  "Format sitemap `entry' in `project' according to `style'."
  (format "[[%s][%s]]"
          (if (string= "index" (file-relative-name (file-name-sans-extension entry)))
              (concat jh/site-url "/")
          (concat jh/site-url (file-relative-name (file-name-sans-extension entry)) "/"))
          (org-publish-find-title entry project)))

(defun dw/org-html-link (link contents info)
  "Removes file extension and changes the path into lowercase file:// links."
  (when (string= 'id (org-element-property :type link))
    (let*((node-id (org-element-property :path link))
          (source-node (org-roam-node-from-id node-id))
          (source-file (org-roam-node-file source-node)))
      (org-element-put-property link :path (concat jh/site-url (file-name-sans-extension source-file)))))

    (let ((exported-link (org-export-custom-protocol-maybe link contents 'html info)))
    (cond
     (exported-link exported-link)
     ((equal contents nil)
      (format "<a href=\"%s\">%s</a>"
              (org-element-property :raw-link link)
              (org-element-property :raw-link link)))
     (t (org-export-with-backend 'slimhtml link contents info)))))

(org-export-define-derived-backend 'wiki-html
    'plumhtml
  :translate-alist
  '((template . jh/org-html-template)
    (link . dw/org-html-link))
   :options-alist
  '((:page-type "PAGE-TYPE" nil nil t)
    (:bibliography "BIBLIOGRAPHY" nil nil newline)))

(defun get-article-output-path (org-file pub-dir)
  (let ((article-dir (concat pub-dir
                             (downcase
                              (file-name-as-directory
                               (file-name-sans-extension
                                (file-name-nondirectory org-file)))))))

    (if (string-match "\\/index.org$" org-file)
        pub-dir
        (progn
          (unless (file-directory-p article-dir)
            (make-directory article-dir t))
          article-dir))))

(defun org-html-publish-to-html (plist filename pub-dir)
  "Publish an org file to HTML, using the FILENAME as the output directory."
  (let ((article-path (get-article-output-path filename pub-dir)))
    (cl-letf (((symbol-function 'org-export-output-file-name)
               (lambda (extension &optional subtreep pub-dir)
                 (concat article-path "index" extension))))
      (org-publish-org-to 'wiki-html
                          filename
                          (concat "." (or (plist-get plist :html-extension)
                                          "html"))
                          plist
                          article-path))))

(setq org-publish-project-alist 
      `(
        ("org:static"
         :base-directory "./org/"
         :recursive t
         :base-extension ,site-attachments
         :publishing-function org-publish-attachment
         :publishing-directory "./public")
        ("articles"
         :base-directory "./org/"
         :base-extension "org"
         :publishing-function org-html-publish-to-html
         :publishing-directory "./public"
         :auto-sitemap t
         :sitemap-title "Wiki Sitemap"
         :sitemap-format-entry jh/sitemap-format-entry
         :exclude "org-draft")
      ("org" :components ("org:static" "articles"))
      ("site:static"
       :base-directory "./static/"
       :recursive t
       :base-extension ,site-attachments
       :publishing-function org-publish-attachment
       :publishing-directory "./public")))

(defun jh/publish-org:dev ()
  (let((jh/site-url "http://localhost:8080/"))
    (org-publish "org" t)))
   
(defun jh/publish-assets:dev ()
  (let((jh/site-url "http://localhost:8080/"))
    (org-publish "site:static" t)))

(defun jh/publish-org ()
  (org-publish "org" t))


(defun jh/publish-assets ()
  (org-publish "site:static" t))
