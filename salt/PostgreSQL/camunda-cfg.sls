create-camunda-user:
  postgres_user.present:
    - name: camunda
    - password: VMware1!
    - encrypted: True
    - superuser: False
    - user: postgres


create-camunda-db:
  postgres_database.present:
    - owner: camunda
    - name: camunda
    - user: postgres


copy-camunda-scipts:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - names: 
      - /tmp/postgres_engine.sql:
        - source: salt://Camunda/postgres_engine.sql
      - /tmp/postgres_identity.sql:
        - source: salt://Camunda/postgres_identity.sql

configure-camunda-schema:
  cmd.run:
   - names:         
     - sudo -u postgres psql -d postgres -a -f /tmp/postgres_engine.sql
     - sudo -u postgres psql -d postgres -a -f /tmp/postgres_identity.sql