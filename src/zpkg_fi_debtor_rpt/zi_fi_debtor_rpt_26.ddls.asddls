@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtor Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_26
  as select distinct from zdt_nostro_itm2
{
  key id,
      inwardrecordstatus
}

where
  inwardrecordstatus = ''
