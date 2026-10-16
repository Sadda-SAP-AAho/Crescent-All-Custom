@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Activity Cost - value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACK_27 
as select from ZI_DPR_VACK_26 as a
inner join ZI_DPR_VACK_18     as e on e.matnr = a.Material and e.plant = a.Plant
{
  a.PostingDate,
  a.dept,
  e.CalculatedCost,
  cast( a.QuantityInBaseUnit as abap.dec( 13, 2 ) ) as QuantityInBaseUnit,
  case when ( e.ActivityType = 'LAVM03' or e.ActivityType = 'LAMS07' ) 
            then case when a.GoodsMovementType = '101'
                 then cast( ( a.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )  
                 else cast( ( -1 * a.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end as stcoststdgi,  
  case when e.ActivityType = 'LACT01' 
            then case when a.GoodsMovementType = '101'
                 then cast( ( a.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )  
                 else cast( ( -1 * a.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end as trtmntcoststd,
  case when ( e.ActivityType = 'LAVM02' or e.ActivityType = 'LAVM08' or e.ActivityType = 'LAMS02' )
            then case when a.GoodsMovementType = '101'
                 then cast( ( a.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )  
                 else cast( ( -1 * a.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end as powercoststd,
  case when e.ActivityType = 'LAGN01' or e.ActivityType = 'LAGN02' or e.ActivityType = 'LACI07' or e.ActivityType = 'LAGN04' or
                 e.ActivityType = 'LAVM06' or e.ActivityType = 'LFG036' or e.ActivityType = 'LFG040' or e.ActivityType = 'LFG001' or
                 e.ActivityType = 'LFG007' or e.ActivityType = 'LFG011' or e.ActivityType = 'LFG015' or e.ActivityType = 'LFG016' or
                 e.ActivityType = 'LFG018' or e.ActivityType = 'LFG020' or e.ActivityType = 'LAM001' or e.ActivityType = 'LAM002' or
                 e.ActivityType = 'LAM003' or e.ActivityType = 'LAM009' or e.ActivityType = 'LAM010' or e.ActivityType = 'LAM011' or
                 e.ActivityType = 'LAM012' or e.ActivityType = 'LACP01'
            then case when a.GoodsMovementType = '101'
                 then cast( ( a.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) )  
                 else cast( ( -1 * a.QuantityInBaseUnit * e.CalculatedCost ) as abap.dec( 23, 2 ) ) end
            else 0 end as stdlabexp  
}
