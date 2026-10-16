@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Activity Cost - Value Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_BARD_28
  as select from zcds_pp_casting_report
{
  Shpflrdt             as PostingDate,
  Dept,
  sum( case when ( CostCtrActivityType = 'GLGN07' or CostCtrActivityType = 'GLGN08'
                or CostCtrActivityType = 'GLGN10' or CostCtrActivityType = 'GLGN12' )
          then cast( amount as abap.dec( 23, 2 ) )
          else 0 end ) as stcoststdgi,
  sum( case when ( CostCtrActivityType = 'GLDI02' or CostCtrActivityType = 'GLDI03'
                or CostCtrActivityType = 'GLDI05' or CostCtrActivityType = 'GLDI06'
                or CostCtrActivityType = 'GLDI07' or CostCtrActivityType = 'GLGN41'
                or CostCtrActivityType = 'GLGN43' or CostCtrActivityType = 'GLGN53'
                or CostCtrActivityType = 'GLGN54' )
          then cast( amount as abap.dec( 23, 2 ) )
          else 0 end ) as trtmntcoststd,

  sum( case when ( CostCtrActivityType = 'GLDI01' or CostCtrActivityType = 'GLGN01'
                or CostCtrActivityType = 'GLGN02' or CostCtrActivityType = 'GLGN03'
                or CostCtrActivityType = 'GLGN18' )
          then cast( amount as abap.dec( 23, 2 ) )
          else 0 end ) as powercoststd,
  sum( case when ( CostCtrActivityType = 'GLGN06' or CostCtrActivityType = 'GLGN09' or CostCtrActivityType = 'GLGN13'
                or CostCtrActivityType = 'GLGN14' or CostCtrActivityType = 'GLGN15' or CostCtrActivityType = 'GLGN17'
                or CostCtrActivityType = 'GLGN19' or CostCtrActivityType = 'GLGN21' or CostCtrActivityType = 'GLGN22'
                or CostCtrActivityType = 'GLGN23' or CostCtrActivityType = 'GLGN24' or CostCtrActivityType = 'GLGN25'
                or CostCtrActivityType = 'GLGN26' or CostCtrActivityType = 'GLGN27' or CostCtrActivityType = 'GLGN28'
                or CostCtrActivityType = 'GLGN29' or CostCtrActivityType = 'GLGN30' or CostCtrActivityType = 'GLGN31'
                or CostCtrActivityType = 'GLGN34' or CostCtrActivityType = 'GLGN36' or CostCtrActivityType = 'GLGN38'
                or CostCtrActivityType = 'GLGN45' or CostCtrActivityType = 'GLGN47' or CostCtrActivityType = 'GLGN48'
                or CostCtrActivityType = 'GLGN49' or CostCtrActivityType = 'GLGN50' or CostCtrActivityType = 'GLGN51'
                or CostCtrActivityType = 'GLGN52' or CostCtrActivityType = 'GLGN55' or CostCtrActivityType = 'GLGN56'
                or CostCtrActivityType = 'GLGN57' or CostCtrActivityType = 'GLGN58' or CostCtrActivityType = 'GLGN59' )
          then cast( amount as abap.dec( 23, 2 ) )
          else 0 end ) as stdlabexp
}
group by
  Shpflrdt,
  Dept
