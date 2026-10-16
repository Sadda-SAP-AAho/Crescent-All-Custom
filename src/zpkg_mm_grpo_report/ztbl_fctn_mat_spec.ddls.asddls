@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for Hard Coke Report'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_MAT_SPEC

returns
{
  key mandt                   : abap.clnt;
  key Material                : abap.char(10);
  key Plant                   : abap.numc(4);
  key inspectionspecification : abap.char(8);
      INSPSPECUPPERLIMIT      : abap.dec(13,3);
      INSPSPECLOWERLIMIT      : abap.dec(13,3);

}
implemented by method
  zcl_mat_spec=>get_data;