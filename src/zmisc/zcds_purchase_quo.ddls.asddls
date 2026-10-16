@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Country of Destination'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PURCHASE_QUO 
as select from I_PurchaseOrderItemAPI01 as a // I_PurchaseOrderItemTP //
{
  key PurchaseOrder
  //key PurchaseOrderItem
  //key PurchasingDocument
}
