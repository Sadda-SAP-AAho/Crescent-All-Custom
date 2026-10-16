@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.clientSafe: true
@EndUserText.label: 'Table Function For DomesticDraft PL Item'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_LCDETAILS
//  with parameters
//    @Environment.systemField: #CLIENT
//    mandt : abap.clnt
returns
{
  key mandt                       : abap.clnt;
  key  BillingDocument            : vbeln;
       Lc_Refnr                   : abap.char(10);
       Version                    : abap.char(1);
       Lc_Appl                    : abap.char(40);
       Lc_Open_Dt                 : sydate;
       Banka                      : abap.char(60);
}

implemented by method
  zcl_lcdetails=>sort_data;