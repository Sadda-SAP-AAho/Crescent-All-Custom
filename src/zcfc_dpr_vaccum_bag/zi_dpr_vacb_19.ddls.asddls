@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACUUM BAG - Activity Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACB_19
  as select from I_MaterialDocumentHeader_2 as a
    inner join   zdt_conf_hdr               as b on b.shpflrno = a.MaterialDocumentHeaderText
    inner join   I_MaterialDocumentItem_2   as c on  c.MaterialDocument     = a.MaterialDocument
                                                 and c.MaterialDocumentYear = a.MaterialDocumentYear
    inner join   I_Product                  as d on d.Product = c.Material
    inner join   ZI_DPR_VACB_18             as e on  e.matnr = c.Material
                                                 and e.plant = c.Plant

{
  a.PostingDate,
  b.dept,
  sum( case when ( e.ActivityType = 'LAVM03' or e.ActivityType = 'LAMS07' )
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as stcoststdgi,
  sum( case when e.ActivityType = 'LACT01'
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as trtmntcoststd,
  sum( case when ( e.ActivityType = 'LAVM02' or e.ActivityType = 'LAVM08' or e.ActivityType = 'LAMS02' )
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as powercoststd,
  sum( case when e.ActivityType = 'LAGN01' or e.ActivityType = 'LAGN02' or e.ActivityType = 'LACI07' or e.ActivityType = 'LAGN04' or
                 e.ActivityType = 'LAVM06' or e.ActivityType = 'LFG036' or e.ActivityType = 'LFG040' or e.ActivityType = 'LFG001' or
                 e.ActivityType = 'LFG007' or e.ActivityType = 'LFG011' or e.ActivityType = 'LFG015' or e.ActivityType = 'LFG016' or
                 e.ActivityType = 'LFG018' or e.ActivityType = 'LFG020' or e.ActivityType = 'LAM001' or e.ActivityType = 'LAM002' or
                 e.ActivityType = 'LAM003' or e.ActivityType = 'LAM009' or e.ActivityType = 'LAM010' or e.ActivityType = 'LAM011' or
                 e.ActivityType = 'LAM012' or e.ActivityType = 'LACP01'
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as stdlabexp
}
where
       c.Plant             = '1300'
  and(
       c.GoodsMovementType = '101'
    or c.GoodsMovementType = '102'
  )
  and  c.StorageLocation   = 'BGSG'
group by
  a.PostingDate,
  b.dept
