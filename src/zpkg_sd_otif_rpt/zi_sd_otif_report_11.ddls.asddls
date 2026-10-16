@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT_11
  as select from I_DeliveryDocumentItem as a
    inner join   I_DeliveryDocument     as b on b.DeliveryDocument = a.DeliveryDocument
{
  a.ReferenceSDDocument,
  a.ReferenceSDDocumentItem,
  max( a.DeliveryDocument ) as DeliveryDocument
}
where
  b.ActualGoodsMovementDate is initial
group by
  a.ReferenceSDDocument,
  a.ReferenceSDDocumentItem
