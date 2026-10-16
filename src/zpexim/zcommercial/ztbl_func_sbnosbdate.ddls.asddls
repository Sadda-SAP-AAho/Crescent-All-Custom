@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Multiple SB No and Date'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FUNC_SBNOSBDATE 
//with parameters
//    @Environment.systemField: #CLIENT
//    mandt : abap.clnt
returns 
{
     key mandt              : abap.clnt;
     key comminv            : vbeln;
         zsbnosbdate        : abap.char(200); 
}
implemented by method zcl_tbfunc_sbnodate=>get_data;
