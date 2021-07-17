install-postgresql13-repository:
  pkg.installed:
    - sources:
      - pg: https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    - unless: 
      -  rpm -q postgresql13-server

install-postgresql-server:
  pkg.installed:
    - pkgs: 
      - postgresql13-server
      - postgresql13
    - unless: 
      -  rpm -q postgresql13-server
    
configure-postgres-path:
  file.managed:
    - name: /etc/salt/minion.d/minion-postgres.conf
    - source: salt://PostgreSQL/minion-postgres.conf

{% if not salt['file.directory_exists' ]('/var/lib/pgsql/13/data') %}
postgresql-first-run-init:
  cmd.run:
   - names: 
     - echo 'pathmunge /usr/pgsql-13/bin' > /etc/profile.d/ree.sh
     - chmod +x /etc/profile.d/ree.sh
     - /usr/pgsql-13/bin/postgresql-13-setup initdb
     - sleep 20
{% endif %}

#  postgres_initdb.present:
#    - name: /var/lib/pgsql/13/data

configure-remote-accesss:
  file.managed:
    - name: /var/lib/pgsql/13/data/pg_hba.conf
    - source: salt://PostgreSQL/pg_hba.conf
 
      
change-listener:
  file.replace:
    - name: '/var/lib/pgsql/13/data/postgresql.conf'
    - pattern: '^#listen_addresses.*'
    - repl: "listen_addresses = '*'"

stop-firewall:
  service:
    - dead
    - name: firewalld
    - disabled: True

start-postgresql13-server:
  service:
    - running
    - name: postgresql-13
    - enable: True
    - reload: True
    - require:
      - install-postgresql-server


{% if grains['additionalConfig'] == 'camunda' %}
include: 
  - .camunda-cfg



{% endif %}