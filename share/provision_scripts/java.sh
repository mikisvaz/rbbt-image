export JAVA_HOME=$(java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' | cut -f 2 -d "=" | awk '{$1=$1};1')
echo $JAVA_HOME
gem install rjb
