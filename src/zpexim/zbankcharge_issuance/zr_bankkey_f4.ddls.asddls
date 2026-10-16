@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank key F4'
define view entity ZR_BANKKEY_F4
       as select distinct from I_Bank_2
{
    key BankInternalID,
    key BankName
}
