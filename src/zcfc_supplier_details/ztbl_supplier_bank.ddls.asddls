@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Supplier Bank Details'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_SUPPLIER_BANK
returns
{
  key mandt                 : mandt;
  key BusinessPartner       : abap.char(10);
      BankNumber            : abap.char(20);
      BankAccount           : abap.char(20);
      BankAccountHolderName : abap.char(100);



}
implemented by method
  zcl_supp_bank=>get_data;