{% from "php/map.jinja" import php with context %}

php-mcrypt:
  pkg:
    - installed
    - name: {{ php.mcrypt_pkg }}

{% if grains['os'] == 'Ubuntu' %}
  php5enmod mcrypt:
    cmd.run:
      - require:
        - pkg: php-mcrypt
{% endif %}
