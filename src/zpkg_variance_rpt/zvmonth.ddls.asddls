@AbapCatalog.sqlViewName: 'ZZVMONTH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Month Determination'
@Metadata.ignorePropagatedAnnotations: true
define view ZVMONTH
  with parameters
    @Environment.systemField: #SYSTEM_DATE
    p_date : abap.dats
  as select from I_CalendarMonth


{
  key   concat( CalendarMonth, substring( $parameters.p_date, 1, 4 ) ) as mmyyyy,
        cast(1 as abap.int4)                                           as joinflag
}
where
  (
        CalendarMonth >= '01'
    and CalendarMonth <= substring($parameters.p_date, 5, 2)
  )
