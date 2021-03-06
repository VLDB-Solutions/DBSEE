/*********************************************************************/
/* Author      : VLDB                                                */
/* Date        : 08/02/2017                                          */
/* Version     : 1                                                   */
/* Description : Generate report on tables with fallback             */
/*               enabled                                             */
/*********************************************************************/
select t1.databasename       as database_name
      ,t1.tablename          as table_name
      ,t1.tablekind          as table_kind
      ,t1.protectiontype     as protection_type
      ,t1.createtimestamp    as create_timestamp
      ,t1.lastaltername      as last_alter_name
      ,t1.lastaltertimestamp as last_alter_timestamp
      ,t2.total_perm         as total_perm
from   dbc.tables t1
inner join 
      (select databasename
                 ,tablename
                 ,sum(currentperm) as total_perm
       from   dbc.tablesizev
       group by 1,2) t2
on     t1.databasename = t2.databasename
and    t1.tablename    = t2.tablename
where  t1.tablekind in ('T','O')
;

