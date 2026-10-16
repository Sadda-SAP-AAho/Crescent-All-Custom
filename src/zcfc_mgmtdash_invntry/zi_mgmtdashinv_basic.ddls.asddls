@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Inventory'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MGMTDASHINV_BASIC
  as select distinct from ZI_PROFITCENTERLIST    as a
    left outer join       ZI_MGMTDASH_INV_FG_SFG as b on  a.Plant        = b.plant
                                                      and a.ProfitCenter = b.ProfitCenter

    left outer join       ZI_MGMTDASH_INV_RM     as c on  a.Plant        = c.Plant
                                                      and a.ProfitCenter = c.ProfitCenter

    left outer join       ZI_MGMTDASH_INV_STR    as d on  a.Plant        = d.Plant
                                                      and a.ProfitCenter = d.ProfitCenter



{
  key a.Plant,
  key a.ProfitCenterName,
      sum( cast(abs( division( b.FgLivewt,
                              1000,
                              3 ) ) as abap.dec(12,2) ) ) as FgLivewt,

      sum( cast(abs( division( b.FgdeadWt,
                              1000,
                              3 ) ) as abap.dec(12,2) ) ) as FgdeadWt,

      sum( cast(abs( division( b.SfgOnHandWt,
                              1000,
                              3 ) ) as abap.dec(12,2) ) ) as SfgOnHandWt,

      sum( cast(abs( division( b.SfgdeadWt,
                              1000,
                              3 ) ) as abap.dec(12,2) ) ) as SfgdeadWt,

      sum( cast(abs( division( c.rmonhandwt,
                              1000,
                              3 ) ) as abap.dec(12,2) ) ) as rmonhandwt,

      cast( sum( d.StockValue ) as abap.dec(12,2) )       as StrStkCost
}

where
  a.Plant is not initial

group by
  a.Plant,
  a.ProfitCenterName
