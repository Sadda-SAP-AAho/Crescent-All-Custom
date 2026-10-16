@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Actual Despatch'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ACTDESP
  as select distinct from I_MaterialDocumentHeader_2 as a
    inner join            I_MaterialDocumentItem_2   as b on  a.MaterialDocument     = b.MaterialDocument
                                                          and a.MaterialDocumentYear = b.MaterialDocumentYear
    left outer join       I_Product                  as c on b.Material = c.Product
    left outer join       I_ProductPlantBasic        as d on  b.Material = d.Product
                                                          and b.Plant    = d.Plant
    left outer join       ZI_PROFITCENTERLIST        as e on  d.ProfitCenter     = e.ProfitCenter
                                                          and e.ProfitCenterName is not initial

{
  key b.Plant,
  key e.ProfitCenterName                                                                                                                                      as ProfitCenter,
      a.DocumentDate,
      cast( sum( cast( coalesce( b.QuantityInEntryUnit, 0 ) as abap.dec(12,3) ) * cast( coalesce( c.NetWeight, 0 ) as abap.dec(12,3) ) )  as abap.dec(12,3) ) as Desp_Wt
}

where
  b.GoodsMovementType = '261'

group by
  b.Plant,
  e.ProfitCenterName,
  a.DocumentDate


union

select distinct from I_MaterialDocumentHeader_2 as a
  inner join         I_MaterialDocumentItem_2   as b on  a.MaterialDocument     = b.MaterialDocument
                                                     and a.MaterialDocumentYear = b.MaterialDocumentYear
  left outer join    I_Product                  as c on b.Material = c.Product
  left outer join    I_ProductPlantBasic        as d on  b.Material = d.Product
                                                     and b.Plant    = d.Plant
  left outer join    ZI_PROFITCENTERLIST        as e on  d.ProfitCenter     = e.ProfitCenter
                                                     and e.ProfitCenterName is not initial

{
  key b.Plant,
  key e.ProfitCenterName                                                                                                                                               as ProfitCenter,
      a.DocumentDate,

      cast( sum( cast( coalesce( b.QuantityInEntryUnit, 0 ) * ( -1 ) as abap.dec(12,3) ) * cast( coalesce( c.NetWeight, 0 ) as abap.dec(12,3) ) )  as abap.dec(12,3) ) as Desp_Wt
}

where
  b.GoodsMovementType = '262'

group by
  b.Plant,
  e.ProfitCenterName,
  a.DocumentDate
