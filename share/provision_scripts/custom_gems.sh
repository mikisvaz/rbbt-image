for g in $(echo $CUSTOM_GEMS | sed 's/,/\n/g' | grep '/'); do
    echo $g | sed 's/^/https:\/\/github.com\//' | xargs gem specific_install -l
done
echo $CUSTOM_GEMS | sed 's/,/\n/g' | grep -v '/' | xargs gem install
