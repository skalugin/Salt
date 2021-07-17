# Install packages and configuration for 2tier-app database role

installDbRolePackages:
  pkg.installed:
    - pkgs:
      - python
      - httpd

startApache:
  service.running:
    - name: httpd
    - enable: True

createDatabaseDirectory:
  file.directory:
    - name: /var/www/db
    - user: apache
    - group: apache
    - dir_mode: 755
    - file_mode: 755
    - recurse:
      - user
      - group
      - mode
      
directory.db:
  sqlite3.table_present:
    - db: /var/www/db/directory.db
    - schema: CREATE TABLE 'directory' ("PhoneNumber" INTEGER, "FirstName" VARCHAR(30), "Surname" VARCHAR(25), "Department" VARCHAR(20))
    
seedDatabase:
  module.run:
    - name: sqlite3.modify
    - db: /var/www/db/directory.db
    - sql: "INSERT INTO 'directory' VALUES (441536222333,'John','Adams','Billing'), (441536444654,'Sarah','Williams','Sales')"
#    - require:
#      - sqlite3: directory.db
      
databaseAppFile:
  file.managed:
    - name: /var/www/cgi-bin/database.py
    - source: salt://2-tier/dbAppScript.py
    - user: apache
    - group: apache
    - mode: 755

stopFirewall:
  service.dead:
    - name: firewalld
    - enable: False