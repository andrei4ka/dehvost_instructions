1. The Main Server configuration
---skipped---
2. Devops system configuration

Information: http://docs.fuel-infra.org/fuel-dev/devops.html

The installation procedure can be implemented via PyPI in Python virtual environment (suppose you are using Ubuntu 12.04 or Ubuntu 14.04 preferred):
Before using it, please install the following required dependencies:
sudo apt-get install git postgresql postgresql-server-dev-all libyaml-dev libffi-dev python-dev python-libvirt python-pip qemu-kvm qemu-utils libvirt-bin libvirt-dev ubuntu-vm-builder bridge-utils

sudo apt-get update && sudo apt-get upgrade -y

Devops installation in virtualenv

Install packages needed for building python eggs
sudo apt-get install python-virtualenv libpq-dev libgmp-dev

Create virtualenv for the devops project
virtualenv --system-site-packages ~/fuel-devops-venv

Activate virtualenv and install devops package using PyPI.
pip install git+https://github.com/stackforge/fuel-devops.git@2.9.9 --proxy http://one.proxy.att.com:8888 --upgrade
Configuration
Basically devops requires that the following system-wide settings are configured:
Default libvirt storage pool is active (called ‘default’)
Current user must have permission to run KVM VMs with libvirt
PostgreSQL server running with appropriate grants and schema for devops
[Optional] Nested Paging is enabled


1. Configuring libvirt pool
Create libvirt’s pool
sudo virsh pool-define-as --type=dir --name=default --target=/var/lib/libvirt/images
sudo virsh pool-autostart default
sudo virsh pool-start default
2. Permissions to run KVM VMs with libvirt with current user
Give current user permissions to use libvirt (Do not forget to log out and log back in!)
sudo usermod $(whoami) -a -G libvirtd,sudo

3. Configuring Postgresql database
Set local peers to be trusted by default, create user and db and load fixtures.
sudo sed -ir 's/peer/trust/' /etc/postgresql/9.*/main/pg_hba.conf
sudo service postgresql restart
sudo -u postgres createuser -P fuel_devops
sudo -u postgres createdb fuel_devops -O fuel_devops
django-admin.py syncdb --settings=devops.settings
django-admin.py migrate devops --settings=devops.settings
4. Environment creation via Devops + Fuel_QA or Fuel_main
Clone GIT repository
https_proxy=one.proxy.att.com:8888 git clone https://github.com/stackforge/fuel-qa 
cd fuel-qa/

Install requirements
source <path>/fuel-devops-venv/bin/activate
pip install -r ./fuelweb_test/requirements.txt --upgrade


3. DEVOPS lab

How to prepare devops environment scripts:

SSH to host
Make a copy of scripts (replace <devops> with your name or att-uuid):

cd root; cp -r /root/devops_1/ /root/$user/

Check what CIDRs are taken for existing virtual networks:

./check_occupied_networks.sh
These networks are taken already:
10.30.0.0/16

Edit first two lines in the file userrc and set your username and CIDR to avoid conflicts.

How to run your devops environment creation:

Edit parameters (virtual nodes number, virtual HW, systest name to run, etc):
vim /root/$user/testsrc

Run system tests:
/root/$user/run.sh

Ending of installation:

If you see traceback, please do not panic. Just follow the instructions.

 
Traceback (most recent call last):
…cut...
...cut...
----------------------------------------------------------------------
Ran 1 test in 1332.172s

FAILED (failures=1)
Launch VM’s

List the vm’s
virsh list --all
 Id    Name                           State
----------------------------------------------------
 16    devops_2-venv_system_test_admin running
 17    devops_2-venv_system_test_slave-01 running
 18    devops_2-venv_system_test_slave-02 running
 19    devops_2-venv_system_test_slave-03 running
 20    devops_2-venv_system_test_slave-04 running
 21    devops_1-venv_system_test_admin running
 22    devops_1-venv_system_test_slave-01 running
 23    devops_1-venv_system_test_slave-02 running
 24    devops_1-venv_system_test_slave-03 running
 25    devops_1-venv_system_test_slave-04 running

And run vm’s you need: 
root@devops-host:~/devops_1# virsh start devops_2-venv_system_test_admin
Domain devops_2-venv_system_test_admin started

root@devops-host:~/devops_1# virsh start devops_2-venv_system_test_slave-01
Domain devops_2-venv_system_test_slave-01 started

root@devops-host:~/devops_1# virsh start devops_2-venv_system_test_slave-02
Domain devops_2-venv_system_test_slave-02 started

root@devops-host:~/devops_1# virsh start devops_2-venv_system_test_slave-03
Domain devops_2-venv_system_test_slave-03 started

root@devops-host:~/devops_1# virsh start devops_2-venv_system_test_slave-04
Domain devops_2-venv_system_test_slave-04 started

Apply firewall rules

./fix_firewall.sh

---------------USER INFORMATION--------------------
Now FUEL should be available by:
ip:3080
Now your FUEL environment accessible by:
ssh root@ip -p 3022 //login:root pass:r00tme

MOS network parameters:
Admin network: 10.30.0.0/24
Public network: 10.30.1.0/24, Gateway: 10.30.1.1
DNS servers: dnss
NTP servers: ntpss
---------------USER INFORMATION--------------------
4. USER manual for MOS 6.1 configuration in DEVOPS environment

According the environment configuration given to you:

---------------USER INFORMATION--------------------
Now FUEL should be available by:
http://ip:3080
Now your FUEL environment accessible by:
ssh root@ip -p 3022 //login:root pass:r00tme

MOS network parameters:
Admin network: 10.30.0.0/24
Public network: 10.30.1.0/24, Gateway: 10.30.1.1
DNS servers: dnss
NTP servers: ntpss
---------------USER INFORMATION--------------------

Accessing to Horizon interface

make ssh connection to your virtual environment
ssh -L 8888:10.30.1.2:80 root@ip -p 3022

Access to Horizon using link: http://127.0.0.1:8888/
