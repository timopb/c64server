FROM debian

ARG ADDITIONAL_PACKAGES
ARG USER
ARG PASSWORD

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y telnetd ed $ADDITIONAL_PACKAGES && rm -rf /var/lib/apt/lists/*

# Setup user / group / password
RUN addgroup --gid 64128 $USER && adduser --uid 64128 --gid 64128 --shell /bin/sh $USER
RUN echo "$USER:$PASSWORD"|chpasswd

# Branding (motd, issue, login banner)
COPY ./system/motd /etc/motd
COPY ./system/issue /etc/issue
COPY ./system/issue /etc/issue.net
COPY ./system/login /etc/pam.d/login
COPY ./system/profile /etc/profile

# Fix permissions in case of files were checked out to windows
RUN chmod 644 /etc/issue
RUN chmod 644 /etc/issue.net
RUN chmod 644 /etc/motd
RUN chmod 644 /etc/pam.d/login
RUN chmod 644 /etc/profile

# make container usable by non root users
RUN chmod 4755 /bin/login

CMD inetd -i
