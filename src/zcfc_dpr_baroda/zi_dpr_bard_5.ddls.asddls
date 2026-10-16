@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA - Stock Details without PC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_BARD_5
  as select from I_StockQuantityCurrentValue_2( P_DisplayCurrency : 'INR' ) as a
    inner join   I_ProductPlantBasic                                        as b on  b.Product = a.Product
                                                                                 and b.Plant   = a.Plant
    inner join   I_Product                                                  as c on c.Product = a.Product
{
  a.Plant,
  sum( case when ( a.ProductGroup = 'Z015' or a.ProductGroup = 'Z017' )
            then cast( a.MatlWrhsStkQtyInMatlBaseUnit as abap.dec( 23, 3 ) ) else cast( 0 as abap.dec( 23, 3 ) ) end )                   as rmstock,
  sum( case when ( a.Product = 'LM-DI-400/15A' or a.Product = 'LM-DI-450/10'
                or a.Product = 'LM-DI-500/7 A' or a.Product = 'LM-DI-500/7 B'
                or a.Product = 'LM-DI-500/7C' or a.Product = 'LM-DI-600/3'
                or a.Product = 'LM-CI FG-200/A' or a.Product = 'LM-CI FG-200/B'
                or a.Product = 'LM-CI FG-200/C' or a.Product = 'LM-CI FG-200/D'
                or a.Product = 'LM-CI-FG-260 A' or a.Product = 'LM-CI-FG-260 B'
                or a.Product = 'MT00005' or a.Product = 'MT00019' )
            then cast( ( a.MatlWrhsStkQtyInMatlBaseUnit * c.NetWeight ) as abap.dec( 23, 3 ) ) else cast( 0 as abap.dec( 23, 3 ) ) end ) as lmstock
}
where
      a.Plant              = '1400'
  and a.InventoryStockType = '01'
  and a.ValuationAreaType  = '1'
group by
  a.Plant
