@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Open Order(BAG)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MGMTOPNORDRBAG
  as select distinct from ZI_OPENSORPT       as a
    inner join            I_Product          as b on a.Product = b.Product
    inner join            I_ProfitCenterText as c on a.ProfitCenter = c.ProfitCenterName

{
  key a.Plant,
  key 'Bagnan'                                            as ProfitCenter,
      sum( cast ( a.balancewt as abap.dec( 15, 3 )  ) )   as Balance_Wt,
      sum( cast ( a.balancevallc as abap.dec( 15, 3 ) ) ) as Balance_Val
}

where
       a.Plant                = '1300'
  and(
       c.ProfitCenter         = '0000001300'
    or c.ProfitCenter         = '0000001301'
    or c.ProfitCenter         = '0000001302'
    or c.ProfitCenter         = '0000001303'
    or c.ProfitCenter         = '0000001304'
  )
  and(
       b.ProductGroup         = 'Z003'
    or b.ProductGroup         = 'Z036'
  )
  and  a.SDDocumentReasonText = 'Sales Call'

group by
  a.Plant
