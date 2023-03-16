[[ -f /usr/bin/gzip ]] || ln -s /bin/gzip /usr/bin/gzip # Fix for cpan
cpan -i App::cpanminus
