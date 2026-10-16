@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACUUM BAG - LM Cost 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACB_17
  as select from I_MaterialDocumentHeader_2 as a
    inner join   I_MaterialDocumentItem_2   as c on  c.MaterialDocument     = a.MaterialDocument
                                                 and c.MaterialDocumentYear = a.MaterialDocumentYear
    inner join   ZI_DPR_VACB_8              as b on  b.shpflrno = a.MaterialDocumentHeaderText
    // and b.Material = c.Material
                                                 and b.OrderID  = c.OrderID
    inner join   I_ProductValuationBasic    as d on  d.Product       = c.Material
                                                 and d.ValuationArea = c.Plant

{
  a.PostingDate,
  b.dept,
  sum( cast( case when ( b.Material = 'LM00000500SF' or b.Material = 'LM00000500SF-COP' )
                  then ( case when c.GoodsMovementType = '261'
                              then case when d.InventoryValuationProcedure = 'V'
                                        then cast( ( c.QuantityInBaseUnit * cast( d.MovingAveragePrice as abap.dec( 23, 2) ) ) as abap.dec( 23, 2 ) )
                                        when d.InventoryValuationProcedure = 'S'
                                        then cast( ( c.QuantityInBaseUnit * cast( d.StandardPrice as abap.dec( 23, 2) ) ) as abap.dec( 23, 2 ) )
                                        else 0 end
                              else case when d.InventoryValuationProcedure = 'V'
                                        then cast( ( c.QuantityInBaseUnit * cast( ( -1 * d.MovingAveragePrice ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) )
                                        when d.InventoryValuationProcedure = 'S'
                                        then cast( ( c.QuantityInBaseUnit * cast( ( -1 * d.StandardPrice ) as abap.dec( 23, 2 ) ) ) as abap.dec( 23, 2 ) )
                                        else 0 end end )
                              else 0 end as abap.dec( 23, 3 ) ) ) as comgr,
  sum( cast( case when b.Material = 'LM00000500SF-CI'
                  then ( case when c.GoodsMovementType = '261'
                              then case when d.InventoryValuationProcedure = 'V'
                                        then cast( ( c.QuantityInBaseUnit * cast( d.MovingAveragePrice as abap.dec( 23, 2) ) ) as abap.dec( 23, 2 ) )
                                        when d.InventoryValuationProcedure = 'S'
                                        then cast( ( c.QuantityInBaseUnit * cast( d.StandardPrice as abap.dec( 23, 2) ) ) as abap.dec( 23, 2 ) )
                                        else 0 end
                              else case when d.InventoryValuationProcedure = 'V'
                                        then cast( ( c.QuantityInBaseUnit * cast( ( -1 * d.MovingAveragePrice ) as abap.dec( 23, 2) ) ) as abap.dec( 23, 2 ) )
                                        when d.InventoryValuationProcedure = 'S'
                                        then cast( ( c.QuantityInBaseUnit * cast( ( -1 * d.StandardPrice ) as abap.dec( 23, 2) ) ) as abap.dec( 23, 2 ) )
                                        else 0 end end )
                              else 0 end as abap.dec( 23, 3 ) ) ) as comgrci
}
where
       c.Plant             = '1300'
  and(
       c.GoodsMovementType = '261'
    or c.GoodsMovementType = '262'
  )
group by
  a.PostingDate,
  b.dept
