# Install packages and configuration for 2tier-app app server role

installAppRolePackages:
  pkg.installed:
    - pkgs:
      - python
      - httpd
      - epel-release
      - python-pip
      - policycoreutils-python

startApache:
  service.running:
    - name: httpd
    - enable: True
      
setSELinuxBoolean:
  selinux.boolean:
    - name: httpd_can_network_connect
    - value: True
    - persist: True
    
installPipFromCmd:
  cmd.run: 
    - name: pip install requests
    
installAppScript:
  file.managed:
    - name: /var/www/cgi-bin/app.py
    - source: salt://2-tier/app.py
    - user: apache
    - group: apache
    - mode: 755
    - template: jinja
    
stopFirewall:
  service.dead:
    - name: firewalld
    - enable: False