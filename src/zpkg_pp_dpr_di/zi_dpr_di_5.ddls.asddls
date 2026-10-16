@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR DI - Stock Details without PC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_DI_5
  as select from I_StockQuantityCurrentValue_2( P_DisplayCurrency : 'INR' ) as a
    inner join   I_ProductPlantBasic                                        as b on  b.Product = a.Product
                                                                                 and b.Plant   = a.Plant
    inner join   I_Product                                                  as c on c.Product = a.Product
{
   a.Plant,
   sum( case when ( a.ProductGroup = 'Z015' or a.ProductGroup = 'Z017' )
             then cast( a.MatlWrhsStkQtyInMatlBaseUnit as abap.dec( 23, 3 ) ) else cast( 0 as abap.dec( 23, 3 ) ) end ) as rmstock,
   sum( case when ( a.Product  = 'LM00000500SF' or a.Product = 'LM00000500SF-COP' or a.Product = 'LM00000500SF-CI' 
                    or a.Product = 'MT00004' )
             then cast( ( a.MatlWrhsStkQtyInMatlBaseUnit * c.NetWeight ) as abap.dec( 23, 3 ) ) else cast( 0 as abap.dec( 23, 3 ) ) end ) as lmstock          
}
where
  a.Plant = '1100'
  and a.InventoryStockType = '01'
  and a.ValuationAreaType = '1'
group by
  a.Plant
