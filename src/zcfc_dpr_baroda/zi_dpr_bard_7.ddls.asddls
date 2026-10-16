@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA- LM COST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_BARD_7
  as select from I_MaterialDocumentHeader_2 as a
    inner join   zdt_conf_hdr               as b on b.shpflrno = a.MaterialDocumentHeaderText
    inner join   I_MaterialDocumentItem_2   as c on  c.MaterialDocument     = a.MaterialDocument
                                                 and c.MaterialDocumentYear = a.MaterialDocumentYear
    inner join   I_Product                  as d on d.Product = c.Material
{
  a.PostingDate,
  b.dept,
  sum( cast( case when ( c.Material = 'LM-DI-400/15A' or c.Material = 'LM-DI-450/10'
                      or c.Material = 'LM-DI-500/7 A' or c.Material = 'LM-DI-500/7 B'
                      or c.Material = 'LM-DI-500/7C' or c.Material = 'LM-DI-600/3' )
                  then ( case when c.GoodsMovementType = '101' then c.QuantityInBaseUnit
                              else ( -1 * c.QuantityInBaseUnit ) end )
                  else 0 end as abap.dec( 23, 3 ) ) ) as lmgr,
  sum( cast( case when ( c.Material = 'LM-CI FG-200/A' or c.Material = 'LM-CI FG-200/B'
                      or c.Material = 'LM-CI FG-200/C' or c.Material = 'LM-CI FG-200/D'
                      or c.Material = 'LM-CI-FG-260 A' or c.Material = 'LM-CI-FG-260 B' )
                  then ( case when c.GoodsMovementType = '101' then c.QuantityInBaseUnit
                              else ( -1 * c.QuantityInBaseUnit ) end )
                  else 0 end as abap.dec( 23, 3 ) ) ) as lmgrci


}
where
       b.opr               = '0010'
  and(
       c.Material          = 'LM-DI-400/15A'
    or c.Material          = 'LM-DI-450/10'
    or c.Material          = 'LM-DI-500/7 A'
    or c.Material          = 'LM-DI-500/7 B'
    or c.Material          = 'LM-DI-500/7C'
    or c.Material          = 'LM-DI-600/3'
    or c.Material          = 'LM-CI FG-200/A'
    or c.Material          = 'LM-CI FG-200/B'
    or c.Material          = 'LM-CI FG-200/C'
    or c.Material          = 'LM-CI FG-200/D'
    or c.Material          = 'LM-CI-FG-260 A'
    or c.Material          = 'LM-CI-FG-260 B'
  )
  and  c.Plant             = '1400'
  and(
       c.GoodsMovementType = '101'
    or c.GoodsMovementType = '102'
  )
group by
  a.PostingDate,
  b.dept
