@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FX Exchange Rate-2_1(Weighted Avg)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_FX_EX_RATE_2_1
  as select distinct from ZI_FOREXTP    as a
    left outer join       ZI_FOREXTPITM as b on a.Id        =  b.Id
                                             and(
                                               b.Remarks    <> ''
                                               or b.Remarks is not null
                                             )
{
  key b.Remarks,
      sum( cast( b.Adjustval as abap.dec(12,3) ) ) as Adjustval

}

group by
  b.Remarks
