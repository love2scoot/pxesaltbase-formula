# Install the packages required for PXE
pxe_packages:
  pkg.installed:
    - refresh: True
    - pkgs:
      - apache2
      - tftpd-hpa
      - nfs-kernel-server

# Configure the TFTPD-hpa service for serving the menu and kernels 
tftpd_config:
  file.managed:
    - name: /etc/default/tftpd-hpa
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/tftpd-hpa
  service.running:
    - name: tftpd-hpa
    - reload: true
    - watch:
      - file: /etc/default/tftpd-hpa

# Setting up ubuntu-16.04-desktop-amd64 live as a boot option
# Grab the ISO from the Ubuntu site
get_ub1604x64desktop_iso:
  file.managed:
    - name: /media/ubuntu-16.04.2-desktop-amd64.iso
    - user: root
    - group: root
    - mode: 644
    - source: http://releases.ubuntu.com/16.04.2/ubuntu-16.04.2-desktop-amd64.iso
    - source_hash: sha256=0f3086aa44edd38531898b32ee3318540af9c643c27346340deb2f9bc1c3de7e
# Mount the ISO using the loop option.  Since this is supposed to be read only media, we don't need to copy files locally.
mount_ub1604x64desktop_iso:
  file.directory:
    - name: /var/www/html/ubuntu1604x64live
  mount.mounted:
    - name: /var/www/html/ubuntu1604x64live
    - device: /media/ubuntu-16.04.2-desktop-amd64.iso
    - fstype: iso9660
    - opts:
      - loop
# After the ISO is mounted, the kernel and ramdisk need to be copied from apache to the local TFTP Server to enable this image to PXE boot
ub1604x64desktop_kernel:
  file.managed:
    - name: /var/lib/tftpboot/ubuntu1604x64live/vmlinuz.efi
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1604x64live/casper/vmlinuz.efi
    - makedirs: true
    - skip_verify: true
ub1604x64desktop_ramdisk:
  file.managed:
    - name: /var/lib/tftpboot/ubuntu1604x64live/initrd.lz
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1604x64live/casper/initrd.lz
    - skip_verify: true

# Setting up ubuntu-16.04-server-amd64 install as a boot option
# Grab the ISO from the Ubuntu site
get_ub1604x64server_iso:
  file.managed:
    - name: /media/ubuntu-16.04.2-server-amd64.iso
    - user: root
    - group: root
    - mode: 644
    - source: http://releases.ubuntu.com/16.04.2/ubuntu-16.04.2-server-amd64.iso
    - source_hash: sha256=737ae7041212c628de5751d15c3016058b0e833fdc32e7420209b76ca3d0a535
# Mount the ISO using the loop option.  Since this is supposed to be read only media, we don't need to copy files locally.
mount_ub1604x64server_iso:
  file.directory:
    - name: /var/www/html/ubuntu1604x64server
  mount.mounted:
    - name: /var/www/html/ubuntu1604x64server
    - device: /media/ubuntu-16.04.2-server-amd64.iso
    - fstype: iso9660
    - opts:
      - loop
# After the ISO is mounted, the kernel and ramdisk need to be copied from apache to the local TFTP Server to enable this image to PXE boot
ub1604x64server_kernel:
  file.managed:
    - name: /var/lib/tftpboot/ubuntu1604x64server/linux      
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1604x64server/install/netboot/ubuntu-installer/amd64/linux
    - makedirs: true
    - skip_verify: true
ub1604x64server_ramdisk:
  file.managed:
    - name: /var/lib/tftpboot/ubuntu1604x64server/initrd.gz
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1604x64server/install/netboot/ubuntu-installer/amd64/initrd.gz
    - skip_verify: true
# The preseed file specifies all the values necessary in order to fully automate the OS install 
ub1604x64server_preseed:
  file.managed:
    - name: /var/www/html/ub1604x64server.preseed
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/ub1604x64server.preseed
    - template: jinja

# Setting up ubuntu-14.04.5-server-amd64 install as a boot option
# Grab the ISO from the Ubuntu site
get_ub1404x64server_iso:
  file.managed:
    - name: /media/ubuntu-14.04.5-server-amd64.iso
    - user: root
    - group: root
    - mode: 644
    - source: http://releases.ubuntu.com/14.04.5/ubuntu-14.04.5-server-amd64.iso
    - source_hash: sha256=dde07d37647a1d2d9247e33f14e91acb10445a97578384896b4e1d985f754cc1
# Mount the ISO using the loop option.  Since this is supposed to be read only media, we don't need to copy files locally.
mount_ub1404x64server_iso:
  file.directory:
    - name: /var/www/html/ubuntu1404x64server
  mount.mounted:
    - name: /var/www/html/ubuntu1404x64server
    - device: /media/ubuntu-14.04.5-server-amd64.iso
    - fstype: iso9660
    - opts:
      - loop
# After the ISO is mounted, the kernel and ramdisk need to be copied from apache to the local TFTP Server to enable this image to PXE boot
ub1404x64server_kernel:
  file.managed:
    - name: /var/lib/tftpboot/ubuntu1404x64server/linux      
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1404x64server/install/netboot/ubuntu-installer/amd64/linux
    - makedirs: true
    - skip_verify: true
ub1404x64server_ramdisk:
  file.managed:
    - name: /var/lib/tftpboot/ubuntu1404x64server/initrd.gz
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1404x64server/install/netboot/ubuntu-installer/amd64/initrd.gz
    - skip_verify: true
# The preseed file specifies all the values necessary in order to fully automate the OS install 
ub1404x64server_preseed:
  file.managed:
    - name: /var/www/html/ub1404x64server.preseed
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/ub1404x64server.preseed
    - template: jinja

# Setting up memtest as a boot option
get_memtest:
  file.managed:
    - name: /var/lib/tftpboot/memtest/memtest
    - user: root
    - group: root
    - mode: 644
    - source: http://www.memtest.org/download/5.01/memtest86+-5.01.bin
    - makedirs: true
    - skip_verify: true

# Configuring NFS for those boot options which require local media to be mounted
# In this case, only the Ubuntu live boot option relies on NFS
nfs_config:
  file.managed:
    - name: /etc/exports
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/exports
  service.running:
    - name: nfs-kernel-server
    - reload: true
    - watch:
      - file: /etc/exports

# Building the PXE Boot menu and prerequisites
pxe_menu_default:
  file.managed:
    - name: /var/lib/tftpboot/pxelinux.cfg/default
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/default
    - template: jinja
    - makedirs: true
pxe_req1:
  file.managed:
    - name: /var/lib/tftpboot/pxelinux.0
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1604x64server/install/netboot/pxelinux.0
    - skip_verify: true
pxe_req2:
  file.managed:
    - name: /var/lib/tftpboot/ldlinux.c32
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1604x64server/install/netboot/ldlinux.c32
    - skip_verify: true
pxe_req3:
  file.managed:
    - name: /var/lib/tftpboot/vesamenu.c32
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1604x64server/install/netboot/ubuntu-installer/amd64/boot-screens/vesamenu.c32
    - skip_verify: true
pxe_req4:
  file.managed:
    - name: /var/lib/tftpboot/libcom32.c32
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1604x64server/install/netboot/ubuntu-installer/amd64/boot-screens/libcom32.c32
    - skip_verify: true
pxe_req5:
  file.managed:
    - name: /var/lib/tftpboot/libutil.c32
    - user: root
    - group: root
    - mode: 644
    - source: http://127.0.0.1/ubuntu1604x64server/install/netboot/ubuntu-installer/amd64/boot-screens/libutil.c32
    - skip_verify: true
    
# Create the saltbase_install folder and drop in the supporting files and salt
sbinstall_folder:
  file.directory:
    - name: /var/www/html/saltbase_install
sbinstall_1604list:
  file.managed:
    - name: /var/www/html/saltbase_install/new1604saltstack.list
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/saltbase_install/new1604saltstack.list
sbinstall_1404list:
  file.managed:
    - name: /var/www/html/saltbase_install/new1404saltstack.list
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/saltbase_install/new1404saltstack.list
sbinstall_installconf:
  file.managed:
    - name: /var/www/html/saltbase_install/saltbase_install.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/saltbase_install/saltbase_install.conf
sbinstall_devopsconf:
  file.managed:
    - name: /var/www/html/saltbase_install/devops_standard.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/saltbase_install/devops_standard.conf
sbinstall_gitfsconf:
  file.managed:
    - name: /var/www/html/saltbase_install/gitfs_remotes.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/saltbase_install/gitfs_remotes.conf
sbinstall_topsls:
  file.managed:
    - name: /var/www/html/saltbase_install/top.sls
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/saltbase_install/top.sls
sbinstall_salt:
  file.managed:
    - name: /var/www/html/saltbase_install/saltbase_install.sls
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/saltbase_install/saltbase_install.sls
    - template: jinja

# Drop in the helper scripts.  Note that these will be accessible from the webserver, where they can be copied to the target host by the saltbase_install.sls salt formula.
saltbase_helper1:
  file.managed:
    - name: /var/www/html/saltbase_install/enable_ssh.sh
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/saltbase_install/enable_ssh.sh
saltbase_helper2:
  file.managed:
    - name: /var/www/html/saltbase_install/newsalthostname.sh
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/saltbase_install/newsalthostname.sh
saltbase_helper3:
  file.managed:
    - name: /var/www/html/saltbase_install/setupnetwork.sh
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/saltbase_install/setupnetwork.sh

# Drop in a new .bashrc file.  This contains post install instructions and fixes the nfsroot hostname limitation in /var/lib/tftpboot/pxelinux.cfg/default
update_bashrc:
  file.managed:
    - name: /root/.bashrc
    - user: root
    - group: root
    - mode: 644
    - source: salt://pxesaltbase/.bashrc
    - template: jinja
