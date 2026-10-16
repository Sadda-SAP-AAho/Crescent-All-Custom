@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR DI- LM COST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_DI_7
  as select from I_MaterialDocumentHeader_2 as a
    inner join   zdt_conf_hdr               as b on b.shpflrno = a.MaterialDocumentHeaderText
    inner join   I_MaterialDocumentItem_2   as c on  c.MaterialDocument     = a.MaterialDocument
                                                 and c.MaterialDocumentYear = a.MaterialDocumentYear
    inner join   I_Product                  as d on d.Product = c.Material
{
  a.PostingDate,
  b.dept,
  sum( cast( case when ( c.Material = 'LM00000500SF' or c.Material = 'LM00000500SF-COP' )
                  then ( case when c.GoodsMovementType = '101' then c.QuantityInBaseUnit
                              else ( -1 * c.QuantityInBaseUnit ) end ) 
                  else 0 end as abap.dec( 23, 3 ) ) ) as lmgr,
  sum( cast( case when c.Material = 'LM00000500SF-CI'
                  then ( case when c.GoodsMovementType = '101' then c.QuantityInBaseUnit
                              else ( -1 * c.QuantityInBaseUnit ) end ) 
                  else 0 end as abap.dec( 23, 3 ) ) ) as lmgrci                


}
where
       b.opr               = '0010'
  and(
       c.Material          = 'LM00000500SF'
    or c.Material          = 'LM00000500SF-CI'
    or c.Material          = 'LM00000500SF-COP'
  )
  and  c.Plant             = '1100'
  and(
       c.GoodsMovementType = '101'
    or c.GoodsMovementType = '102'
  )
group by
  a.PostingDate,
  b.dept
