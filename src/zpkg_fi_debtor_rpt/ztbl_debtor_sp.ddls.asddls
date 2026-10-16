@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for Debtors report'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_DEBTOR_SP

returns
{
  key mandt           : mandt;
  key billingdocument : abap.char(10);
      salesperson     : abap.char(500);
}
implemented by method
  zcl_debtor_sp=>get_data;