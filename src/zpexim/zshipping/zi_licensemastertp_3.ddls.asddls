@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '3 of ZI_LicenseMasterTP'
define view entity ZI_LicenseMasterTP_3
  as select from ZI_LicenseMasterTP_2
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
