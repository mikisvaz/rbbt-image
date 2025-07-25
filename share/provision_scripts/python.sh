gem install pycall
pip install --upgrade pip
pip install ansible
pip install pandas numpy matplotlib

test -d /usr/local/miniconda3/ && chmod 777 -R /usr/local/miniconda3/

if [ -n "$CUSTOM_PIP" ]; then pip install $CUSTOM_PIP; fi

pip cache purge
