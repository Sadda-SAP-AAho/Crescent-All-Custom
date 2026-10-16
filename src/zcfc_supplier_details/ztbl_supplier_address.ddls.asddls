@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Supplier Address'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_SUPPLIER_ADDRESS

returns
{
  key mandt      : mandt;
  key suppcode   : abap.char(10);
      StreetName : abap.char(100);
      CityName   : abap.char(50);
      Region     : abap.char(50);
      Country    : abap.char(30);
      PostalCode : abap.char(15);


}
implemented by method
  zcl_supp_address=>get_data;