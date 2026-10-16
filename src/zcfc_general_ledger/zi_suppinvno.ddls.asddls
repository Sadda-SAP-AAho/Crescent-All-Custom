@AbapCatalog.sqlViewName: 'ZSUPPINVNO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Supplier Inv No'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SUPPINVNO
  as select distinct from I_JournalEntryItem            as a
    inner join            I_SuplrInvcItemPurOrdRefAPI01 as b on  a.ReferenceDocument     = b.SupplierInvoice
                                                             and a.ReferenceDocumentItem = b.SupplierInvoiceItem
    inner join            I_PurchaseOrderItemAPI01      as c on  b.PurchaseOrder     = c.PurchaseOrder
                                                             and b.PurchaseOrderItem = c.PurchaseOrderItem
{
  key a.GLAccount,
  key a.AccountingDocument as JournalEntry,
      a.FiscalYear         as FiscalYear,
      b.SupplierInvoice    as SupplInvNo,
      c.PurchaseOrder      as PONo,
      c.PurchaseOrderItem  as POItem

}

union

select distinct from ZI_JournalEntryItem_H         as a
  inner join         I_MaterialDocumentItem_2      as b on  a.ReferenceDocument = b.MaterialDocument
                                                        and a.RefDocItem4       = b.MaterialDocumentItem
  inner join         I_PurchaseOrderItemAPI01      as c on  b.PurchaseOrder     = c.PurchaseOrder
                                                        and b.PurchaseOrderItem = c.PurchaseOrderItem
  inner join         I_SuplrInvcItemPurOrdRefAPI01 as d on  c.PurchaseOrder     = d.PurchaseOrder
                                                        and c.PurchaseOrderItem = d.PurchaseOrderItem
{
  key a.GLAccount,
  key a.AccountingDocument as JournalEntry,
      a.FiscalYear         as FiscalYear,
      d.SupplierInvoice    as SupplInvNo,
      c.PurchaseOrder      as PONo,
      c.PurchaseOrderItem  as POItem
}
