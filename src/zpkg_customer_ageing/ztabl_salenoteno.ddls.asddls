@EndUserText.label: 'Table Function for Sale Note Number'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
define table function ZTABL_SALENOTENO

returns {
  client : abap.clnt;
  billdoc : vbeln;
  salenoteno : abap.char( 100 );
  
}
implemented by method zcl_salenoteno=>get_data;