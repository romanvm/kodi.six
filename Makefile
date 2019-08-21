ENVS := flake8,py27,py36
export PYTHONPATH := $(CURDIR)/script.module.kodi-six/libs
addon_xml := script.module.kodi-six/addon.xml

# Collect information to build as sensible package name
name = $(shell xmllint --xpath 'string(/addon/@id)' $(addon_xml))
version = $(shell xmllint --xpath 'string(/addon/@version)' $(addon_xml))
git_branch = $(shell git rev-parse --abbrev-ref HEAD)
git_hash = $(shell git rev-parse --short HEAD)

zip_name = $(name)-$(version)-$(git_branch)-$(git_hash).zip
include_paths = $(name)
exclude_files = \*.new \*.orig \*.pyc \*.pyo
zip_dir = $(name)/

blue = \e[1;34m
white = \e[1;37m
reset = \e[0m

.PHONY: test

all: test zip

package: zip

test: sanity unit

sanity: tox pylint addon

tox:
	@echo -e "$(white)=$(blue) Starting sanity tox test$(reset)"
	tox -q -e $(ENVS)

pylint:
	@echo -e "$(white)=$(blue) Starting sanity pylint test$(reset)"
	pylint $(name)/libs/kodi_six/

addon: clean
	@echo -e "$(white)=$(blue) Starting sanity addon tests$(reset)"
	kodi-addon-checker $(name) --branch=leia

unit:
	@echo -e "$(white)=$(blue) Starting unit tests$(reset)"
	python -m unittest discover

zip: clean
	@echo -e "$(white)=$(blue) Building new package$(reset)"
	@rm -f ../$(zip_name)
	zip -r $(zip_name) $(include_paths) -x $(exclude_files)
	@echo -e "$(white)=$(blue) Successfully wrote package as: $(white)$(zip_name)$(reset)"

clean:
	@echo -e "$(white)=$(blue) Cleaning cache files$(reset)"
	find $(name) -name '*.pyc' -type f -delete
	find $(name) -name '__pycache__' -type d -delete
	rm -rf .pytest_cache/ .tox/ *.log
