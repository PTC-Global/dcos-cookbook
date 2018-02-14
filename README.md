[![Build Status](https://travis-ci.org/chef-partners/dcos-cookbook.svg?branch=master)](https://travis-ci.org/chef-partners/dcos-cookbook)

Description
===========

Manage deployment and configuration of underlying Mesosphere DC/OS installation.

Requirements
------------

Only Red Hat or CentOS 7.x are currently supported.

Usage
==========

The behavior of this cookbook is managed by attributes documented in the [attributes file](attributes/default.rb).
The `node['dcos']['dcos_role']` attribute controls the DC/OS role to apply to the node (default is `master`). The
`node['dcos']['config']['master_list']` must be set when `node['dcos']['config']['master_discovery']` is set to
`static` to specify the list of DC/OS master node IPv4 addresses to connect at startup (this must be an odd number
of masters and cannot be changed, later).

This cookbook uses the EarlyAccess channel, by default. Setting `node['dcos']['dcos_version']` to `stable` will
install the latest stable version of DC/OS (currently `1.9.3`).

Roles
----------

You can create a Chef Role and apply it to nodes as necessary to specify `master`, `slave` and `slave_public`, as
appropriate. Any additional configuration should be set as override attributes in an Environment to ensure that
all nodes receive those global settings.

### Example Role dcos_master.rb ###
````ruby
name "dcos_master"
description "DC/OS master role"
run_list "recipe[dcos]"
default_attributes "dcos" => {
    "dcos_role" => "master",
    "config" => {
        "master_list" => [ "10.0.2.10" ]
    }
}
````

### Example Role dcos_slave.rb ###
````ruby
name "dcos_slave"
description "DC/OS slave role"
run_list "recipe[dcos]"
default_attributes "dcos" => {
    "dcos_role" => "slave",
    "config" => {
        "master_list" => [ "10.0.2.10" ]
    }
}
````

Recipe
=======

default
-------

Installs the prerequisites for the Mesosphere DC/OS installation, including packages, and groups.
Docker with OverlayFS is installed and enabled if `node['dcos']['manage_docker']` is set to true,
which is the default. Next, the recipe downloads and runs the installation package with the
settings configured by the attributes under `node['dcos']['config']`.


Resource
========

dcos_user
---------

Defines a DC/OS user, with e-mail and name.

### Example dcos_user ###
````ruby
dcos_user 'user@domain.com' do
  user_name 'Joan User'
  email 'user@domain.com'
end
````

Testing
=======

ChefSpec
--------
There is basic coverage for the default recipe.

InSpec
------
TBD

Test Kitchen
------------
The included [.kitchen.yml](.kitchen.yml) runs the default master deployment in a generic fashion.
The included [.kitchen.local.yml.example](.kitchen.local.yml.example) shows alternate settings for
running multi-master with slaves on GCE (you will have to rename and update accordingly).

License and Author
==================

Author:: Matt Ray (<matt@chef.io>)

Copyright 2016 Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
