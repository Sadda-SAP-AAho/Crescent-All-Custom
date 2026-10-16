@EndUserText.label: 'Table Function for Contract Report'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.clientSafe: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTABL_payment_ref
//with parameters parameter_name : parameter_type
returns {
  client : abap.clnt;
  accountingdocument : abap.char( 10 );
  fiscalyear : gjahr;
  companycode : bukrs ;
  payref : abap.char( 100 );
  
}
implemented by method
  zcl_pay_data=>get_data;