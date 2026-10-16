@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for Debtors report'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_DEBTOR_RPT_1

returns
{
  key mandt              : mandt;
  key arinv              : abap.char(10);
      billingdocument    : abap.char(500);
      billingdocumentref : abap.char(500);

}
implemented by method
  zcl_debtor_rpt_1=>get_data;