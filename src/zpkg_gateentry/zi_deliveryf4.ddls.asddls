@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Delivery number tagging'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_deliveryf4
  as select from    ZI_DELDASH_HDR     as a
    left outer join I_DeliveryDocument as b on b.DeliveryDocument = a.Delivery
{
  a.Delivery,
  b.CreationDate,
  a.Contno
}
