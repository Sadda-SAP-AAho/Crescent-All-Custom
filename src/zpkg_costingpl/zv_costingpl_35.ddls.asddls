@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_35

  as select distinct from I_BillingDocument             as a

    inner join            I_ServiceEntrySheetAPI01      as b on b.ServiceEntrySheetName = a.BillingDocument

    inner join            I_ServiceEntrySheetItemAPI01  as d on d.ServiceEntrySheet = b.ServiceEntrySheet

    inner join            I_SuplrInvcItemPurOrdRefAPI01 as c on c.PurchaseOrder = b.PurchaseOrder
{
  key       a.BillingDocument,
  key       b.ServiceEntrySheet,
  key       d.ServiceEntrySheetItem,
  key       c.SupplierInvoice,
  key       c.FiscalYear,
            concat( c.SupplierInvoice, c.FiscalYear )                                      as OriginalReference,
            b.ServiceEntrySheetName,
            c.PurchaseOrder,
            c.PurchaseOrderItem,
            b.MaterialDocument,
            b.MaterialDocumentYear,
            substring( d.ServiceEntrySheetItem, 2, 4 )                                     as ServiceEntrySheetItem1,
            concat( c.FiscalYear, concat( b.ServiceEntrySheet, d.ServiceEntrySheetItem ) ) as Reference3


}
