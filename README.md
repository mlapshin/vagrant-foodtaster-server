# Vagrant Foodtaster Server

[![Gem Version](https://badge.fury.io/rb/vagrant-foodtaster-server.png)](http://badge.fury.io/rb/vagrant-foodtaster-server)

[Foodtaster](http://github.com/mlapshin/foodtaster) is a tool for
testing Chef cookbooks using RSpec and Vagrant. This Vagrant plugin
allows Core Foodtaster library to interact with Vagrant via simple DRb
protocol.

## Installation

    vagrant plugin install vagrant-foodtaster-server

## Usage

To start server:

    vagrant foodtaster-server [port number]

To terminate press Ctrl+C.

## Limitations

*   only VirtualBox provider is supported
*   only chef-solo provisioner is supported
