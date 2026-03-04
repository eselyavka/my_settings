\set uptime 'SELECT now() - pg_postmaster_start_time() AS uptime;'

\set settings 'SELECT name, setting, unit, context FROM pg_settings;'

\set waits 'SELECT pid, query, waiting, now() - query_start  as "totaltime", backend_start FROM pg_stat_activity WHERE query !~ \'.*?IDLE.*?\'::text AND waiting;'

\set locks 'SELECT a.pid,mode,query FROM pg_locks l ,pg_stat_activity a WHERE NOT granted AND locktype=\'transactionid\' AND l.pid=a.pid ORDER BY psa.pid,granted;'

\set blocking 'SELECT bl.pid AS blocked_pid, a.usename AS blocked_user, ka.query AS blocking_statement, now() - ka.query_start AS blocking_duration, kl.pid AS blocking_pid, ka.usename AS blocking_user, a.query AS blocked_statement, now() - a.query_start  AS blocked_duration FROM  pg_catalog.pg_locks bl JOIN pg_catalog.pg_stat_activity a ON a.pid = bl.pid JOIN pg_catalog.pg_locks kl ON kl.transactionid = bl.transactionid AND kl.pid != bl.pid JOIN pg_catalog.pg_stat_activity ka ON ka.pid = kl.pid WHERE NOT bl.granted;'

\set ccount 'SELECT count(*) as totalconnections FROM pg_stat_activity;'

\set userconn 'SELECT count(*) AS connections ,client_addr::TEXT FROM pg_stat_activity GROUP BY client_addr;'

\set idletrx  'SELECT pid, datname, usename, client_addr, backend_start, waiting, query FROM pg_stat_activity WHERE query ~ \'.*?<IDLE> in transaction\'::text;'
