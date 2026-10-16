@EndUserText.label: 'Domestic Draft PL Print'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZI_DOMDRFATPL'
define view ZCDS_TBLFUNC_ITMPRNT
  as select from ZTBL_FCTN_DOMDRAFTPLITM
                 
{
  key DeliveryDocument,
  key Revision,
  key DeliveryDocumentItem,
//  @Semantics.quantity.unitOfMeasure: 'Meins'
  ceil( cast( Packqty as abap.dec( 16,2 ) ) ) as Packqty,
  Priority,
  Matnr,
  Maktx,
  @Semantics.quantity.unitOfMeasure : 'meins'
  Mateachpkg,
//  @Semantics.quantity.unitOfMeasure: 'Meins'
  ceil( cast( Qty as abap.dec( 16,2 ) ) ) as Qty,
  UnderlyingPurchaseOrderItem,
  Wtunit,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  Eachnetwt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  Netwt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  Growt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  Eachgrowt,
  Meins
}
