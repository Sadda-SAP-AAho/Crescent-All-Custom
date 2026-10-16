@AbapCatalog.sqlViewName: 'ZMATPRICE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Material Price'
@Metadata.ignorePropagatedAnnotations: true

define view ZI_MATPRICE
  as select distinct from I_Product               as a
    inner join            I_ProductPlantBasic     as b on a.Product = b.Product
    left outer join       I_ProductValuationBasic as c on  a.Product = c.Product
                                                       and b.Plant   = c.ValuationArea

{

  key a.Product                     as MaterialNo,
  key b.Plant                       as PlantCode,
      c.InventoryValuationProcedure as PriceControl,
      c.ValuationClass              as ValuationClass,
      c.Currency                    as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      max(c.StandardPrice)          as StandardPrice,
      @Semantics.amount.currencyCode: 'Currency'
      max(c.MovingAveragePrice)     as MovingAvgPrice

}

group by
  a.Product,
  b.Plant,
  c.InventoryValuationProcedure,
  c.ValuationClass,
  c.Currency
