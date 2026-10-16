@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank F4 view help'
define view entity ZCDS_BANKF4 
as select distinct from I_HouseBankAccountLinkage
{
  key BankName
}
group by BankName
