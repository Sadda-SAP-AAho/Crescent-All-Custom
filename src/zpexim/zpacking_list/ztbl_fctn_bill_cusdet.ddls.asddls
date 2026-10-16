@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.clientSafe: true
@EndUserText.label: 'Table Func for Billing wise Cust Det'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_BILL_CUSDET
//with parameters
//@Environment.systemField: #CLIENT
//mandt : abap.clnt
returns {
  key mandt                       : abap.clnt;
  key BillingDocument             : vbeln_vl;
  key customer                    : kunnr;
  key pfunc                       : abap.char(2);
      cusname                     : abap.char(100);
      address                     : abap.char(300);
      streetname                  : abap.char(100);
      shipinsadd                  : abap.char(100);
      country                     : abap.char(10);
      countryname                 : abap.char(50);
      region                      : abap.char(50);
}
implemented by method zcl_bill_cus=>get_data;