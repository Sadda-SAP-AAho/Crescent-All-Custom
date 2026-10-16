@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR CI - Production Details GR Casting'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_CI_2
  as select from I_MaterialDocumentHeader_2 as a
    inner join   zdt_conf_hdr               as b on b.shpflrno = a.MaterialDocumentHeaderText
    inner join   I_MaterialDocumentItem_2   as c on  c.MaterialDocument     = a.MaterialDocument
                                                 and c.MaterialDocumentYear = a.MaterialDocumentYear
    inner join   I_Product                  as d on d.Product = c.Material
    inner join   zdt_conf_itm               as e on  e.id    = b.id
                                                 and e.matnr = c.Material
{
  a.PostingDate,
  b.dept,
  sum( cast( ( case when c.GoodsMovementType = '101' then ( c.QuantityInBaseUnit * d.NetWeight )
                    else ( -1 * c.QuantityInBaseUnit * d.NetWeight ) end ) as abap.dec( 23, 3 ) ) ) as totalcast,
  sum( cast( ( case when c.StorageLocation = 'SASG'
                    then ( case when c.GoodsMovementType = '101' then ( c.QuantityInBaseUnit * d.NetWeight )
                                else ( -1 * c.QuantityInBaseUnit * d.NetWeight ) end )
                    else cast( 0 as abap.dec( 23, 3 ) )end ) as abap.dec( 23, 3 ) ) )               as stdgoodcast,
  sum( cast( ( case when c.StorageLocation = 'SASG'
                    then ( case when c.GoodsMovementType = '101' then ( c.QuantityInBaseUnit * e.actwt )
                                else ( -1 * c.QuantityInBaseUnit * e.actwt ) end )
                    else cast( 0 as abap.dec( 23, 3 ) )end ) as abap.dec( 23, 3 ) ) )               as actgoodcast,
  sum( cast( ( case when c.StorageLocation = 'SARJ' or c.StorageLocation = 'SASG'
                    then ( case when c.GoodsMovementType = '101' then ( c.QuantityInBaseUnit * d.GrossWeight )
                                else ( -1 * c.QuantityInBaseUnit * d.GrossWeight ) end )
                    else cast( 0 as abap.dec( 23, 3 ) )end ) as abap.dec( 23, 3 ) ) )               as bunchwt,
  sum( cast( ( case when c.StorageLocation = 'SARJ'
                    then ( case when c.GoodsMovementType = '101' then ( c.QuantityInBaseUnit * d.NetWeight )
                                else ( -1 * c.QuantityInBaseUnit * d.NetWeight ) end )
                    else cast( 0 as abap.dec( 23, 3 ) )end ) as abap.dec( 23, 3 ) ) )               as rejwt
}
where
       b.opr               = '0040'
  and  d.ProductGroup      = 'Z025'
  and  c.Plant             = '1100'
  and(
       c.GoodsMovementType = '101'
    or c.GoodsMovementType = '102'
  )
  and(
       c.StorageLocation   = 'SASG'
    or c.StorageLocation   = 'SARJ'
  )
group by
  a.PostingDate,
  b.dept
