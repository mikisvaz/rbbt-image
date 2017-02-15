FROM ubuntu
USER root
# START PROVISION
ADD provision.sh /tmp/provision.sh
RUN /bin/bash /tmp/provision.sh
# END PROVISION
USER rbbt
ENV HOME /home/rbbt
