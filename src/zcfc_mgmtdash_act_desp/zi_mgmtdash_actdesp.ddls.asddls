@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Actual Despatch'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MGMTDASH_ACTDESP
  as select distinct from ZI_ACTDESP

{
  key 'DAY'                                           as Type,
  key Plant,
  key ProfitCenter,
      sum( Desp_Wt )                                  as Act_Desp_Wt,
      cast(abs( division( sum( Desp_Wt )
                          , 1000
                          , 3 ) ) as abap.dec(12,2) ) as Act_Desp_Wt_MT
}

where
      ProfitCenter is not initial
  and DocumentDate = $session.system_date

group by
  Plant,
  ProfitCenter

union

select distinct from ZI_ACTDESP

{
  key 'MTD'                                           as Type,
  key Plant,
  key ProfitCenter,
      sum( Desp_Wt )                                  as Act_Desp_Wt,
      cast(abs( division( sum( Desp_Wt )
                          , 1000
                          , 3 ) ) as abap.dec(12,2) ) as Act_Desp_Wt_MT
}

where
      ProfitCenter is not initial
  and DocumentDate between dats_add_days( $session.system_date, 1 - cast( substring( $session.system_date, 7, 2 ) as abap.int4 ), 'NULL' ) and $session.system_date

group by
  Plant,
  ProfitCenter

union

select distinct from ZI_ACTDESP

{
  key 'YTD'                                           as Type,
  key Plant,
  key ProfitCenter,
      sum( Desp_Wt )                                  as Act_Desp_Wt,
      cast(abs( division( sum( Desp_Wt )
                          , 1000
                          , 3 ) ) as abap.dec(12,2) ) as Act_Desp_Wt_MT
}

where
      ProfitCenter is not initial
  and DocumentDate between

  dats_add_days( dats_add_days( $session.system_date, 1 - cast( substring( $session.system_date, 5, 3 ) as abap.int4 ), 'NULL' ), case when substring( $session.system_date, 5, 2 ) < '04' then - 275 -- shift to previous Apr 1
  else 90                                                                                                                                                                                             -- shift to current Apr 1
  end, 'NULL' )

  and $session.system_date

group by
  Plant,
  ProfitCenter
