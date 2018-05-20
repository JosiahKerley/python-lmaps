Lightweight Management and Provisioning Service
===============================================
lMaPS provides a simple way the use schema defined "instances" that can
be passed to an underlying configuration management system.  This will
provide the ability to allow desperate systems to use a common namespace
application scheme to interact directly with configuration management
systems.

## Installation
```
pip install lmaps
```

## Overview
![System Architecture](.readmeimg/sysarch.png)

## Example use cases

### Using lMaPS to reconfigure a host using using ansible
In this example, an ansible playbook can be written with the expectation
that a vars file containing the proper data structure will have the
correct information to turn up a given service.

Let's assume the following playbook /my-playbook.yaml:
```
- name: An example playbook
  hosts: localhost
  connection: local
  vars:
    some_structure:
      - message: This is one
      - message: This is two
      - message: This is three
  tasks:
    - debug:
        msg: '{{ item.message }}'
      with_items: '{{ some_structure }}'
```
Using this, a unit can be defined to call it via the `ansible_playbook`
unit handler.

We define the unit on the host as /etc/lmaps/units/some_example.yaml:
```
---
meta:
  name: some_example
  data_type: YamlKeyList
  store_key: some_structure
  store_root: /some/dir/to/store/instances
handler:
  name: ansible_some_example
  type: ansible_playbook
  args:
    playbook: /my-playbook.yaml
  params:
    additionalProperties: false
    properties:
      message:
        type: string
```

Now when the daemon is run (`lmaps -D`), we can create instances.

With no instances defined, ansible will use the default vars declared
in the playbook, but if we created the following as hello_world.yaml:
```
message: Hello world!
```
and created it via:
`lmaps --create --file hello_world.yaml --unit some_example`
then when applied, the loop will get the following output:

[![asciicast](https://asciinema.org/a/AZC5wiglgxG5Vt83a1YBsOhyP.png)](https://asciinema.org/a/AZC5wiglgxG5Vt83a1YBsOhyP)


