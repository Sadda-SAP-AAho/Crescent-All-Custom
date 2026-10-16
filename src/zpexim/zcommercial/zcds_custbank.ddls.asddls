@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for plant and billingdoc'
@Metadata.allowExtensions: true
define view entity ZCDS_CUSTBANK

  as select distinct from I_BillingDocument     as a
    inner join            I_BusinessPartnerBank as b on a.PayerParty = b.BusinessPartner
    inner join            I_Bank_2              as c on b.BankNumber = c.BankInternalID
{
  key a.BillingDocument,
  key a.PayerParty,
  key b.BankName,
  key c.StreetName,
  key c.CityName

}
