@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for plant and billingdoc'
define view entity ZCDS_PLANT
  as select distinct from I_BillingDocument     as a
    inner join            I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
{
  key b.BillingDocument,
  key b.Plant,
  key a.CompanyCode,
      a.CreationDate,
      a.CreationTime
}
