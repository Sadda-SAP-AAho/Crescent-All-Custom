@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Month'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVNEWMON
  as select distinct from ZVMONTH( p_date:$session.system_date ) as a
    inner join            ZVPRCTR                                as b on a.joinflag = b.joinflag
{
  key a.mmyyyy,
  key b.Prctrclub
}
