@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Summary Report-Painting'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOMSM_PAINT
  as select distinct from ZR_BOMCOST_RPT   as a
    left outer join       zdt_pp_matinffld as b on a.Component = b.product
{
  key a.Plant,
  key a.Hedmaterial,
      sum(b.sqmtr * a.Childqty) as sqmtr
}

where
      a.HeaderGrpCode = 'Z003'
  and a.ChildGrpCode  = 'Z028'

group by
  a.Plant,
  a.Hedmaterial
