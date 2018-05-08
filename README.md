# Creating a VM with the Oracle JDK 8 and/or 10

This projects contains the __Vagrant__ recipe to create a VM with one or more versions of the __Oracle JDK__.

## Creating the VM

In order to create the VM you must have installed ```vagrant```, which is made freely available from Hashicorp on [their website](https://www.vagrantup.com/).

Next, clone this repository or download it to a directory of your choice and from it run the following at a command propt:
```bash
$> vagrant up
```
Vagrant will create a new virtual machine based on Ubuntu Xenial 16.04.4 LTS (or Ubuntu Bionic 18.04) and then it will run the ```setup.sh``` script which:
1. updates the system
2. accepts the license agreement
3. adds the ```webupd8``` or the ```linuxuprising/java``` repository
4. installs the Oracle JDK 8 or 10 metapackage, which in its turn
5. downloads and installs the Oracle JDK 8 or 10 from the Oracle website
6. sets the newly installed ```java``` as the default alternative

In order to select one (or more) JDKs, open the ```Vagrantfile``` and sepcify the desired versions on the lines that read
```bash
	# JDK version, can be one or more of 8 and 10; the last one is set as default
	sh.args = ["8", "10"] 
```
The last one will be set as the default.

## Operating from behind a proxy

In order to support a scenario where Vagrant is running behind a proxy, e.g. when running in an enterprise environment, the ```Vagrantfile``` includes a reference to the ```vagrant-proxyconf``` [plugin](https://github.com/tmatilai/vagrant-proxyconf); in order to enable it and have Vagrant automatically install it if lacking, replace this line in the ```Vagrantfile```:
```bash  
    required_plugins = %w( vagrant-vbguest vagrant-disksize )
```  
with this:
```bash
   required_plugins = %w( vagrant-vbguest vagrant-disksize vagrant-proxyconf )
```
then tweak the proxy section:
```bash
    if Vagrant.has_plugin?("vagrant-proxyconf")
        # let CNTLM listen on the vboxnet interface, set your localhost
        # as the proxy for VirtualBox machines, so APT can get through
        # (tweak as needed!)
        config.proxy.http     = "http://192.168.33.1:3128/"
        config.proxy.https    = "http://192.168.33.1:3128/"
        config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
    end
```
as needed; in the example above, a local [CNTLM proxy](http://cntlm.sourceforge.net/) was installed and configured on the host machine to listen on the ```vboxnet0``` NIC. Please note that for security reasons, by default CNTLM only listens on the loopback interface; unless explicitly told to do otherwise
```bash
Listen		127.0.0.1:3128             # loopback
Listen		192.168.33.1:3128          # virtualbox
```
it is not reachable by VirtualBox VMs.

## Using the VM

In order to use the VM to run your Java applications, you simply need to log into it:
```bash
$> vagrant ssh
```
and then use the command line to run any java-related commands. 

If you need to share files between the host (your PC) and the VM you can place them in the same directory where ```Vagrantfile``` and ```setup.sh``` are, because ```vagrant``` makes sure it is mounted as a shared folder on the guest VM under ```/vagrant```. This is an easy way to move Java sources and binaries back and forth.

## Feedback and contributions

...are obviously exceedingly welcome; please use issues and pull requests to contribute back.