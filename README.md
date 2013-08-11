# Vagrant Foodtaster Server

Foodtaster is a tool for testing Chef cookbooks using RSpec and
Vagrant. This plugin allows Foodtaster to interact with Vagrant via
simple DRb protocol.

Foodtaster is in early development stage, so don't expect too much
from code and functionality.

## Installation

First, install [sahara](http://github.com/jedi4ever/sahara/) plugin for snapshot support:

    vagrant plugin install sahara

Then, install Foodtaster Server:

    vagrant plugin install vagrant-foodtaster-server

## Usage

To start server:

    vagrant foodtaster-server

To terminate press Ctrl+C.

## Limitations

*   only VirtualBox provider is supported
*   only chef-solo provisioner is supported