-- Variables de configuración de conexiones que manejan los tiempos de espera
show variables like "%timeout%";

-- En particular variables que manejan el cierre automático de sesiones sin uso
SHOW GLOBAL VARIABLES LIKE 'wait_timeout';

SHOW GLOBAL VARIABLES LIKE '%interactive_timeout%';

SET GLOBAL wait_timeout=1800;
SET GLOBAL interactive_timeout=1800;

-- Cantidad de conexiones
show status where variable_name = 'threads_connected';


-- Información de procesos
show full processlist;

--conexiones por IP y estadísticas de tiempo en segundos
SELECT
  tmp.ipAddress,
  COUNT( * ) AS numConnections,
  FLOOR( AVG( tmp.time ) ) AS tiempo_Promedio,
  MAX( tmp.time ) AS tiempo_MAX
FROM
  (
    SELECT
      pl.id,
      pl.user,
      pl.host,
      pl.db,
      pl.command,
      pl.time,
      pl.state,
      pl.info,
      LEFT( pl.host, ( LOCATE( ':', pl.host ) - 1 ) ) AS ipAddress
    FROM
      INFORMATION_SCHEMA.PROCESSLIST pl
  ) AS tmp
GROUP BY tmp.ipAddress
ORDER BY numConnections DESC;

-- Cantidad de conexiones inactivas (IDLE/Sleep)
select count(*)  from information_schema.processlist where Command='Sleep';

-- Genera script para matar procesos inactivos
select concat('KILL ',id,';') from information_schema.processlist where Command='Sleep';
