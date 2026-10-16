@AbapCatalog.sqlViewName: 'ZCDS_HOUSEBANK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view of House bank'
define view zi_housebank
  as select from    I_HouseBankAccountLinkage as a
    left outer join zexim_lcim_bnk1           as b on  b.bukrs = a.CompanyCode
                                                   and b.hbkid = a.HouseBank
                                                   and b.zaccno = a.BankAccountNumber


{
  key a.CompanyCode,
  key a.HouseBank,
  key a.HouseBankAccount,
      a.BankAccountInternalID,
      a.BankInternalID,
      a.BankCountry,
      a.SWIFTCode,
      a.BankName,
      a.BankNumber,
      a.BankAccount,
      a.BankAccountAlternative,
      a.ReferenceInfo,
      a.BankControlKey,
      a.BankAccountCurrency,
      a.IBAN,
      a.BankAccountDescription,
      a.GLAccount,
      a.BankAccountHolderName,
      a.BankAccountNumber,
      /* Associations */
      a._BankAccount,
      a._CompanyCode,
      a._HouseBank,
      b.bgcleanavailable,
      b.bgcleanutilised,
      b.bglimit
}
