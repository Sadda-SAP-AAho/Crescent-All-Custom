@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VALUE HELP FOR CURRENCIES'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZVH_CURRENCIES as select from I_Currency
{
    key Currency,
    CurrencyISOCode
}
