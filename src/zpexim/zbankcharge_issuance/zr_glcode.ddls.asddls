@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL Code F4 Help'
define view entity ZR_GLCODE 
       as select distinct from I_GLAccountTextRawData
{
    key GLAccount,
        GLAccountName 
}
where Language = 'E' and ChartOfAccounts = 'YCOA'
