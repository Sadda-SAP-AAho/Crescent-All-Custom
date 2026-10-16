@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for Hard Coke Report'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_GRPO_RPT

returns
{
  key mandt                 : abap.clnt;
  key MaterialDocument      : abap.char(10);
  key MaterialDocumentItem  : abap.numc(4);
  key MaterialDocumentYear  : gjahr;
      YY1_ChallanNumber_MMI : abap.char(30);
      YY1_ChallanDate_MMI   : sydate;

}
implemented by method
  zcl_grpo=>get_data;