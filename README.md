# Environment Set Up.

We are going to set up the environment to develop to match the Linode server.

## Install a virtual box with **Ubuntu 16.04**
If you require help with this step follow the link bellow
<https://askubuntu.com/questions/142549/how-to-install-ubuntu-on-virtualbox>


## Install Ruby and all the required software.
For this section we will follow the tutorial from this website mostly <https://gorails.com/setup/ubuntu/16.04> but I will provide the code bellow with the correct versions of the software.

**Note:** It's important that the versions of the sotware get installed correctly, since I had dificulties in the past with version collitions. Also we are replicating all the settings from the Linode server.

Here is a summary of all the versions used:

Versions
```sh
ruby -v
ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-linux]

rails -v 
Rails 5.0.0.1

gem -v
2.5.1

bundler -v
Bundler version 1.13.2
```


### Install Ruby

Install dependencies

```sh
sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs
```
Install the version manager

```sh
sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.3.0
rvm use 2.3.0 --default
ruby -v
```

Install the Bundler
```sh
gem install bundler -v1.13.2
```

### Configure Git

Run the code one by one and replace the capital letters for your own to configure git.

```sh
git config --global color.ui true
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR@EMAIL.com"
ssh-keygen -t rsa -b 4096 -C "YOUR@EMAIL.com"
```

Grab the key with the command bellow and add it to git. 
```sh
cat ~/.ssh/id_rsa.pub
```

Check if it worked
```sh
ssh -T git@github.com
```

### Install Rails

We first install node and then we do Rails

```sh
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

gem install rails -v 5.0.0.1
```

### Setting up MYSQL (in case needed)

```sh
sudo apt-get install mysql-server mysql-client libmysqlclient-dev
```


### Setting up PstgreSQL (the one we are using)

```sh
sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-common
sudo apt-get install postgresql-9.5 libpq-dev
```

## The HACK!

I am not sure why but from time to time the system will just stop working. The usual rails commands "rake, rails, bundler..." will just not work. I tried several versions online of what the problem might be without any success.

Solution: run the command bellow everytime you open the terminal
```sh
source ~/.rvm/scripts/rvm
```
Otherwise Google the hell out of the problem :) 

Good Luck! 

