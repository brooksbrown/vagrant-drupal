{% if grains['os'] == 'Ubuntu' %}

drush_requirements:
  pkg.installed:
    - pkgs:
      - php-pear
      - php5-cli

pear_drush:
  cmd.run:
    - name: pear channel-discover pear.drush.org && pear install drush/drush
    - require:
      - pkg: drush_requirements

consoletable-drush:
  cmd.run:
    - name: cd /usr/share/php/drush/lib && wget http://download.pear.php.net/package/Console_Table-1.1.3.tgz && tar xvfz Console_Table-1.1.3.tgz
    - require:
      - cmd: pear_drush

{% endif %}
