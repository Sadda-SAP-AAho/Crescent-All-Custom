@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Activity Cost - Prod Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_CI_26
  as select from I_MaterialDocumentHeader_2 as a
    inner join   zdt_conf_hdr               as b on b.shpflrno = a.MaterialDocumentHeaderText
    inner join   I_MaterialDocumentItem_2   as c on  c.MaterialDocument     = a.MaterialDocument
                                                 and c.MaterialDocumentYear = a.MaterialDocumentYear
    inner join   I_Product                  as d on d.Product = c.Material
{
  a.PostingDate,
  b.dept,
  c.Material,
  c.Plant,
  cast( c.QuantityInBaseUnit as abap.dec( 13, 3 ) ) as QuantityInBaseUnit,
  c.GoodsMovementType
}
where
       c.Plant             = '1100'
  and(
       c.GoodsMovementType = '101'
    or c.GoodsMovementType = '102'
  )
  and(
       c.StorageLocation   = 'SASG'
    or c.StorageLocation   = 'SAFG'
  )
