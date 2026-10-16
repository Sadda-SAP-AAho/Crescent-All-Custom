@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register - History'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_8 
as select from I_PurchaseOrderHistoryAPI01 as a
{
    a.PurchaseOrder,
    a.PurchaseOrderItem,
    a.PurchasingHistoryDocumentYear,
    a.PurchasingHistoryDocument,
    a.PurchasingHistoryDocumentType,
    cast( a.PurchasingHistoryDocumentItem as abap.numc(4) ) as PurchasingHistoryDocumentItem,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum( case when a.DebitCreditCode = 'S' then a.PurOrdAmountInCompanyCodeCrcy
              when a.DebitCreditCode = 'H' then (-1 * PurOrdAmountInCompanyCodeCrcy ) end ) as PurOrdAmountInCompanyCodeCrcy,
   a.CompanyCodeCurrency
    
}
where a.PurchasingHistoryDocumentType = '2' or a.PurchasingHistoryDocumentType = '1' or a.PurchasingHistoryDocumentType = '3'
group by
a.PurchaseOrder,
a.PurchaseOrderItem,
a.PurchasingHistoryDocumentYear,
a.PurchasingHistoryDocument,
a.PurchasingHistoryDocumentItem,
a.CompanyCodeCurrency,
a.PurchasingHistoryDocumentType

union select from I_PurOrdHistDeliveryCostAPI01 as a
{
    a.PurchaseOrder,
    a.PurchaseOrderItem,
    a.PurchasingHistoryDocumentYear,
    a.PurchasingHistoryDocument,
    a.PurchasingHistoryDocumentType,
    cast( a.PurchasingHistoryDocumentItem as abap.numc(4) ) as PurchasingHistoryDocumentItem,
    sum( case when a.PurchasingHistoryDocumentType = '1' 
              then ( case when a.DebitCreditCode = 'H' then a.PurOrdAmountInCompanyCodeCrcy
                        when a.DebitCreditCode = 'S' then (-1 * PurOrdAmountInCompanyCodeCrcy ) end )
              else ( case when a.DebitCreditCode = 'S' then a.PurOrdAmountInCompanyCodeCrcy
                        when a.DebitCreditCode = 'H' then (-1 * PurOrdAmountInCompanyCodeCrcy ) end ) end ) as PurOrdAmountInCompanyCodeCrcy,
   a.CompanyCodeCurrency
    
}
where a.PurchasingHistoryDocumentType = '2' or a.PurchasingHistoryDocumentType = '1' or a.PurchasingHistoryDocumentType = '3'
group by
a.PurchaseOrder,
a.PurchaseOrderItem,
a.PurchasingHistoryDocumentYear,
a.PurchasingHistoryDocument,
a.PurchasingHistoryDocumentItem,
a.CompanyCodeCurrency,
a.PurchasingHistoryDocumentType
