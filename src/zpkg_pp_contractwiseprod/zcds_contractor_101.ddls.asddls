@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contractor Code-101'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZCDS_CONTRACTOR_101
  as select distinct from zcds_pp_casting_report as a
{
  key a.MaterialDocument,
  key a.Plant,
  key a.Matnr,
      a.Cont
}

where
  a.MovementType = '101'
