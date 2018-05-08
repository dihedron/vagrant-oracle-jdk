#!/bin/bash

APT_QUIETNESS="" # can be -q or -qq

# SYSTEM UPDATE
echo "bringing system up-to-date..."
sudo apt-get $APT_QUIETNESS update
sudo apt-get -y $APT_QUIETNESS dist-upgrade
echo "... DONE!"

for version in "$@"; do
	if [ "$version" != "8" ] && [ "$version" != "9" ] && [ "$version" != "10" ]; then
		echo "unsupported JDK: $version!"
		continue
	fi 

	if [ "$version" = "8" ]; then
		echo "installing Oracle JDK${version} from WebUpd8 PPA..."			
		sudo add-apt-repository ppa:webupd8team/java	
	elif [ "$version" = "10" ]; then
		echo "installing Oracle JDK${version} from LinuxUprising PPA..."	
		sudo add-apt-repository ppa:linuxuprising/java
	fi
	
	echo oracle-java${version}-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
	sudo apt-get -y update
	sudo apt-get -y install oracle-java${version}-installer
	sudo apt-get -y install oracle-java${version}-set-default	
	echo "... DONE!"
done

# Oracle website (for direct download):
# http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/jdk-10.0.1_linux-x64_bin.tar.gz

update-java-alternatives --list

java -version

