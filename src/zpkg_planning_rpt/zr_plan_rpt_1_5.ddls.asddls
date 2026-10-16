@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Planning Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_1_5
  as select from ZR_PLAN_RPT_1
{
  key Plant,
  key Product,
      reqdeldate,
      ScheduleLineCategory,
      OpenSoQty,
      case
      when reqdeldate <= dats_add_days( $session.system_date, 7, 'INITIAL' ) and  ScheduleLineCategory = 'CP' then cast( '7' as abap.char(4) )
      when reqdeldate >= dats_add_days( $session.system_date, 8, 'INITIAL' ) and reqdeldate <= dats_add_days( $session.system_date, 15, 'INITIAL' ) and
           ScheduleLineCategory = 'CP' then cast( '8' as abap.char(4) )
      when reqdeldate >= dats_add_days( $session.system_date, 16, 'INITIAL' ) and reqdeldate <= dats_add_days( $session.system_date, 23, 'INITIAL' ) and
           ScheduleLineCategory = 'CP' then cast( '16' as abap.char(4) )
      when reqdeldate >= dats_add_days( $session.system_date, 24, 'INITIAL' ) and reqdeldate <= dats_add_days( $session.system_date, 30, 'INITIAL' ) and
           ScheduleLineCategory = 'CP' then cast( '23' as abap.char(4) )
      when reqdeldate >= dats_add_days( $session.system_date, 31, 'INITIAL' ) and reqdeldate <= dats_add_days( $session.system_date, 38, 'INITIAL' ) and
           ScheduleLineCategory = 'CP' then cast( '31' as abap.char(4) )
      when reqdeldate >= dats_add_days( $session.system_date, 39, 'INITIAL' ) and reqdeldate <= dats_add_days( $session.system_date, 46, 'INITIAL' ) and
           ScheduleLineCategory = 'CP' then cast( '39' as abap.char(4) )
      when reqdeldate >= dats_add_days( $session.system_date, 47, 'INITIAL' ) and reqdeldate <= dats_add_days( $session.system_date, 54, 'INITIAL' ) and
           ScheduleLineCategory = 'CP' then cast( '47' as abap.char(4) )
      when reqdeldate >= dats_add_days( $session.system_date, 55, 'INITIAL' ) and reqdeldate <= dats_add_days( $session.system_date, 62, 'INITIAL' ) and
           ScheduleLineCategory = 'CP' then cast( '55' as abap.char(4) )
      when reqdeldate >= dats_add_days( $session.system_date, 63, 'INITIAL' ) and reqdeldate <= dats_add_days( $session.system_date, 70, 'INITIAL' ) and
           ScheduleLineCategory = 'CP' then cast( '63' as abap.char(4) )
      when reqdeldate >= dats_add_days( $session.system_date, 71, 'INITIAL' ) and reqdeldate <= dats_add_days( $session.system_date, 365, 'INITIAL' ) and
           ScheduleLineCategory = 'CP' then cast( '71' as abap.char(4) )
      when reqdeldate >= dats_add_days( $session.system_date, 366, 'INITIAL' )  and
           ScheduleLineCategory = 'CP'  then cast( '366' as abap.char(4) )
      when ScheduleLineCategory = 'CN'  then cast( 'CN' as abap.char(4) )
      else null end as DayQty


}
group by
  Plant,
  Product,
  reqdeldate,
  ScheduleLineCategory,
  OpenSoQty
