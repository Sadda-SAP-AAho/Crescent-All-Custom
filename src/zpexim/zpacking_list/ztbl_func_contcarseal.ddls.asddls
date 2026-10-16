@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'multiple cont no and car seal no'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.clientSafe: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_CONTCARSEAL
//with parameters
//@Environment.systemField: #CLIENT
//mandt : abap.clnt
returns {
  key mandt                       : abap.clnt;
  key billingdocument             : vbeln;
      contnos                     : abap.char(200);
      carsealnos                  : abap.char(200);
  
  
}

implemented by method zcl_tbfunc_contseal=>get_data;