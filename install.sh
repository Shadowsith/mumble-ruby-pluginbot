# complete description on:
# https://mumble-ruby-pluginbot.readthedocs.io/en/master/installation_howto.html#installationonyourown-label

# create a user botmaster
# login with botmaster and run this install.sh script

echo Create all needed directories and subdirectories for MPD and the bot
mkdir ~/src 
mkdir ~/logs
mkdir ~/src/certs
mkdir ~/music
mkdir ~/temp
mkdir -p ~/mpd1/playlists

echo Install and set up ruby and all needed libraries
gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
rvm autolibs disable
rvm requirements
rvm --create use @bots

echo Get and build mumble-ruby and ruby-mpd and other dependencies
cd ~/src
git clone https://github.com/dafoxia/mumble-ruby.git mumble-ruby
cd mumble-ruby
rvm use @bots
gem build mumble-ruby.gemspec
rvm @bots do gem install mumble-ruby-*.gem
rvm @bots do gem install ruby-mpd
rvm @bots do gem install crack

echo Download and set up celt-ruby and libcelt...
cd ~/src
git clone https://github.com/dafoxia/celt-ruby.git
cd celt-ruby
rvm use @bots
gem build celt-ruby.gemspec
rvm @bots do gem install celt-ruby
cd ~/src
git clone https://github.com/mumble-voip/celt-0.7.0.git
cd celt-0.7.0
./autogen.sh
./configure --prefix=/home/botmaster/src/celt
make
make install

echo Download and set up opus-ruby...
cd ~/src
git clone https://github.com/dafoxia/opus-ruby.git
cd opus-ruby
rvm use @bots
gem build opus-ruby.gemspec
rvm @bots do gem install opus-ruby

echo Download and set up mumble-ruby-pluginbot
cd ~/src
git clone https://github.com/MusicGenerator/mumble-ruby-pluginbot.git
cd mumble-ruby-pluginbot
cp templates/manage.conf ~/src/manage.conf
cp templates/override_config.yml ~/src/bot1_conf.yml

echo "Set up MPD (Music Player Daemon)"
cp ~/src/mumble-ruby-pluginbot/templates/mpd.conf ~/mpd1/mpd.conf

echo "Set up the script to start your bot(s) and MPD instance(s)"
cd ~/src/mumble-ruby-pluginbot
chmod u+x ~/src/mumble-ruby-pluginbot/scripts/manage.sh
chmod u+x ~/src/mumble-ruby-pluginbot/scripts/updater.sh

echo Install the youtube-dl script
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o ~/src/youtube-dl
chmod u+x ~/src/youtube-dl

echo Install script is done, edit ~/mpd/mpd.conf and start the bot with ~/src/mumble-ruby-pluginbot/scripts/manage.sh start
