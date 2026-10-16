@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FX Exchange Rate(Weighted Avg)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_FX_EX_RATE
  as select distinct from ZI_FOREXTP      as a
    left outer join       ZI_FOREXTPITM   as b on a.Id = b.Id
    left outer join       ZI_FX_EX_RATE_1 as c on  b.Instructdate = c.Instructdate
                                               and a.Bankname     = c.Bankname
{
  key b.Instructdate,
  key a.Bankname,
      sum( ( case when cast( c.Adjustval as abap.dec(12,3) ) <> cast( '0' as abap.dec(12,3) )
             then cast( division(
                                 ( a.Exchangerate * cast( b.Adjustval as abap.dec(12,3) ) ) ,
                             cast( c.Adjustval as abap.dec(12,3) ),
                                 3 ) as abap.dec(12,3) )
             else cast( '0' as abap.dec(12,3) ) end ) ) as FXRate

}

group by
  b.Instructdate,
  a.Bankname
