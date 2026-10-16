@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Warehouse Stock Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MATWHSTOCK
  as select distinct from I_StockQuantityCurrentValue_2 ( P_DisplayCurrency : 'INR' ) as a
    inner join            I_ProductText                                               as b on a.Product = b.Product
    inner join            I_Plant                                                     as c on a.Plant = c.Plant
    inner join            I_StorageLocation                                           as d on  c.Plant           = d.Plant
                                                                                           and a.StorageLocation = d.StorageLocation
    left outer join       I_StockTypeText_2                                           as e on  a.InventorySpecialStockType = e.StockType
                                                                                           and e.Language                  = 'E'
    inner join            I_ProductGroupText_2                                        as f on  a.ProductGroup = f.ProductGroup
                                                                                           and f.Language     = 'E'
    inner join            I_ProductTypeText_2                                         as g on  a.ProductType = g.ProductType
                                                                                           and g.Language    = 'E'
    left outer join       I_Batch_2                                                   as h on  a.Product = h.Material
                                                                                           and a.Batch   = h.Batch

{
  key a.Product,
  key b.ProductName,
  key a.ProductGroup,
  key f.ProductGroupName,
  key a.ProductType,
  key g.ProductTypeName,
  key a.Plant,
  key c.PlantName,
  key a.StorageLocation,
      d.StorageLocationName,
      a.Batch,
      h.ShelfLifeExpirationDate,
      h.ManufactureDate                                  as ProductionDate,
      a.InventorySpecialStockType,
      e.StockTypeName,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      a.MatlWrhsStkQtyInMatlBaseUnit,
      cast ( a.StockValueInCCCrcy as abap.dec( 16, 3 ) ) as StockValueInCCCrcy,
      a.Currency
}

where
      a.ValuationAreaType            =  '1'
  and a.MatlWrhsStkQtyInMatlBaseUnit >  0
  and a.StorageLocation              <> 'SARJ'
  and a.StorageLocation              <> 'KURJ'
  and a.StorageLocation              <> 'BGRJ'
  and a.StorageLocation              <> 'BARJ'
