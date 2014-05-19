{% if grains['os'] == 'Ubuntu' %}


include:
  - mysql.server
  - mysql.client

python-mysqldb:
  pkg.installed
  
{% for dbname, dbdata in salt['pillar.get']('mysql-basic-management:databases', {}).items() %}

{{ dbname }}:
  mysql_database.present:
    - require:
      - pkg: python-mysqldb

{{ dbname }}_user:
  mysql_user.present:
    - name: {{ dbdata.user }}
    - host: localhost
    - password: {{ dbdata.pass }} 
    - require:
      - pkg: python-mysqldb

{{ dbname }}_user_grants:
  mysql_grants.present:
    - grant: All
    - database: {{ dbname }}.*
    - user: {{ dbdata.user }} 
    - host: localhost
    - require:
      - mysql_database: {{ dbname }}
      - mysql_user: {{ dbname }}_user
      - pkg: python-mysqldb

{% endfor %}

{% endif %}
