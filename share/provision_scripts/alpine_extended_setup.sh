# Basic alpine setup
apk add ruby ruby-dev  # Ruby
apk add git make gcc g++ cmake # Building
apk add bzip2 bzip2-dev zlib zlib-dev # Libs
apk add bash wget curl rsync gnu-libiconv  # Tools

gem install rbbt-util rbbt-sources
gem install RubyInline

gem install specific_install
gem specific_install -l https://github.com/mikisvaz/lockfile.git

rm -Rf /usr/lib/ruby/gems/*/doc /usr/lib/ruby/gems/*/cache

grep rbbt_environment /etc/rbbt_environment || echo "[ -f ~/.rbbt/etc/environment ] && . ~/.rbbt/etc/environment" >> "/etc/rbbt_environment"
grep rbbt_environment /etc/profile || echo echo "source /etc/rbbt_environment" >> /etc/profile

# Main alpine setup
apk add xvfb bison autoconf rsync curl openssl numactl zlib-dev zlib yaml-dev openssl xz-dev xz-libs libffi tcsh gawk pandoc libtbb-dev yaml libxml2-dev libxml2 shared-mime-info 


# Extended alpine setup
apk add openjdk17 R R-dev python3 python3-dev py3-pip ansible

apk add fontconfig fontconfig-dev harfbuzz fribidi harfbuzz-dev fribidi-dev jpeg jpeg-dev tiff tiff-dev cairo cairo-dev libxt-dev libxt

gem install pycall

export R_HOME=$(R RHOME)
export R_INCLUDE="$R_HOME/../../include/R"
cat >> /etc/rbbt_environment <<'EOF'
export R_HOME=$(R RHOME)
export R_INCLUDE="$R_HOME/../../include/R"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$R_HOME/lib"
export PATH="$PATH:$R_HOME/bin"
EOF
gem install rsruby -- --with-R-dir=$R_HOME --with-R-include=$R_INCLUDE

echo 'install.packages("Rserve", repos="http://www.rforge.net/")' | R --vanilla --quiet
gem install rserve-client

export JAVA_HOME=$(java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' | cut -f 2 -d "=" | awk '{$1=$1};1')
echo $JAVA_HOME
gem install rjb
