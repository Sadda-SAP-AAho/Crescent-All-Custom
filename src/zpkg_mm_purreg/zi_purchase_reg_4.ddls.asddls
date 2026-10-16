@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register - GRN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_4
  as select from    I_MaterialDocumentItem_2   as a
    inner join      I_MaterialDocumentHeader_2 as b on  b.MaterialDocument     = a.MaterialDocument
                                                    and b.MaterialDocumentYear = a.MaterialDocumentYear
    left outer join ZI_PURCHASE_REG_14         as c on c.WBSElementInternalID = a.WBSElementInternalID
    inner join      ZI_PURCHASE_REG_10         as d on  d.PurchaseOrder                 = a.PurchaseOrder
                                                    and d.PurchaseOrderItem             = a.PurchaseOrderItem
                                                    and d.PurchasingHistoryDocument     = a.MaterialDocument
                                                    and d.PurchasingHistoryDocumentItem = right(
      a.MaterialDocumentItem, 4
    )
                                                    and d.PurchasingHistoryDocumentYear = a.MaterialDocumentYear
    left outer join ZTF_PURCHASE_REG_12        as i on  i.MaterialDocument     = a.MaterialDocument
                                                    and i.MaterialDocumentItem = a.MaterialDocumentItem
                                                    and i.MaterialDocumentYear = a.MaterialDocumentYear
{
  key a.MaterialDocument,
  key a.MaterialDocumentItem,
  key a.MaterialDocumentYear,
      a.PurchaseOrder,
      a.PurchaseOrderItem,
      b.PostingDate,
      case when a.GoodsMovementType = '101' then cast( a.QuantityInEntryUnit as abap.dec( 13, 3 ) )
           when ( a.GoodsMovementType = '122' or a.GoodsMovementType = '161' )
           then cast( ( -1 * a.QuantityInEntryUnit ) as abap.dec( 13, 3 ) )
           else cast( 0 as abap.dec( 13, 3 ) ) end as QuantityInEntryUnit,
      a.GLAccount,
      a.WBSElementInternalID,
      c.ProjectElement,
      c.ProjectElementDescription,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency1'
      d.PurOrdAmountInCompanyCodeCrcy              as PurOrdAmountInCompanyCodeCrcy1,
      d.CompanyCodeCurrency                        as CompanyCodeCurrency1,
      i.InspectionCodeText

}
where
       a.GoodsMovementIsCancelled <> 'X'
  and  a.ReversedMaterialDocument is initial
  and(
       a.GoodsMovementType        =  '101'
    or a.GoodsMovementType        =  '122'
    or a.GoodsMovementType        =  '161'
  )
