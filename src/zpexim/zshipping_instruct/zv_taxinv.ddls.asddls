@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for invoice'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_TAXINV as select from 
I_BillingDocument as a 
left outer join I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
                                           and b.BillingDocumentType = 'F8'
                                           and a.AccountingPostingStatus <> 'E'
{

 key  b.ReferenceSDDocument,
      b.BillingDocument,
      b.BillingDocumentDate
}
