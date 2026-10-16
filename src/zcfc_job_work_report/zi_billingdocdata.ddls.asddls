@AbapCatalog.sqlViewName: 'ZBILLINGDOCDATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Document Data'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_BILLINGDOCDATA
  as select distinct from ZI_MATDOCITEM         as a
    inner join            I_BillingDocumentItem as b on  a.MaterialDocument = b.ReferenceSDDocument
                                                     and a.RefDocumentItem  = b.ReferenceSDDocumentItem
    inner join            I_BillingDocument     as c on b.BillingDocument = c.BillingDocument
{
  key a.MaterialDocument,
  key a.MaterialDocumentYear,
  key a.MaterialDocumentItem,
  key a.RefDocumentItem as MatlDocItem,
  key c.BillingDocument,
  key a.PurchaseOrder,
  key a.PurchaseOrderItem,
      c.BillingDocumentDate,
      b.TransactionCurrency,
      b.NetAmount

}
