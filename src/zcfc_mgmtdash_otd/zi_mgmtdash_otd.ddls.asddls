@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-OTD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MGMTDASH_OTD
  as select distinct from ZI_PROFITCENTERLIST as a
    left outer join       ZI_ONTMDSPTCH       as b on  a.Plant        = b.Plant
                                                   and a.ProfitCenter = b.ProfitCenter

{
  key 'DAY'                                           as Type,
  key a.Plant,
  key a.ProfitCenterName,
      cast(abs( division( sum( b.ontimdespwt )
                          , 1000
                          , 3 ) ) as abap.dec(12,2) ) as ontimdespwt

}

where
  b.ActualGoodsMovementDate = $session.system_date

group by
  a.Plant,
  a.ProfitCenterName

union

select distinct from ZI_PROFITCENTERLIST as a
  left outer join    ZI_ONTMDSPTCH       as b on  a.Plant        = b.Plant
                                              and a.ProfitCenter = b.ProfitCenter

{
  key 'MTD'                                           as Type,
  key a.Plant,
  key a.ProfitCenterName,
      cast(abs( division( sum( b.ontimdespwt )
                          , 1000
                          , 3 ) ) as abap.dec(12,2) ) as ontimdespwt

}

where
  b.ActualGoodsMovementDate between dats_add_days( $session.system_date, 1 - cast( substring( $session.system_date, 7, 2 ) as abap.int4 ), 'NULL' ) and $session.system_date

group by
  a.Plant,
  a.ProfitCenterName

union

select distinct from ZI_PROFITCENTERLIST as a
  left outer join    ZI_ONTMDSPTCH       as b on  a.Plant        = b.Plant
                                              and a.ProfitCenter = b.ProfitCenter

{
  key 'YTD'                                           as Type,
  key a.Plant,
  key a.ProfitCenterName,
      cast(abs( division( sum( b.ontimdespwt )
                          , 1000
                          , 3 ) ) as abap.dec(12,2) ) as ontimdespwt

}

where
  b.ActualGoodsMovementDate between

  dats_add_days( dats_add_days( $session.system_date, 1 - cast( substring( $session.system_date, 5, 3 ) as abap.int4 ), 'NULL' ), case when substring( $session.system_date, 5, 2 ) < '04' then - 275 -- shift to previous Apr 1
  else 90                                                                                                                                                                                             -- shift to current Apr 1
  end, 'NULL' )

  and $session.system_date



group by
  a.Plant,
  a.ProfitCenterName
