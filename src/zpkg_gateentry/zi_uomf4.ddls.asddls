@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'UOM F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_uomf4
  as select from I_UnitOfMeasureText as a
{
  key a.UnitOfMeasure_E,
  key a.UnitOfMeasureLongName
}
where
  a.Language = 'E'
