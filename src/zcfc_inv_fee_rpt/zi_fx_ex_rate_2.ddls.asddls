@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FX Exchange Rate-2(Weighted Avg)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_FX_EX_RATE_2
  as select distinct from ZI_FOREXTP      as a
    left outer join       ZI_FOREXTPITM   as b on a.Id        =  b.Id
                                               and(
                                                 b.Remarks    <> ''
                                                 or b.Remarks is not null
                                               )

    left outer join       ZI_FX_EX_RATE_2_1 as c on b.Remarks = c.Remarks

{
  key b.Remarks,
      sum( ( case when cast( c.Adjustval as abap.dec(12,3) ) <> cast( '0' as abap.dec(12,3) )
             then cast( division(
                                 ( a.Exchangerate * cast( b.Adjustval as abap.dec(12,3) ) ) ,
                             cast( c.Adjustval as abap.dec(12,3) ),
                                 3 ) as abap.dec(12,3) )
             else cast( '0' as abap.dec(12,3) ) end ) ) as FXRate

}

group by
  b.Remarks
