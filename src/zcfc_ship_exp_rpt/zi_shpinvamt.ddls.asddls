@AbapCatalog.sqlViewName: 'ZSHPINVAMT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Shipping Inv Amt'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SHPINVAMT
  as select distinct from I_ServiceEntrySheetAPI01      as a
    inner join   I_ServiceEntrySheetItemAPI01  as b on  a.PurchaseOrder     =  b.PurchaseOrder
                                                    and a.ServiceEntrySheet =  b.ServiceEntrySheet
                                                    and a.IsDeleted         <> 'X'

    inner join   I_SuplrInvcItemPurOrdRefAPI01 as g on  a.PurchaseOrder     = g.PurchaseOrder
                                                    and b.PurchaseOrderItem = g.PurchaseOrderItem
                                                    and b.ServiceEntrySheet = g.ReferenceDocument

{
  key    a.ServiceEntrySheetName                                       as Commid,
         b.ServiceEntrySheet,
         b.PurchaseOrder                                               as Servicepo,
         b.PurchaseOrderItem                                           as Servicepoline,
         g.SupplierInvoice,
         g.SupplierInvoiceItem,
         g.FiscalYear,
         g.DocumentCurrency,
         cast ( sum(g.SupplierInvoiceItemAmount) as abap.dec( 13, 3 )) as InvAmt

}

group by
  a.ServiceEntrySheetName,
  b.ServiceEntrySheet,
  b.PurchaseOrder,
  b.PurchaseOrderItem,
  g.SupplierInvoice,
  g.SupplierInvoiceItem,
  g.FiscalYear,
  g.DocumentCurrency
