@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Invoice'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FUCN_ITEMINV

returns
{
  key client      : mandt;
  key InvoiceNo   : abap.char( 10 );
  key FiscalYear  : abap.numc( 4 );
      Item        : abap.numc( 3 );
      Description : abap.char( 50 );
      HSNCode     : abap.char( 16 );
      UOM         : abap.cuky( 5 );
      Amount      : abap.dec( 23 , 2 );
      IGSTAmount  : abap.dec( 23 , 2 );
      Total       : abap.dec( 23 , 2 );

}
implemented by method
  zcl_serinv_item_print=>get_data;