FROM ubuntu
USER root
ADD provision.sh /tmp/provision.sh
RUN /bin/bash /tmp/provision.sh
USER rbbt
