@EndUserText.label: 'Draft PL Print'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZI_XPT_PRINT_HS'
define view ZI_DRAFTPL_PRINT_HS
  as select from ZTBL_FCTN_DRAFTPLITM  association[0..*] to ZI_MATFLD as _mattext on $projection.Matnr = _mattext.Product
                 
{
  key DeliveryDocument,
  key Revision,
  key DeliveryDocumentItem,
// @Semantics.quantity.unitOfMeasure: 'Meins'
  ceil( cast( Packqty as abap.dec( 16,2 ) ) ) as Packqty,
  Packmattyp,
  Priority,
  Wtunit,
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
  MaterialByCustomer,
  _mattext.Matlngtxt
}
