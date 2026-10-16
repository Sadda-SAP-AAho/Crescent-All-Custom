@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Open Order(Non Baroda PC)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MGMTOPNORDRNONBAR
  as select distinct from ZI_OPENSORPT       as a
    inner join            I_Product          as b on a.Product = b.Product
    left outer join       I_ProfitCenterText as c on a.ProfitCenter = c.ProfitCenterName
{
  key a.Plant,
  key 'Oth Plant PrfCenter'                               as ProfitCenter,
      sum( cast ( a.balancewt as abap.dec( 15, 3 ) ) )    as Balance_Wt,
      sum( cast ( a.balancevallc as abap.dec( 15, 3 ) ) ) as Balance_Val
}

where
        a.Plant                =  '1400'
  and(
        c.ProfitCenter         <> '0000001400'
    and c.ProfitCenter         <> '0000001401'
    and c.ProfitCenter         <> '0000001402'
    and c.ProfitCenter         <> '0000001403'
  )
  and(
        b.ProductGroup         =  'Z003'
    or  b.ProductGroup         =  'Z036'
  )
  and   a.SDDocumentReasonText =  'Sales Call'

group by
  a.Plant
