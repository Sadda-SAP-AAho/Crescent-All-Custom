@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Activity Cost - value Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACK_28 
as select from zcds_pp_casting_report
{
    Shpflrdt as PostingDate,
    Dept,
    sum( case when CostCtrActivityType = 'LAVM03' 
            then cast( amount as abap.dec( 23, 2 ) )
            else 0 end ) as stcoststdgi,
    sum( case when CostCtrActivityType = 'LACT01' 
            then cast( amount as abap.dec( 23, 2 ) )
            else 0 end ) as trtmntcoststd,
    sum( case when CostCtrActivityType = 'LAVM02' or CostCtrActivityType = 'LAVM08' or CostCtrActivityType = 'LADI18' 
            then cast( amount as abap.dec( 23, 2 ) )
            else 0 end )  as powercoststd,
    sum( case when CostCtrActivityType = 'LAGN01' or CostCtrActivityType = 'LAGN02' or CostCtrActivityType = 'LACI07' or CostCtrActivityType = 'LAGN04' or
                 CostCtrActivityType = 'LAVM06' or CostCtrActivityType = 'LFG036' or CostCtrActivityType = 'LFG040' or CostCtrActivityType = 'LFG001' or
                 CostCtrActivityType = 'LFG007' or CostCtrActivityType = 'LFG011' or CostCtrActivityType = 'LFG015' or CostCtrActivityType = 'LFG016' or
                 CostCtrActivityType = 'LFG018' or CostCtrActivityType = 'LFG020' or CostCtrActivityType = 'LAM001' or CostCtrActivityType = 'LAM002' or
                 CostCtrActivityType = 'LAM003' or CostCtrActivityType = 'LAM009' or CostCtrActivityType = 'LAM010' or CostCtrActivityType = 'LAM011' or
                 CostCtrActivityType = 'LAM012' or CostCtrActivityType = 'LACP01'
            then cast( amount as abap.dec( 23, 2 ) )
            else 0 end )     as stdlabexp
}
group by
Shpflrdt,
Dept
