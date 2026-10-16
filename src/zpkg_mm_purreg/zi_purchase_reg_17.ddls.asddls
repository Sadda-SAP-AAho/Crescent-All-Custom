@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Reg - Delivery Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_17 
as select from I_PurchaseOrderItemAPI01 as a
inner join I_SuplrInvcItemPurOrdRefAPI01 as b on  b.PurchaseOrder = a.PurchaseOrder
                                              and b.PurchaseOrderItem   = a.PurchaseOrderItem
                                              and b.SuplrInvcDeliveryCostCndnType is not initial
inner join I_SupplierInvoiceAPI01        as c on  c.SupplierInvoice = b.SupplierInvoice
                                              and c.FiscalYear      = b.FiscalYear
                                              and c.ReverseDocument  is initial
inner join ZI_PURCHASE_REG_9            as d on  d.PurchaseOrder = a.PurchaseOrder
                                             and d.PurchaseOrderItem = a.PurchaseOrderItem
                                             and d.PurchasingHistoryDocument = b.SupplierInvoice    
                                             and d.PurchasingHistoryDocumentItem = right( b.SupplierInvoiceItem, 4 )
                                             and d.PurchasingHistoryDocumentYear = b.FiscalYear   
                                             
{
    a.PurchaseOrder,
    a.PurchaseOrderItem,
    b.SupplierInvoice,
    b.SupplierInvoiceItem,
    b.FiscalYear,
    b.SuplrInvcDeliveryCostCndnType,
    c.PostingDate,
    c.SupplierInvoiceIDByInvcgParty,
    c.DocumentDate,
    b.TaxCode,
    c.PaymentTerms,
    c.DueCalculationBaseDate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    d.PurOrdAmountInCompanyCodeCrcy,
    d.CompanyCodeCurrency
}
