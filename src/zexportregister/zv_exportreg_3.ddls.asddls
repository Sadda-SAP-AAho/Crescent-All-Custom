@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Export Register Gate'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_EXPORTREG_3

  as select distinct from ZI_GATEENTRY
{

  key Vbeln         as Delivery,
      Gateentrydate as Confacindt,
      Vehicleoutdate

}
