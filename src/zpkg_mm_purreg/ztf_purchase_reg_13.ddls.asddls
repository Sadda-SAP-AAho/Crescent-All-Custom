@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Purchase Register - Long Text'
define table function ZTF_PURCHASE_REG_13
//  with parameters
//    @Environment.systemField: #CLIENT
//    mandt :abap.clnt
returns
{
  key mandt                     : abap.clnt;
  key PurchaseOrder             : ebeln;
  key PurchaseOrderItem         : ebelp;
      PlainLongText             : abap.char( 200 );    
}
implemented by method
  zcl_pur_reg_polt=>get_data;