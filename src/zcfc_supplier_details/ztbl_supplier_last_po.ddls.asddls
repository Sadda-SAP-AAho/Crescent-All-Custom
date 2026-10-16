@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Supplier Last PO Details'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_SUPPLIER_LAST_PO

returns
{
  key mandt    : mandt;
  key suppcode : abap.char(10);
      pono     : abap.char(10);
      podate   : abap.dats;
      createby : abap.char(50);


}
implemented by method
  zcl_supp_last_po=>get_data;