@EndUserText.label: 'Vendor Ledger'
@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
define table function ZV_VENDORLEDGER05
  with parameters
    @Environment.systemField: #CLIENT
    mandt : abap.clnt
returns
{
  key mandt              : abap.clnt;
  key accountingdocument : belnr_d;
  key companycode        : bukrs;
  key fiscalyear         : gjahr;
      poreference        : abap.char(255);

}
implemented by method
  zcl_vendledger_poref=>get_data;