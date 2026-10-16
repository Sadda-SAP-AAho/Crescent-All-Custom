@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for House Bank'
define root view entity ZR_Housebank 
as select distinct from I_HouseBankAccountLinkage
{
 key BankName,
 key HouseBank,
 key HouseBankAccount

}
group by  BankName,
          HouseBank,
          HouseBankAccount
