@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for MIGO Custom Fields'
define table function ZTF_PURCHASE_REG_5
//with parameters
//@Environment.systemField: #CLIENT
//    mandt :abap.clnt
returns {
  key mandt                     : abap.clnt;
  key MaterialDocument          : abap.char(10);
  key MaterialDocumentItem      : abap.numc(4);
  key MaterialDocumentYear      : abap.numc(4);
  YY1_GateEntryNumber_MMI       : abap.numc(10);
  YY1_ChallanQuantity_MMI       : abap.dec( 13,3 );
  YY1_TareWeight_MMI            : abap.dec( 13,3 );
  YY1_NetWeight_MMIU            : meins;
  YY1_GrossWeight_MMI           : abap.dec( 13,3 );
  YY1_NetWeight_MMI             : abap.dec( 13,3 );
  YY1_VehicleNumber_MMI         : abap.char(30);
    
}
implemented by method zcl_pur_reg_grn=>get_data;