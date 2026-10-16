@EndUserText.label: 'Draft PL Print'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZI_DRFATPL_PRITM'
define view ZI_DRAFTPL_PRINT as select from ZTBL_FCTN_DRAFTPLITM 
  
                 
{
  key DeliveryDocument,
  key Revision,
  key DeliveryDocumentItem,
// @Semantics.quantity.unitOfMeasure: 'Meins'
  ceil( cast( Packqty as abap.dec( 16,2 ) ) ) as Packqty,
 Packmattyp,
  Priority,
  Wtunit,
  ConsumptionTaxCtrlCode,
  ConsumptionTaxCtrlCodeText1,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  Eachnetwt,
//  @Semantics.quantity.unitOfMeasure: 'Meins'
  ceil( cast( Qty as abap.dec( 16,2 ) ) ) as Qty,
  Matnr,
  Meins,
  UOM,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  Netwt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  Growt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  Eachgrowt,
  PurchaseOrderByCustomer,
  PURCHASEORDERITEM,
  MaterialByCustomer,
  Matlngtxt
} ;

