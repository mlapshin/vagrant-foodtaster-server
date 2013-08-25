# Vagrant Foodtaster Server

(Foodtaster)[http://github.com/mlapshin/foodtaster] is a tool for
testing Chef cookbooks using RSpec and Vagrant. This Vagrant plugin
allows Foodtaster to interact with Vagrant via simple DRb protocol.

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