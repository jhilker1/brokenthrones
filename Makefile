dev:
	@echo "building dev site..."; emacs.exe -Q --batch -l build-site.el --funcall 'jh/publish-org:dev' && npm run build-css:dev && emacs.exe -Q --batch -l build-site.el --funcall 'jh/publish-assets:dev'

css: tailwind.css tailwind.config.js
	@echo "Building CSS"; npm run build-css:dev && emacs.exe -Q --batch -l build-site.el --funcall 'jh/publish-assets:dev'

server:
	python3 -m http.server --directory=public 8080
