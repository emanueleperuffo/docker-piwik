FROM emanueleperuffo/baseimage-debian:latest
MAINTAINER Emanuele Peruffo <info@emanueleperuffo.com>

# This is intended to sit behind a web server proxy
# which will take good care of ssl

ENV HOME /root
ADD . /build

ENV DB_HOST mysql.example.com
ENV DB_USER piwik
ENV DB_PASSWORD pass
ENV DB_NAME piwik
ENV PIWIK_SALT secret

ENV SMTP_PORT = "587"
ENV SMTP_HOST = smtp.example.com
ENV SMTP_AUTH = Plain
ENV SMTP_USER info@example.com
ENV SMTP_PASS pass
ENV SMTP_ENCRYPTION tls

ENV LDAP_MEMBER_OF cn=group,dc=example,dc=com
ENV LDAP_USER_FILTER (objectClass=person)
ENV LDAP_HOST ldap.example.com
ENV LDAP_BASE_DN dc=example,dc=com
ENV LDAP_BIND_DN cn=admin,dc=example,dc=com
ENV LDAP_PASS pass

RUN /build/prepare.sh && \
	/build/services.sh && \
	/build/cleanup.sh

EXPOSE 80 443

CMD ["/sbin/my_init"]