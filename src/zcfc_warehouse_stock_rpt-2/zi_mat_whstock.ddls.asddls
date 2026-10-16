@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Warehouse Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MAT_WHSTOCK

  as select from I_StockQuantityCurrentValue_2 ( P_DisplayCurrency : 'INR' ) as a
    inner join   I_ProductText                                               as b on a.Product = b.Product
    inner join   I_Plant                                                     as c on a.Plant = c.Plant
    inner join   I_ProductGroupText_2                                        as f on  a.ProductGroup = f.ProductGroup
                                                                                  and f.Language     = 'E'
    inner join   I_ProductTypeText_2                                         as g on  a.ProductType = g.ProductType
                                                                                  and g.Language    = 'E'
    inner join   I_Product                                                   as h on a.Product = h.Product
{
  key a.Product,
  key b.ProductName,
  key a.ProductGroup,
  key f.ProductGroupName,
  key a.ProductType,
  key g.ProductTypeName,
  key a.Plant,
  key c.PlantName,
  key a.Supplier                                         as SpecialStockNumber,
      a.InventorySpecialStockType                        as SpecialStock,
      case
            when
             a.InventorySpecialStockType = 'O' then 'Sub-Contracting'
             else  '  '  end                             as StockTypeName,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      a.MatlWrhsStkQtyInMatlBaseUnit,
      cast ( a.StockValueInCCCrcy as abap.dec( 16, 3 ) ) as StockValueInCCCrcy,
      a.Currency,
      h.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      h.NetWeight  as NetWeight,
      cast ( a.MatlWrhsStkQtyInMatlBaseUnit as abap.dec(15,2) ) *
      cast (  h.NetWeight as abap.dec(15,2) )            as TotalValue
}

where
      a.ValuationAreaType         = '1'
  and a.InventorySpecialStockType = 'O'
