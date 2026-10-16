@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'for Multiple Sale Note Ref'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FUNC_SALENOTEREF 
returns 
{
     key mandt              : abap.clnt;
     key BillingDocument    : vbeln;
         Salesnoteref       : abap.char(200); 
}
implemented by method zcl_tbfunc_salenoteref=>get_data;
