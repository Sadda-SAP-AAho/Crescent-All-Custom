@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for PO by customer'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_POBYCUST 
as select distinct from I_BillingDocument as a
left outer join I_BillingDocumentItem as b on a.BillingDocument = b.BillingDocument
left outer join I_SalesOrderItem  as q on  b.SalesDocument = q.SalesOrder
                                       and b.SalesDocumentItem  = q.SalesOrderItem
{

key b.BillingDocument,
    q.PurchaseOrderByCustomer

}
where
 a.BillingDocumentType  =  'F8' and a.AccountingPostingStatus <> 'E'
group by
    b.BillingDocument,
    q.PurchaseOrderByCustomer
