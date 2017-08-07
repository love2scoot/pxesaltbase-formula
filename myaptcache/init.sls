# Make sure to add/update the DNSname for your apt-cache server e.g.: aptcache.bobbarker.com
aptcache_prereq:
  pkg.installed:
    - refresh: True
    - pkgs:
      - apache2
  
# Install the apt-cacher service and ensure it starts at boot
aptcache_install:
  pkg.installed:
    - refresh: True
    - pkgs:
      - apt-cacher
  service.running:
    - name: apt-cacher
    - enable: True

# Drop in the apt-cacher config file
aptcache_config:
  file.managed:
    - name: /etc/apt-cacher/conf.d/myaptcache.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://aptcache/myaptcache.conf
    - template: jinja
  service.running:
    - watch:
      - file: /etc/apt-cacher/conf.d/myaptcache.conf
    - name: apt-cacher
      
# Replace the default website config
aptcache_default_site:
  file.managed:
    - name: /etc/apache2/sites-available/000-default.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://aptcache/000-default.conf
    - template: jinja
  service.running:
    - name: apache2
    - watch:
      - file: /etc/apache2/sites-available/000-default.conf

# Drop in a pointer to the aptcache status page and 
aptcache_pointer:
  file.managed:
    - name: /var/www/aptcache_status.html
    - user: root
    - group: root
    - mode: 644
    - source: salt://aptcache/aptcache_status.html
    - template: jinja

# Ensure the default index.html is wiped out, this should allow apache to create a folder listing by default.
aptcache_cleanout:
  file.absent:
    - name: /var/www/html/index.html
