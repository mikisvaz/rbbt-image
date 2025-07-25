yum -y install gcc14 gcc-c++ wget openssl libyaml-devel libyaml rsync zlib-devel libzip-devel readline-devel tar git ruby ruby-devel bzip2-devel shadow-utils cmake pkg-config

echo $CUSTOM_SYSTEM_PACKAGES | sed 's/,/\n/g' | xargs yum -y install

yum -y groupinstall "Development Tools"

gem install rbbt-util rbbt-sources
gem install RubyInline

gem install specific_install hoe minitest
gem specific_install -l https://github.com/mikisvaz/lockfile.git
gem specific_install -l https://github.com/mikisvaz/rubyinline.git

rm -Rf /usr/lib/ruby/gems/*/doc /usr/lib/ruby/gems/*/cache

grep rbbt_environment /etc/rbbt_environment || echo 'for f in $(rbbt find etc/environment -w all); do source "$f"; done' >> "/etc/rbbt_environment"
grep rbbt_environment /etc/profile || echo "source /etc/rbbt_environment" >> /etc/profile

echo '/usr/local/lib' | tee /etc/ld.so.conf.d/local.conf
ldconfig
