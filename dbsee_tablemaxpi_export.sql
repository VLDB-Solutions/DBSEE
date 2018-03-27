/*********************************************************************/
/* Author      : VLDB                                                */
/* Date        : 07/02/2017                                          */
/* Version     : 1                                                   */
/* Description : Generate CSV to report on tables with more than 5   */
/*               columns as the primary index within the Teradata    */
/*               System                                              */
/*********************************************************************/
/* 1 - export target table to CSV                                    */
/*********************************************************************/

-- export location now defined through controlling shell

.set recordmode off
.set separator '|'
.set width 2000
.set titledashes off
.set null as ''

select t1.databasename        as database_name
      ,t1.tablename           as table_name
      ,max(t1.columnposition) as pi_count
      ,t2.total_perm          as total_perm
from   dbc.indices t1
inner join 
      (select databasename
             ,tablename
             ,sum(currentperm) as total_perm
       from   dbc.tablesizev
       group by 1,2) t2
on     t1.tablename    = t2.tablename
and    t1.databasename = t2.databasename
where  t1.indexnumber  = 1
group by 1,2,4
;
.if errorcode <> 0 then .quit errorcode

.logoff
.exit

