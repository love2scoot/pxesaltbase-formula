# Drop in the helper scripts.
saltbase_helper1:
  file.managed:
    - name: /root/enable_ssh.sh
    - user: root
    - group: root
    - mode: 755
    - source: http://pxe.bobbarker.com/saltbase_install/enable_ssh.sh
    - skip_verify: true
saltbase_helper2:
  file.managed:
    - name: /root/newsalthostname.sh
    - user: root
    - group: root
    - mode: 755
    - source: http://pxe.bobbarker.com/saltbase_install/newsalthostname.sh
    - skip_verify: true
saltbase_helper3:
  file.managed:
    - name: /root/setupnetwork.sh
    - user: root
    - group: root
    - mode: 755
    - source: http://pxe.bobbarker.com/saltbase_install/setupnetwork.sh
    - skip_verify: true

# Build libgit2 from source to enable https access (No https access using the main repo version)
build_prereq:
  pkg.installed:
    - refresh: True
    - pkgs:
      - build-essential 
      - cmake 
      - libssh2-1-dev 
      - python-dev 
      - python-pip 
      - python-cffi 
      - libssl-dev 
      - libffi-dev 
      - pkg-config 
      - libcurl4-openssl-dev
      - libhttp-parser-dev

build-libgit2:
  cmd.run:
    - name: |
        cd /tmp
        wget https://github.com/libgit2/libgit2/archive/v0.25.0.tar.gz
        tar -zxf v0.25.0.tar.gz
        cd ./libgit2-0.25.0
        cmake .
        make
        make install
        ldconfig
    - cwd: /tmp
    - shell: /bin/bash
    - timeout: 300
    - unless: 'salt-call --versions-report | grep "libgit2: 0.25.0"'
  pip.installed:
    - name: pygit2==0.25.0

# Configure Salt on the local machine by removing the saltbase install config, adding the devops saltbase config,
# adding the gitfs_remotes template, and cleaning up the .bashrc file.

remove_install_config:
  file.absent:
    - name: /etc/salt/master.d/saltbase_install.conf

devops_config_install:
  file.managed:
    - name: /etc/salt/master.d/devops_standard.conf
    - user: root
    - group: root
    - mode: 644
    - source: http://pxe.bobbarker.com/saltbase_install/devops_standard.conf
    - skip_verify: true

gitfs_remotes_template:
  file.managed:
    - name: /etc/salt/master.d/gitfs_remotes.conf
    - user: root
    - group: root
    - mode: 644
    - source: http://pxe.bobbarker.com/saltbase_install/gitfs_remotes.conf
    - skip_verify: true

cleanup_bashrc:
  file.blockreplace:
    - name: /root/.bashrc
    - marker_start: "# START salt blockreplace"
    - marker_end: "# END salt blockreplace"
    - content: '# Initial config completed'
    - backup: False
