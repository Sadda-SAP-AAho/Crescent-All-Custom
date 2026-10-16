@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function of Booking Date Ex. Rate'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_BKNG_EX_RATE
returns
{
  key mandt             : mandt;
  key compcode          : abap.char(4);
  key fy                : abap.char(4);
  key jeno              : abap.char(10);
  key SourceCurrency    : abap.char(3);
  key TargetCurrency    : abap.char(3);
      ValidityStartDate : abap.dats; 

}

implemented by method
  zcl_bkng_ex_rate=>GET_DATA;