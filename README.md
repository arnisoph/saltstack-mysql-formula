# mysql-formula

Salt Stack Formula to set up and configure MySQL

## NOTICE BEFORE YOU USE

* This formula aims to follow the conventions and recommendations described at [http://docs.saltstack.com/topics/conventions/formulas.html](http://docs.saltstack.com/topics/conventions/formulas.html)

## TODO

Define tasks to complete:

* None

## Instructions

1. Add this repository as a [GitFS](http://docs.saltstack.com/topics/tutorials/gitfs.html) backend in your Salt master config.

2. Configure your Pillar top file (`/srv/pillar/top.sls`), see pillar.example

3. Include this Formula within another Formula or simply define your needed states within the Salt top file (`/srv/salt/top.sls`).

## Available states

### mysql.client

Installs and configures the MySQL client

### mysql.server

Installs and configures the MySQL server

## Additional resources

None

## Formula Dependencies

* salt.minion

## Compatibility

*DOES* work on:

* GNU/ Linux Debian Wheezy
