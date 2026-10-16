@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contractor Code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_CONTRACTOR
  as select distinct from ZI_PP_CASTING_RPT_1 as a
{
  key a.MaterialDocumentNo,
  key a.Plant,
  key a.Matnr,
      a.Cont
}

where
       a.MovementType = '321'
