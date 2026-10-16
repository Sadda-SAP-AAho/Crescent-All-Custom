@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for QC Status'
define table function ZTF_PURCHASE_REG_12

returns {
  key mandt                     : abap.clnt;
  key MaterialDocument          : abap.char(10);
  key MaterialDocumentItem      : abap.numc(4);
  key MaterialDocumentYear      : abap.numc(4);
      InspectionCodeText        : abap.char(40);
  
}
implemented by method zcl_pur_reg_qc=>get_data;