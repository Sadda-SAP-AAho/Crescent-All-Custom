@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for sale note ref no'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_SALENOTEREF 
as select distinct from I_BillingDocumentItem as a 
left outer join ZI_DELDASH_HDR as b on a.ReferenceSDDocument = b.Delivery
{
    key a.BillingDocument,
        b.Delivery,
        b.Revision,
        b.Salesnoteref    
}
where a.ReferenceSDDocumentCategory = 'J' and b.Canind is initial
