@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Z_I_DOMPACKLIST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_DOMPACKLIST
  as select from ZVDOMESDRAFT_ITM as dompack
{
  key DeliveryDocument,
  key Revision,
  key DeliveryDocumentItem,
      Packqty,
      Priority,
      Matnr,
      Maktx,
      @Semantics.quantity.unitOfMeasure : 'meins'
      Mateachpkg,
      Qty,
      UnderlyingPurchaseOrderItem,
      Wtunit,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      Eachnetwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      Netwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      Growt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      Eachgrowt,
      Meins
}
