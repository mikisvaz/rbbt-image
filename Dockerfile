FROM ubuntu:cosmic
USER root
# START PROVISION
ADD provision.sh /tmp/provision.sh
RUN /bin/sh +x /tmp/provision.sh
# END PROVISION
#USER rbbt
#ENV HOME /home/rbbt
