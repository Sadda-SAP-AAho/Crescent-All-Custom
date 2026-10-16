@EndUserText.label: 'Final PL Sorted Items'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZI_FPL_PRITM'
define view ZCDS_FINALPLITEM_SORT
  as select from ZTBL_FUNC_FINALPLITEM
                 
{
  key BillingDocument,
  key BillingDocumentItem,
  priority,
  Material,
  BillingDocumentItemText,
  BillingQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
  BillingQuantity,
  TransactionCurrency,
  ConsumptionTaxCtrlCodeText1,
  ConsumptionTaxCtrlCode,
  ConditionRateValue,
  PurchaseOrderByCustomer,
  CustomerPurchaseOrderDate,
  AdditionalMaterialGroup1,
  BillingDocumentDate,
  UnderlyingPurchaseOrderItem,
  PurchaseOrderByShipToParty,
  MaterialByCustomer,
  Wtunit,
 @Semantics.quantity.unitOfMeasure: 'Meins'
  ceil( cast( Packqty as abap.dec( 16,2 ) ) ) as Packqty,
  Packmattyp,
 @Semantics.quantity.unitOfMeasure: 'Meins'
  Eachnetwt,
 @Semantics.quantity.unitOfMeasure: 'Meins'
  Eachgrowt,
 @Semantics.quantity.unitOfMeasure: 'Meins'
  ceil( cast( Qty as abap.dec( 16,2 ) ) ) as Qty,
 @Semantics.quantity.unitOfMeasure: 'Meins'
  Netwt,
 @Semantics.quantity.unitOfMeasure: 'Meins'
  Growt,
 @Semantics.quantity.unitOfMeasure: 'Meins'
  Mateachpkg,
  Meins,
  Contno
}
