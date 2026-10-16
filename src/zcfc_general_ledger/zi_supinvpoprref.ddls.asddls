@AbapCatalog.sqlViewName: 'ZSUPINVPOPRREF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Supp. Inv PO PR Ref'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SUPINVPOPRREF
  as select distinct from I_JournalEntryItem             as a
    inner join            I_SuplrInvcItemPurOrdRefAPI01  as b on  a.ReferenceDocument     = b.SupplierInvoice
                                                              and a.ReferenceDocumentItem = b.SupplierInvoiceItem
    inner join            I_PurchaseOrderItemAPI01       as c on  b.PurchaseOrder     = c.PurchaseOrder
                                                              and b.PurchaseOrderItem = c.PurchaseOrderItem
    inner join            I_PurchaseRequisitionItemAPI01 as d on  c.PurchaseRequisition     = d.PurchaseRequisition
                                                              and c.PurchaseRequisitionItem = d.PurchaseRequisitionItem
//    inner join            ZC_PURCHASE_REG                as e on  e.PurchaseRequisition     = d.PurchaseRequisition
//                                                              and e.PurchaseRequisitionItem = d.PurchaseRequisitionItem

{
  key a.GLAccount,
  key a.AccountingDocument          as JournalEntry,
      a.FiscalYear                  as FiscalYear,
      b.SupplierInvoice             as SupplInvNo,
      c.PurchaseOrder               as PONo,
      c.PurchaseOrderItem           as POItem,
      d.PurchaseRequisition         as PRNo,
      d.PurchaseRequisitionItem     as PRItem,
      d.PurchaseRequisitionItemText as PRShortText--,
//      e.Prtext                      as PRItemText


}
where
  a.GLAccount = '0048400030'
