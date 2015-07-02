FROM ubuntu:latest
ADD provision.sh /tmp/provision.sh
RUN chmod +x /tmp/provision.sh
RUN /tmp/provision.sh
