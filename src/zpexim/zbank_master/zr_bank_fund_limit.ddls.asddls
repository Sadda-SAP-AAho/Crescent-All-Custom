@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Fund Limit'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BANK_FUND_LIMIT
  as select distinct from zexim_lcim_bnk1           as a
    inner join            zdt_fundgl_bnk            as b on  a.hbkid = b.hbkid
                                                         and a.hktid = b.hktid
    inner join            I_OperationalAcctgDocItem as c on  a.bukrs     = c.CompanyCode
                                                         and b.glaccount = c.GLAccount

{

  key a.bukrs as Bukrs,
  key a.hbkid as Hbkid,
  key a.hktid as Hktid,
  key b.loantype,
  key c.AccountingDocument,
  key c.FiscalYear,
  key c.AccountingDocumentItem,
      c.GLAccount,
      c.CompanyCodeCurrency,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      c.AmountInCompanyCodeCurrency * -1  as AmountInCompanyCodeCurrency


}
