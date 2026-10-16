@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA - LM COST 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_BARD_8 
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
  c.Material,
  c.OrderID,
  b.shpflrno,
  b.dept
