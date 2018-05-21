.PHONY: clean veryclean test enter install docs
export PBR_VERSION=$(shell cat VERSION)
htmldoc=html
formats=zip
ifeq ($(OS),Windows_NT)
  formats=msi,zip
else
  RPMBIN := $(shell basename `basename rpm`)
  ifeq ($(RPMBIN),rpm)
    formats=rpm,zip
  endif
endif

dist:
	@python setup.py bdist --formats=$(formats)

install:
	@pip install .

install-reqs:
	@pip install -r requirements.txt

uninstall:
	@pip uninstall lmaps --yes

test:
	@nosetests

debug:
	@nosetests --pdb

clean:
	@rm -rf *.tmp *.pyc *.egg-info *.egg dist build examples/tests/ansible_playbook/*.retry .eggs `ls | grep -E 'lmaps-[0-9]+\.[0-9]+\.[0-9]+'`

veryclean: clean
	@vagrant destroy --force; rm -rf .vagrant buildenv; find lmaps -type f -name '*\.pyc' -delete; rm -rf `ls | grep -E 'lmaps\-'`

.vagrant/up.flag:
	@vagrant up && touch .vagrant/up.flag

vagrant-up: .vagrant/up.flag

enter: vagrant-up
	@vagrant ssh -c 'sudo su'

sphinx:
	@cd .sphinx; make singlehtml; make html; make man; make text

man_setup:
	@cp -rf .sphinx/_build/man ./

docs_setup:
	@cd docs; \
	  rm -rf ./*; \
	  cp -rf ../.sphinx/_build/$(htmldoc)/* ./; \
	  mv _static static; \
	  find . -type f -exec grep -Iq . {} \; -and -print | \
	    xargs -I {} sed -i 's/_static/static/g' {}

docs: sphinx docs_setup man_setup

distribute_pypi:
	@python setup.py sdist upload -r lmaps

pypi: distribute_pypi
