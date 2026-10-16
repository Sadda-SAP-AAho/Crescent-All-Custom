@AbapCatalog.sqlViewName: 'ZDELINV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Vs Invoice Details'
define view ZCDS_DELI_INV 
as select distinct from I_BillingDocumentItem as a
inner join I_BillingDocument as b on b.BillingDocument = a.BillingDocument and b.BillingDocumentType = 'F2' and b.BillingDocumentIsCancelled <> 'X'
{
    a.ReferenceSDDocument,
    a.BillingDocument,
    b.BillingDocumentDate
    
}
group by
a.ReferenceSDDocument,
a.BillingDocument,
b.BillingDocumentDate
