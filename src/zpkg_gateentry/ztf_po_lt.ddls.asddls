@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'PO Long Text'
define table function ZTF_PO_LT

returns {
  key mandt                     : abap.clnt;
  key PurchaseOrder             : ebeln;
  key PurchaseOrderItem         : ebelp;
      PlainLongText             : abap.char( 200 );   
}
implemented by method zcl_polt=>get_data;