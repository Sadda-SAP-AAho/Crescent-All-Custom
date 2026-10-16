@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR CI - Production Details GR other'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACK_3
  as select from I_MaterialDocumentHeader_2 as a
    inner join   zdt_conf_hdr               as b on  b.shpflrno = a.MaterialDocumentHeaderText
    inner join   I_MaterialDocumentItem_2   as c on  c.MaterialDocument     = a.MaterialDocument
                                                 and c.MaterialDocumentYear = a.MaterialDocumentYear
    inner join   I_Product                  as d on  d.Product = c.Material
    inner join   zdt_conf_itm               as e on  e.id    = b.id
                                                 and e.matnr = c.Material
{
  a.PostingDate,
  b.dept,
  sum( cast( ( case when c.StorageLocation = 'KURJ' and ( d.ProductGroup = 'Z027' or d.ProductGroup = 'Z026' or 
                                                          d.ProductGroup = 'Z028' or d.ProductGroup = 'Z003' )             
                    then ( case when c.GoodsMovementType = '101' then ( c.QuantityInBaseUnit * d.NetWeight )
                                else ( -1 * c.QuantityInBaseUnit * d.NetWeight ) end )
                    else cast( 0 as abap.dec( 23, 3 ) )end ) as abap.dec( 23, 3 ) ) ) as seclinerej,
  sum( cast( ( case when ( c.StorageLocation = 'KUFG' and d.ProductGroup = 'Z003' )
                    then ( case when c.GoodsMovementType = '101' then ( c.QuantityInBaseUnit * d.NetWeight )
                                else ( -1 * c.QuantityInBaseUnit * d.NetWeight ) end )
                    else cast( 0 as abap.dec( 23, 3 ) )end ) as abap.dec( 23, 3 ) ) ) as packwt                
                    
}
where
  (
       b.opr               = '0050'
    or b.opr               = '0060'
    or b.opr               = '0070'
    or b.opr               = '0080'
  )
  and(
       d.ProductGroup      = 'Z027'
    or d.ProductGroup      = 'Z026'
    or d.ProductGroup      = 'Z028'
    or d.ProductGroup      = 'Z003'
  )
  and  c.Plant             = '1200'
  and(
       c.GoodsMovementType = '101'
    or c.GoodsMovementType = '102'
  )
  and(
       c.StorageLocation   = 'KUFG'
    or c.StorageLocation   = 'KURJ'
  )
group by
  a.PostingDate,
  b.dept
