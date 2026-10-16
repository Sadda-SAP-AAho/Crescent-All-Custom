@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_LicenseMasterTP_7'
define view entity ZI_LicenseMasterTP_7

  as select from ZI_LicenseMasterTP_6
{
  key Licencenumber,
      Licencetype,
      Licencedate,
      @Semantics.amount.currencyCode: 'Currency'
      ExportvalueusdV,
      @Semantics.amount.currencyCode: 'Currency'
      Usageamountfc,
      Currency,
      @Semantics.amount.currencyCode: 'Currency'
      cast( case when Usageamountfc is not null then ExportvalueusdV - Usageamountfc
      else ExportvalueusdV end as abap.curr(15,2) ) as BalanceAmount
}
