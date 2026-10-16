@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for address details for PL'
define root view entity ZCDS_DOMDRAFTPL 
as select distinct from I_DeliveryDocument as a
     inner join I_DeliveryDocumentItem as b on a.DeliveryDocument = b.DeliveryDocument
{
   key b.DeliveryDocument,
   key b.Plant,
   key a.SalesOrganization // Make association public
}
