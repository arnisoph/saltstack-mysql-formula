mysql:
  lookup:
    server:
      rootpwd: 'test123'
  salt:
    config:
      {# EITHER SPECIFY THIS #}
      file: |
        [client]
          host = localhost
          user = root
          password = test123
          socket = /var/run/mysqld/mysqld.sock
      {# OR THIS! #}
      states:
        host: localhost
        user: root
        pass: test123
        socket: /var/run/mysqld/mysqld.sock
  databases:
    - name: foo1
    - name: bar2
  users:
    - name: foo1
      password: bar1
    - name: bar2
      password: foo2
      host: 127.0.0.1
    - name: bar3
      password: foo2
      host: '::1'
  grants:
    - user: foo1
      database: 'bar2.*'
    - user: bar2
      host: 127.0.0.1
      database: '*.*'
      grant:
        - select
        - insert
        - update
