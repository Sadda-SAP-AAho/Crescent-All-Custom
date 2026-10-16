@AbapCatalog.sqlViewName: 'ZIBANKGL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank GL'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_BANKGL
  as select from I_GLAccount

  association [0..*] to I_GlAccountTextInCompanycode as _Text                       on  $projection.CompanyCode = _Text.CompanyCode
                                                                                    and $projection.GLAccount   = _Text.GLAccount
                                                                                    and _Text.Language = 'E'   
{
  key GLAccount,
      CompanyCode,
      _Text.GLAccountLongName,
      ChartOfAccounts,
      GLAccountGroup,
      CorporateGroupAccount,
      AccountIsBlockedForPosting,
      AccountIsBlockedForPlanning,
      AccountIsBlockedForCreation,
      IsBalanceSheetAccount,
      AccountIsMarkedForDeletion,
      PartnerCompany,
      FunctionalArea,
      CreationDate,
      SampleGLAccount,
      IsProfitLossAccount,
      GLAccountType,
      CreatedByUser,
      ProfitLossAccountType,
      ReconciliationAccountType,
      LineItemDisplayIsEnabled,
      IsOpenItemManaged,
      AlternativeGLAccount,
      AcctgDocItmDisplaySequenceRule,
      GLAccountExternal,
      CountryChartOfAccounts,
      AuthorizationGroup,
      TaxCategory,
      IsAutomaticallyPosted,
      CompanyCodeName
}
where
      GLAccountType = 'C'
  and CompanyCode   = '1000'
