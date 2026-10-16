@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank key & Bank Name F4'
define view entity ZR_BANKF4_RATE
       as select distinct from I_Bank_2
{
    key BankName
}

