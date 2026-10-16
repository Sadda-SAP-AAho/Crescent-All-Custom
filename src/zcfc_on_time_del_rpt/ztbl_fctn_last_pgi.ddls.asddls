@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for Last PGI Data'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_LAST_PGI
returns
{
  key mandt          : mandt;
  key SalesOrder     : abap.char(10);
  key SalesOrderItem : abap.char(6);
      PGINo          : abap.char(10);
      PGIDate        : sydate;

}
implemented by method
  zcl_last_pgi=>get_data;