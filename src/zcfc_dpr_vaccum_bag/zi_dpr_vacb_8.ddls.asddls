@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACUUM BAG - LM COST 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACB_8
  as select from   I_MaterialDocumentHeader_2 as a
    inner join   zdt_conf_hdr               as b on  b.shpflrno = a.MaterialDocumentHeaderText
    inner join   I_MaterialDocumentItem_2   as c on  c.MaterialDocument     = a.MaterialDocument
                                                 and c.MaterialDocumentYear = a.MaterialDocumentYear
                                          
{
  c.Material,
  c.OrderID,
  b.shpflrno,
  b.dept
}
where
       b.opr               = '0010'
  and(
       c.Material          = 'LM00000500SF'
    or c.Material          = 'LM00000500SF-CI'
    or c.Material          = 'LM00000500SF-COP'
  )
  and  c.Plant             = '1300'
  and(
       c.GoodsMovementType = '101'
    or c.GoodsMovementType = '102'
  )
group by
  c.Material,
  c.OrderID,
  b.shpflrno,
  b.dept
