@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR DI - Activity Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_DI_19 
as select from I_MaterialDocumentHeader_2 as a
    inner join zdt_conf_hdr               as b on b.shpflrno = a.MaterialDocumentHeaderText
    inner join I_MaterialDocumentItem_2   as c on c.MaterialDocument     = a.MaterialDocument
                                              and c.MaterialDocumentYear = a.MaterialDocumentYear
    inner join I_Product                  as d on d.Product = c.Material
    inner join ZI_DPR_DI_18               as e on e.matnr = c.Material and e.plant = c.Plant
                                  
{
  a.PostingDate,
  b.dept,
  sum( case when e.ActivityType = 'LAST01' 
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )  
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as stcoststdgi,  
  sum( case when e.ActivityType = 'LACT01' 
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )  
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as trtmntcoststd,
  sum( case when e.ActivityType = 'LADI01' 
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )  
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as powercoststd,
  sum( case when e.ActivityType = 'LACI07' or e.ActivityType = 'LACI09' or e.ActivityType = 'LACI11' or e.ActivityType = 'LACP01' or
                 e.ActivityType = 'LADI04' or e.ActivityType = 'LADI05' or e.ActivityType = 'LADI06' or e.ActivityType = 'LADI07' or
                 e.ActivityType = 'LADI16' or e.ActivityType = 'LAGN01' or e.ActivityType = 'LAGN02' or e.ActivityType = 'LAM001' or
                 e.ActivityType = 'LAM002' or e.ActivityType = 'LAM003' or e.ActivityType = 'LAM004' or e.ActivityType = 'LAM005' or
                 e.ActivityType = 'LAM006' or e.ActivityType = 'LAM008' or e.ActivityType = 'LAM009' or e.ActivityType = 'LAM011' or
                 e.ActivityType = 'LAM012' or e.ActivityType = 'LAM014' or e.ActivityType = 'LAM015' or e.ActivityType = 'LAMC01' or
                 e.ActivityType = 'LAMS04' or e.ActivityType = 'LAOF01' or e.ActivityType = 'LFG007' or e.ActivityType = 'LFG012' or
                 e.ActivityType = 'LFG013' or e.ActivityType = 'LFG014' or e.ActivityType = 'LFG015' or e.ActivityType = 'LFG016' or
                 e.ActivityType = 'LFG020' or e.ActivityType = 'LFG022' or e.ActivityType = 'LFG023' or e.ActivityType = 'LFG024' or
                 e.ActivityType = 'LFG025' or e.ActivityType = 'LFG026' or e.ActivityType = 'LFG027' or e.ActivityType = 'LFG020' or
                 e.ActivityType = 'LFG033' or e.ActivityType = 'LFG038' or e.ActivityType = 'LFG039' or e.ActivityType = 'LFG042' or 
                 e.ActivityType = 'LAGN03'
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )  
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as stdlabexp                                          
}
where
  c.Plant             = '1100'
  and(
       c.GoodsMovementType = '101'
    or c.GoodsMovementType = '102'
  )
  and c.StorageLocation   = 'SASG'
group by
  a.PostingDate,
  b.dept
