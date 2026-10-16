@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Table Function for Concating PO'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FUNC_CONCATPO 

returns 
{
     key mandt              : abap.clnt;
     key deliverydocument   : vbeln;
         revision           : abap.numc(3); 
         zcuspodate         : abap.char(200);
}
implemented by method zcl_tbfunc_concatpo=>get_data;