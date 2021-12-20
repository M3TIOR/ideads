#M3TIOR 2016

install:
	@if [ -d "~/.i3" ]; then\
		echo "Backing up previous settings...";\
		mkdir -p ~/.i3/backup;\
		mv ~/.i3/* ~/.i3/backup/;\
		echo "Done";\
	fi
	@mkdir -p ~/.i3/backup
	@cp -a ./files/* ~/.i3/
	@echo "M3TIOR's i3-wm theme has been installed!"

.PHONY: remove rebase install
remove:
	@if [ -e "~/.i3/backup" ]; then\
		find . ! -name 'backup' -exec rm -rf {} +;\
		mv ~/.i3/backup/* ~/.i3/;\
		rm -rf ~/.i3/backup;\
	fi # skzzt
	@echo "files succesfully restored";

rebase:
	@rm -rf ./files/*;
	@cp -a ~/.i3/* ./files/;
	@echo "Theme rebased!"
