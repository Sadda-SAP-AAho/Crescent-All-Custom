@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Table Function For Inspection Details'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define table function ZTBL_FCTN_INSPECTIONQM

returns
{
  key mandt                        : abap.clnt;
  key material                     : matnr;
  key plant                        : werks_d;
      inspectionplangroup          : char8;
      inspectionplan               : char2;
      inspplanmatlassignment       : char8;
      inspplanmatlassgmtintversion : char8;
}
implemented by method
  zcl_insp_det=>get_data;