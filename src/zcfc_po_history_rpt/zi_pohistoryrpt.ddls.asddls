@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO History - Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_POHISTORYRPT
  as select distinct from I_PurchaseOrderHistoryAPI01  as a
    left outer join       ZI_ACCDOCNO                  as b on  a.PurchaseOrder             = b.PurchaseOrder
                                                            and a.PurchaseOrderItem         = b.PurchaseOrderItem
                                                            and a.PurchasingHistoryDocument = b.MaterialDocument
    left outer join       I_SupplierInvoiceAPI01       as c on a.PurchasingHistoryDocument = c.SupplierInvoice
    left outer join       I_Product                    as d on a.Material = d.Product
    left outer join       I_ProductGroupText_2         as e on  d.ProductGroup = e.ProductGroup
                                                            and e.Language     = 'E'
    left outer join       I_PurchaseOrderAPI01         as f on a.PurchaseOrder = f.PurchaseOrder
    left outer join       I_PurchasingDocumentTypeText as g on  f.PurchaseOrderType = g.PurchasingDocumentType
                                                            and g.Language          = 'E'
    left outer join       ZTBL_PO_ITEM_TEXT            as h on  a.PurchaseOrder     = h.PurchaseOrder
                                                            and a.PurchaseOrderItem = h.PurchaseOrderItem
                                                            and h.Language          = 'E'
{
  key  a.PurchaseOrder,

  key  g.PurchasingDocumentTypeName                                                                                               as POType,

  key  a.Material,

  key  e.ProductGroupName                                                                                                         as matgrp,

  key  a.ReferenceDocument,

  key  (case when a.PurchasingHistoryCategory = '0' then 'Service Entry Sheet'
             when a.PurchasingHistoryCategory = 'E' then 'Goods Receipt'
             when a.PurchasingHistoryCategory = 'Q' then 'Invoice Receipt' end)                                                   as PurchasingHistoryCategory,

  key  a.PurchaseOrderItem,

  key  a.AccountAssignmentNumber,

  key  a.PurchasingHistoryDocumentYear,

  key  a.PurchasingHistoryDocument,

  key  a.PurchasingHistoryDocumentItem,

  key  a.PurchasingHistoryDocumentType,

       b.AccountingDocument,

       f.CorrespncInternalReference                                                                                               as OurRef,

       h.PlainLongText                                                                                                            as POItemText,

       a.Plant,

       a.PurchaseOrderQuantityUnit,

       @Semantics.quantity.unitOfMeasure:'PurchaseOrderQuantityUnit'
       (case when a.DebitCreditCode = 'H' then (a.Quantity * (-1)) else a.Quantity end)                                           as Quantity,

       a.PostingDate,

       a.DocumentDate,

       a.AccountingDocumentCreationDate,

       a.GoodsMovementType,

       a.Currency,

       @Semantics.amount.currencyCode: 'Currency'
       a.PurchaseOrderAmount,

       a.DocumentCurrency,

       a.CompanyCodeCurrency,

       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       a.PurOrdAmountInCompanyCodeCrcy,

       a.DebitCreditCode,

       @Semantics.amount.currencyCode: 'DocumentCurrency'
       (case when a.DebitCreditCode = 'H'then ( a.InvoiceAmtInPurOrdTransacCrcy * (-1)) else a.InvoiceAmtInPurOrdTransacCrcy end) as Invamtpocurr,


       ( case when a.PurchasingHistoryCategory = 'Q'
              then ( case when c.IsInvoice = 'X' then 'Invoice' else 'Cr Note' end )
         else '' end )                                                                                                            as Document_Type


}
