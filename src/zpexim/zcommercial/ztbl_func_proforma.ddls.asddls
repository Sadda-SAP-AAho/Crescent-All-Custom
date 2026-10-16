@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Table Function for Proforma Inv'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FUNC_PROFORMA 
//with parameters
//    @Environment.systemField: #CLIENT
//    mandt : abap.clnt
returns 
{
     key mandt              : abap.clnt;
     key comminv            : vbeln;
         proinv             : abap.char(200); 
}
implemented by method zcl_tbfunc_proinv=>get_data;
