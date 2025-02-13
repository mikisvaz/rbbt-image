# Basic ubuntu setup
apt-get -y update
apt-get -y install software-properties-common

export DEBIAN_FRONTEND=noninteractive

apt-get -y install \
  ruby ruby-dev \
  git make gcc g++ cmake autotools-dev autoconf automake \
  zlib1g-dev libbz2-dev libreadline-dev \
  openssl \
  libxml2-dev libfontconfig1-dev \
  liblzma5 liblzma-dev libcurl4-openssl-dev \
  build-essential zlib1g-dev libssl-dev libyaml-dev libffi-dev \
  locales \
  bash openssh-client wget curl rsync libtokyocabinet-dev

apt-get -y install \
  python3 python3-pip python-is-python3

apt-get -y install \
  r-base r-base-dev

gem install rbbt-util rbbt-sources
gem install RubyInline

gem install specific_install hoe minitest
gem specific_install -l https://github.com/mikisvaz/lockfile.git
gem specific_install -l https://github.com/mikisvaz/rubyinline.git

rm -Rf /usr/lib/ruby/gems/*/doc /usr/lib/ruby/gems/*/cache

grep rbbt_environment /etc/rbbt_environment || echo "[ -f ~/.rbbt/etc/environment ] && . ~/.rbbt/etc/environment" >> "/etc/rbbt_environment"
grep rbbt_environment /etc/profile || echo echo "source /etc/rbbt_environment" >> /etc/profile


echo $CUSTOM_SYSTEM_PACKAGES | sed 's/,/\n/g' | xargs apt-get -y install
