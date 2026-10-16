@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Activity Cost - value Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_CI_28
  as select from zcds_pp_casting_report
{
  Shpflrdt             as PostingDate,
  Dept,
  sum( case when CostCtrActivityType = 'LAST01'
          then cast( amount as abap.dec( 23, 2 ) )
          else 0 end ) as stcoststdgi,
  sum( case when CostCtrActivityType = 'LACT01'
          then cast( amount as abap.dec( 23, 2 ) )
          else 0 end ) as trtmntcoststd,
  sum( case when CostCtrActivityType = 'LACI02' or CostCtrActivityType = 'LADI18' or
                 CostCtrActivityType = 'LADI19' or CostCtrActivityType = 'LAMS02'
          then cast( amount as abap.dec( 23, 2 ) )
          else 0 end ) as powercoststd,
  sum( case when CostCtrActivityType = 'LACI07' or CostCtrActivityType = 'LACI09' or CostCtrActivityType = 'LACI11' or CostCtrActivityType = 'LACP01' or
               CostCtrActivityType = 'LADI04' or CostCtrActivityType = 'LADI05' or CostCtrActivityType = 'LADI06' or CostCtrActivityType = 'LADI07' or
               CostCtrActivityType = 'LADI16' or CostCtrActivityType = 'LAGN01' or CostCtrActivityType = 'LAGN02' or CostCtrActivityType = 'LAM001' or
               CostCtrActivityType = 'LAM002' or CostCtrActivityType = 'LAM003' or CostCtrActivityType = 'LAM004' or CostCtrActivityType = 'LAM005' or
               CostCtrActivityType = 'LAM006' or CostCtrActivityType = 'LAM008' or CostCtrActivityType = 'LAM009' or CostCtrActivityType = 'LAM011' or
               CostCtrActivityType = 'LAM012' or CostCtrActivityType = 'LAM014' or CostCtrActivityType = 'LAM015' or CostCtrActivityType = 'LAMC01' or
               CostCtrActivityType = 'LAMS04' or CostCtrActivityType = 'LAOF01' or CostCtrActivityType = 'LFG007' or CostCtrActivityType = 'LFG012' or
               CostCtrActivityType = 'LFG013' or CostCtrActivityType = 'LFG014' or CostCtrActivityType = 'LFG015' or CostCtrActivityType = 'LFG016' or
               CostCtrActivityType = 'LFG020' or CostCtrActivityType = 'LFG022' or CostCtrActivityType = 'LFG023' or CostCtrActivityType = 'LFG024' or
               CostCtrActivityType = 'LFG025' or CostCtrActivityType = 'LFG026' or CostCtrActivityType = 'LFG027' or CostCtrActivityType = 'LFG020' or
               CostCtrActivityType = 'LFG033' or CostCtrActivityType = 'LFG038' or CostCtrActivityType = 'LFG039' or CostCtrActivityType = 'LFG042' or
               CostCtrActivityType = 'LAGN03'
          then cast( amount as abap.dec( 23, 2 ) )
          else 0 end ) as stdlabexp
}
group by
  Shpflrdt,
  Dept
