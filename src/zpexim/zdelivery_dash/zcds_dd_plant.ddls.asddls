@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for plant'
define view entity ZCDS_DD_PLANT
  as select distinct from I_DeliveryDocument     as a
    inner join            I_DeliveryDocumentItem as b on a.DeliveryDocument = b.DeliveryDocument
{
  key b.DeliveryDocument,
  key b.Plant,
  key a.SalesOrganization
      
}
