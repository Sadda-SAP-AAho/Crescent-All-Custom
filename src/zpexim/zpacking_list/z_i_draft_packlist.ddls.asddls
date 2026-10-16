@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Z_I_DRAFT_PACKLIST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_DRAFT_PACKLIST
  as select from ZVDRAFTPL_ITM as draftpack
{
  key DeliveryDocument,
  key Revision,
  key DeliveryDocumentItem,
      Packqty,
      Packmattyp,
      Priority,
      Wtunit,
      ConsumptionTaxCtrlCode,
      ConsumptionTaxCtrlCodeText1,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      Eachnetwt,
      Qty,
      Matnr,
      Meins,
      UOM,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      Netwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      Growt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      Eachgrowt,
      PurchaseOrderByCustomer,
      MaterialByCustomer
}
