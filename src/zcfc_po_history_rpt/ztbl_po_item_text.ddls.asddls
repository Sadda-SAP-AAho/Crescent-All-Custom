@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for PO Item Text'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_PO_ITEM_TEXT

returns

{
  key mandt             : mandt;
  key PurchaseOrder     : abap.char(10);
  key PurchaseOrderItem : abap.char(5);
  key TextObjectType    : abap.char(4);
  key Language          : abap.char(1);
      PlainLongText     : abap.char(254);

}
implemented by method
  zcl_po_itemtext=>get_data;