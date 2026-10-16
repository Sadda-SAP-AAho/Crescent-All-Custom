@AbapCatalog.sqlViewName: 'ZV_SCHEDULE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for schedule line details'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SCHEDULINE1
  as select distinct from I_SalesOrder             as a
    inner join            I_SalesOrderItem         as b on a.SalesOrder = b.SalesOrder
    inner join            I_SalesOrderScheduleLine as c on  c.SalesOrder     = b.SalesOrder
                                                        and c.SalesOrderItem = b.SalesOrderItem

{
  key         b.SalesOrder,
  key         b.SalesOrderItem,
              c.ScheduleLineCategory,
              ( case when c.ScheduleLineCategory = 'CN' then 'YES' else 'NO' end ) as soholdstat
}
group by
  b.SalesOrder,
  b.SalesOrderItem,
  c.ScheduleLineCategory
