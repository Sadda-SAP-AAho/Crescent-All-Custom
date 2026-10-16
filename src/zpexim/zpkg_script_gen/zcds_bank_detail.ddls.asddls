@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for bank detail'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_BANK_DETAIL 
as select distinct 
    from I_BusinessPartnerBank as a 
    inner join I_Bank_2        as c on a.BankNumber = c.BankInternalID
{
    key a.BusinessPartner,
        c.BankInternalID,
        c.BankName,
        c.StreetName,
        c.CityName,
        c.SWIFTCode,
        a.BankAccount as bankaccno
}
