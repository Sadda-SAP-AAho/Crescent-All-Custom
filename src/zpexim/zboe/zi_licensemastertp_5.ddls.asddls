@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'License Master'
define view entity ZI_LicenseMasterTP_5

  as select from ZI_LicenseMasterTP_4
{
  key Licencenumber,
      Licencenumberext,
      Licencetype,
      Licencedate
//      @Semantics.amount.currencyCode: 'Currency'
//      ImportvalueusdV,
//      @Semantics.amount.currencyCode: 'Currency'
//      Usageamountfc,
//      Currency,
//      @Semantics.amount.currencyCode: 'Currency'
//      cast( case when Usageamountfc is not null then ImportvalueusdV - Usageamountfc
//      else ImportvalueusdV end as abap.curr(15,2) ) as BalanceAmount
}
