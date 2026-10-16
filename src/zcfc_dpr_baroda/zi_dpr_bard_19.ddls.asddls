@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA - Activity Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_BARD_19
  as select from I_MaterialDocumentHeader_2 as a
    inner join   zdt_conf_hdr               as b on b.shpflrno = a.MaterialDocumentHeaderText
    inner join   I_MaterialDocumentItem_2   as c on  c.MaterialDocument     = a.MaterialDocument
                                                 and c.MaterialDocumentYear = a.MaterialDocumentYear
    inner join   I_Product                  as d on d.Product = c.Material
    inner join   ZI_DPR_VACK_18             as e on  e.matnr = c.Material
                                                 and e.plant = c.Plant

{
  a.PostingDate,
  b.dept,
  sum( case when ( e.ActivityType = 'GLGN07' or e.ActivityType = 'GLGN08' 
                or e.ActivityType = 'GLGN10' or e.ActivityType = 'GLGN12' )
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as stcoststdgi,
            
  sum( case when ( e.ActivityType = 'GLDI02' or e.ActivityType = 'GLDI03' 
                or e.ActivityType = 'GLDI05' or e.ActivityType = 'GLDI06' 
                or e.ActivityType = 'GLDI07' or e.ActivityType = 'GLGN41' 
                or e.ActivityType = 'GLGN43' or e.ActivityType = 'GLGN53' 
                or e.ActivityType = 'GLGN54' )
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as trtmntcoststd,
            
  sum( case when ( e.ActivityType = 'GLDI01' or e.ActivityType = 'GLGN01' 
                or e.ActivityType = 'GLGN02' or e.ActivityType = 'GLGN03' 
                or e.ActivityType = 'GLGN18' )
            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as powercoststd,
            
  sum( case when ( e.ActivityType = 'GLGN06' or e.ActivityType = 'GLGN09' or e.ActivityType = 'GLGN13'
                or e.ActivityType = 'GLGN14' or e.ActivityType = 'GLGN15' or e.ActivityType = 'GLGN17' 
                or e.ActivityType = 'GLGN19' or e.ActivityType = 'GLGN21' or e.ActivityType = 'GLGN22' 
                or e.ActivityType = 'GLGN23' or e.ActivityType = 'GLGN24' or e.ActivityType = 'GLGN25' 
                or e.ActivityType = 'GLGN26' or e.ActivityType = 'GLGN27' or e.ActivityType = 'GLGN28' 
                or e.ActivityType = 'GLGN29' or e.ActivityType = 'GLGN30' or e.ActivityType = 'GLGN31' 
                or e.ActivityType = 'GLGN34' or e.ActivityType = 'GLGN36' or e.ActivityType = 'GLGN38' 
                or e.ActivityType = 'GLGN45' or e.ActivityType = 'GLGN47' or e.ActivityType = 'GLGN48' 
                or e.ActivityType = 'GLGN49' or e.ActivityType = 'GLGN50' or e.ActivityType = 'GLGN51' 
                or e.ActivityType = 'GLGN52' or e.ActivityType = 'GLGN55' or e.ActivityType = 'GLGN56' 
                or e.ActivityType = 'GLGN57' or e.ActivityType = 'GLGN58' or e.ActivityType = 'GLGN59' )

            then case when c.GoodsMovementType = '101'
                 then cast( ( c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )
                 else cast( ( -1 * c.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end ) as stdlabexp
}
where
       c.Plant             = '1400'
  and(
       c.GoodsMovementType = '101'
    or c.GoodsMovementType = '102'
  )
  and  c.StorageLocation   = 'BASG'
group by
  a.PostingDate,
  b.dept
