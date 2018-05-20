.PHONY: clean veryclean test enter install docs
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
	@pip freeze | grep lmaps | xargs -I {} pip uninstall {} --yes

test:
	@nosetests

debug:
	@nosetests --pdb

clean:
	@rm -rf *.tmp *.pyc *.egg-info *.egg dist build examples/tests/ansible_playbook/*.retry .eggs `ls | grep -E 'lmaps-[0-9]+\.[0-9]+\.[0-9]+'`

veryclean: clean
	@vagrant destroy --force; rm -rf .vagrant buildenv

.vagrant/up.flag:
	@vagrant up

vagrant-up: .vagrant/up.flag

enter: vagrant-up
	@vagrant ssh -c 'sudo su'

sphinx:
	@cd .sphinx; make html; make man; make text

docs_setup:
	@cd docs; cp -rf ../.sphinx/_build/text/*.txt ./; cp -rf ../.sphinx/_build/html ./; cp -rf ../.sphinx/_build/man ./

docs: sphinx docs_setup