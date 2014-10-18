mysql:
  lookup:
    server:
      rootpwd: 'yoursecurepassword42'
      config:
        my:
          config:
            file_prepend: |
              # prepend this
            sections:
              client:
                - name: MISC
                  socket: /var/run/mysqld/mysqld.sock
              mysqld:
                - name: MISC
                  user: mysql
                  pid-file: /var/run/mysqld/mysqld.pid
                  socket: /var/run/mysqld/mysqld.sock
                  basedir: /usr
                  datadir: /var/lib/mysql
                  tmpdir: /tmp
                  lc-messages-dir: /usr/share/mysql
                  bind-address: 127.0.0.1
                  skip-external-locking: ''

                - name: LOGGING
                  log_queries_not_using_indexes: 0
                  slow_query_log: 0
                  slow_query_log_file: /var/log/mysql/mysql-slow.log
                  long_query_time: 0.5

                - name: CACHES AND LIMITS
                  tmp_table_size: 32M
                  max_heap_table_size: 32M
                  query_cache_type: 1
                  query_cache_limit: 16M
                  query_cache_size: 64M
                  max_connections: 100
                  max_user_connections: 90
                  thread_cache_size: 50
                  open_files_limit: 65535
                  table_cache: 1024
                  table_open_cache: 1024
                  table_definition_cache: 2048
                  myisam_sort_buffer_size: 10M
                  sort_buffer_size: 10M
                  read_buffer_size: 10M
                  binlog_cache_size: 5M
                  binlog_format: mixed
                  wait_timeout: 60
                  interactive_timeout: 300
                  max_allowed_packet: 16M
                  thread_stack: 256K
                  join_buffer_size: 4M

                - name: SAFETY
                  max_allowed_packet: 16M
                  max_connect_errors: 1000000

                - name: BINARY LOGGING
                  log_bin: /var/lib/mysql/mysql-bin
                  expire_logs_days: 14
                  sync_binlog: 1
                  max_binlog_size: 100M

                - name: INNODB
                  innodb_flush_method: O_DIRECT
                  innodb_flush_log_at_trx_commit: 1
                  innodb_file_per_table: 1
                  innodb_buffer_pool_size: 800M

                - name: MISC
                  skip-character-set-client-handshake: ''
                  key_buffer_size: 128M

              myisamchk:
                - name: MISC
                  myisam_recover: FORCE,BACKUP
                  myisam-recover-options: BACKUP

              mysqldump:
                - name: MISC
                  quick: ''
                  quote-names: ''
            file_append: |
              !includedir /etc/mysql/conf.d/
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
      host: localhost
      defaults_file:
        socket: /var/run/mysqld/mysqld.sock
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
