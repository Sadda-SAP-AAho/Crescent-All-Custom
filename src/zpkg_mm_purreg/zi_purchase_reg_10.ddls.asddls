@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register - History GRN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_10 
as select from ZI_PURCHASE_REG_8
{
    PurchaseOrder,
    PurchaseOrderItem,
    PurchasingHistoryDocumentYear,
    PurchasingHistoryDocument,
    PurchasingHistoryDocumentItem,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum( PurOrdAmountInCompanyCodeCrcy ) as PurOrdAmountInCompanyCodeCrcy,
    CompanyCodeCurrency
}
where PurchasingHistoryDocumentType = '1'
group by
PurchaseOrder,
PurchaseOrderItem,
PurchasingHistoryDocumentYear,
PurchasingHistoryDocument,
PurchasingHistoryDocumentItem,
CompanyCodeCurrency
