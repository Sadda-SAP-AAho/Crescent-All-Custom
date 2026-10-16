@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Document Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MATDOCRPT
  as select distinct from I_MaterialDocumentHeader_2   as a
    inner join            I_MaterialDocumentItem_2     as b on  a.MaterialDocument     = b.MaterialDocument
                                                            and a.MaterialDocumentYear = b.MaterialDocumentYear
    left outer join       I_ProductText                as c on b.Material = c.Product
    inner join            I_Plant                      as d on b.Plant = d.Plant
    left outer join       I_StorageLocation            as e on  b.StorageLocation = e.StorageLocation
                                                            and b.Plant           = e.Plant
    left outer join       I_InventoryStockTypeT        as f on  b.InventoryStockType = f.InventoryStockType
                                                            and f.Language           = 'E'
    left outer join       I_Product                    as g on b.Material = g.Product
    left outer join       I_ProductGroupText_2         as h on  g.ProductGroup = h.ProductGroup
                                                            and h.Language     = 'E'
    left outer join       I_CostCenterText             as i on  b.CostCenter = i.CostCenter
                                                            and i.Language   = 'E'
    inner join            I_BusinessUserBasic          as l on a.CreatedByUser = l.UserID
    left outer join       I_AccountingDocumentTypeText as m on  a.AccountingDocumentType = m.AccountingDocumentType
                                                            and m.Language               = 'E'
    left outer join       I_DebitCreditCodeText        as n on  b.DebitCreditCode = n.DebitCreditCode
                                                            and n.Language        = 'E'
    left outer join       I_GLAccountText              as o on  b.GLAccount = o.GLAccount
                                                            and o.Language  = 'E'
    left outer join       I_ProductTypeText_2          as p on  g.ProductType = p.ProductType
                                                            and p.Language    = 'E'
    left outer join       I_ProductPlantBasic          as q on  b.Material = q.Product
                                                            and b.Plant    = q.Plant
    left outer join       I_ProfitCenterText           as r on q.ProfitCenter = r.ProfitCenter



{
  key a.MaterialDocument,
  key a.MaterialDocumentYear,
  key b.MaterialDocumentItem,
  key b.Material,
      c.ProductName,
      b.Plant,
      d.PlantName,
      b.StorageLocation,
      e.StorageLocationName,
      b.InventoryStockType,
      f.InventoryStockTypeName,
      g.ProductType,
      p.ProductTypeName,
      g.ProductGroup,
      h.ProductGroupName,
      b.CostCenter,
      i.CostCenterName,
      q.ProfitCenter,
      r.ProfitCenterName,
      b.GLAccount,
      o.GLAccountName,
      b.GoodsMovementType,
      (case when b.GoodsMovementType = '101' then 'GR goods receipt'
      when b.GoodsMovementType = '102' then 'GR for PO reversal'
      when b.GoodsMovementType = '122' then 'RE return to vendor'
      when b.GoodsMovementType = '123' then 'RE rtrn vendor rev.'
      when b.GoodsMovementType = '161' then 'GR returns'
      when b.GoodsMovementType = '201' then 'GI for cost center'
      when b.GoodsMovementType = '202' then 'RE for cost center'
      when b.GoodsMovementType = '261' then 'GI for order'
      when b.GoodsMovementType = '262' then 'RE for order'
      when b.GoodsMovementType = '301' then 'TF trfr plnt to plnt'
      when b.GoodsMovementType = '309' then 'TF tfr ps.mat.to mat'
      when b.GoodsMovementType = '310' then 'TR tfr ps.mat.to mat'
      when b.GoodsMovementType = '311' then 'TF trfr within plant'
      when b.GoodsMovementType = '313' then 'TF rem.fm str.toSLoc'
      when b.GoodsMovementType = '315' then 'TF pl.in str.in SLoc'
      when b.GoodsMovementType = '321' then 'TF quality to unrest'
      when b.GoodsMovementType = '343' then 'TF blocked to unre.'
      when b.GoodsMovementType = '344' then 'TR blocked to unre.'
      when b.GoodsMovementType = '501' then 'Receipt w/o PO'
      when b.GoodsMovementType = '502' then 'RE receipt w/o PO'
      when b.GoodsMovementType = '531' then 'Receipt by-product'
      when b.GoodsMovementType = '532' then 'RE by-product'
      when b.GoodsMovementType = '541' then 'GI whse to subc.stck'
      when b.GoodsMovementType = '542' then 'RE subctrStck toWhse'
      when b.GoodsMovementType = '601' then 'GD goods issue:delvy'
      when b.GoodsMovementType = '602' then 'RE goods deliv. rev.'
      when b.GoodsMovementType = '641' then 'TF to stck in trans.'
      when b.GoodsMovementType = '657' then 'GD returns blocked'
      when b.GoodsMovementType = '901' then 'Prod Shortage Adj'
      when b.GoodsMovementType = '902' then 'Prod Excess Adj'
      end )                                                    as MoveTypText,
      a.CreatedByUser,
      l.PersonFullName,
      a.CreationDate,
      a.DocumentDate,
      a.PostingDate,
      b.OrderID,
      b.EntryUnit,
      @Semantics.quantity.unitOfMeasure : 'EntryUnit'
      b.QuantityInEntryUnit,
      cast ( b.TotalGoodsMvtAmtInCCCrcy as abap.dec( 16, 3 ) ) as TotalGoodsMvtAmtInCCCrcy,
      b.CompanyCodeCurrency,
      a.AccountingDocumentType,
      m.AccountingDocumentTypeName,
      b.DebitCreditCode,
      n.DebitCreditCodeName
      

}
