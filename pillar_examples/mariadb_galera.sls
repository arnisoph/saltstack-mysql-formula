repos:
  lookup:
    repos:
      mariadb:
        url: http://mirror.netcologne.de/mariadb/repo/5.5/debian
        keyid: 1BB943DB
        keyserver: keyserver.ubuntu.com
        dist: wheezy
        comps:
          - main
        globalfile: True
      percona:
        url: http://repo.percona.com/apt
        keyid: 1C4CBDCDCD2EFD2A
        keyserver: keys.gnupg.net
        dist: wheezy
        comps:
          - main
        globalfile: True

mysql:
  lookup:
    type: mariadb_galera
    salt:
      config:
        states:
          host: localhost
          user: root
          pass: yoursecurepassword42
          socket: /var/run/mysqld/mysqld.sock
    mariadb_galera:
      server:
        rootpwd: 'yoursecurepassword42'
        config:
          manage:
            - debian
            - my
            - galera
          debian:
            path: /etc/mysql/debian.cnf
            config:
              file_prepend: '# Automatically generated for Debian scripts. DO NOT TOUCH!'
              sections:
                client:
                  - name: MISC
                    host: localhost
                    user: debian-sys-maint
                    password: x3dn62sq886ZpaUm
                    socket: /var/run/mysqld/mysqld.sock
                mysql_upgrade:
                  - name: MISC
                    host: localhost
                    user: debian-sys-maint
                    password: x3dn62sq886ZpaUm
                    socket: /var/run/mysqld/mysqld.sock
                    basedir: /usr
          my:
            config:
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
                    #bind-address: 127.0.0.1
                    skip-external-locking: ''
                    skip-character-set-client-handshake: ''
                    key_buffer_size: 128M

                  - name: LOGGING
                    log_queries_not_using_indexes: 0
                    slow_query_log: 0
                    slow_query_log_file: /var/log/mysql/mysql-slow.log
                    long_query_time: 0.5

                  - name: CACHES AND LIMITS
                    tmp_table_size: 32M
                    max_heap_table_size: 32M
                    #query_cache_type: 1
                    query_cache_limit: 16M
                    #query_cache_size: 64M
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

                  - name: MYSQLD SETTINGS FOR GALERA
                    binlog_format: ROW
                    default-storage-engine: innodb
                    innodb_autoinc_lock_mode: 2
                    query_cache_size: 0
                    query_cache_type: 0
                    bind-address: 0.0.0.0

                  - name: GALERA/ WSREP SETTINGS
                    wsrep_provider: /usr/lib/galera/libgalera_smm.so
                    wsrep_cluster_name: "my_wsrep_cluster"
                    #wsrep_sst_method: rsync
                    wsrep_sst_method: xtrabackup
                    wsrep_sst_auth: root:yoursecurepassword42

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
          galera:
            path: /etc/mysql/conf.d/galera.cnf
            template_path: salt://mysql/files/galera.cnf
      users:
        - name: debian-sys-maint
          password: x3dn62sq886ZpaUm
          host: localhost
