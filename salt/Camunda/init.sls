download-camunda:
  archive.extracted:
    - name: /app/camunda-bpm-tomcat
    - source: http://corp.local/camunda-bpm-tomcat-7.15.0.zip
    - skip_verify: True
    - enforce_toplevel: False
    
install-openjdk:
  pkg.installed:
    - pkgs: 
      - java-11-openjdk
    
copy-jdbc:
  file.managed:
    - name: /app/camunda-bpm-tomcat/server/apache-tomcat-9.0.43/lib/postgresql-42.2.22.jar
    - source: http://corp.local/postgresql-42.2.22.jar
    - skip_verify: True

change-server-config:
  file.managed:
    - name: '/app/camunda-bpm-tomcat/server/apache-tomcat-9.0.43/conf/server.xml'
    - source: 'salt://Camunda/server.xml'
    - template: jinja
    
change-bpm-config:
  file.replace:
    - name: '/app/camunda-bpm-tomcat/server/apache-tomcat-9.0.43/conf/bpm-platform.xml'
    - pattern: '^\s*<property name="databaseSchemaUpdate(.*)$'
    - repl: '      <property name="databaseSchemaUpdate">true</property>'

copy-web-config:
  file.managed:
    - name: '/app/camunda-bpm-tomcat/server/apache-tomcat-9.0.43/webapps/engine-rest/WEB-INF/web.xml'
    - source: 'salt://Camunda/web.xml'
    
stop-firewall:
  service:
    - dead
    - name: firewalld
    - disabled: True
    
run-apache:
  cmd.run:
   - names: 
     - /app/camunda-bpm-tomcat/server/apache-tomcat-9.0.43/bin/catalina.sh start


