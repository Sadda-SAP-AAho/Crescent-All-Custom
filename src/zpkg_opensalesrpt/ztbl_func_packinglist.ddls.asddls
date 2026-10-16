@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'PL Sort'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FUNC_PACKLIST

returns
{
  key mandt                       : abap.clnt;
  key ReferenceSDDocument         : vgbel;
  key ReferenceSDDocumentItem     : vgpos;
      Createdon                   : sydate;
      Changedat                   : syuzeit;
      zdatetime                   : abap.char(14);
      packinglist                 : abap.char(10);

}

implemented by method
  zcl_pl_sort=>sort_data;