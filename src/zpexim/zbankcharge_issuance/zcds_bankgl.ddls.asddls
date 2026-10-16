@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View help for Bank Gl'
define view entity ZCDS_BANKGL
 as select distinct from I_GLAccount as a
inner join I_GLAccountTextRawData as b on a.GLAccount = b.GLAccount
 
{  
  key  a.GLAccount,
  key  b.GLAccountName,
  key  a.CompanyCode
}
where a.ChartOfAccounts = 'YCOA' and a.CompanyCode = '1000'
and a.GLAccountType = 'C' and b.Language = 'E'
