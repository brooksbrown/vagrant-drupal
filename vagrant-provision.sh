#!/usr/bin/env python

import sys
import os
import pwd 
import grp

def append_string_to_file(theString, theFile):
  if theString not in open(theFile).read():
    with open(theFile, 'a') as theFileObject:
      theFileObject.write(theString)

vagrant_uid = pwd.getpwnam('vagrant').pw_uid
vagrant_gid = grp.getgrnam('vagrant').gr_gid

#setup drush aliases
if not os.path.isdir("/home/vagrant/.drush"):
  os.system("mkdir /home/vagrant/.drush")
os.chown('/home/vagrant/.drush', vagrant_uid, vagrant_gid)

drush_alias_file = """<?php

$aliases['vagrant'] = array(
  'root' => '/vagrant/docroot',
  'uri' => 'localhost',
  'db-url' => 'mysql://vagrant:vagrant@localhost/db',
);
"""

with open('/home/vagrant/.drush/vagrant.aliases.drushrc.php', 'w') as fileObject:
  fileObject.write(drush_alias_file) 
os.chown('/home/vagrant/.drush/vagrant.aliases.drushrc.php', vagrant_uid, vagrant_gid)

#add pdo_mysql extension to apache2's php config
append_string_to_file('extension=pdo_mysql.so', '/etc/php5/apache2/php.ini')
os.system("service apache2 restart")


