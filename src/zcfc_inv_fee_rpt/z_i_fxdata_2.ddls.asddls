@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FX Data-2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_FXDATA_2
  as select distinct from ZI_FOREXTP    as a
    left outer join       ZI_FOREXTPITM as b on a.Id        =  b.Id
                                             and(
                                               b.Remarks    <> ''
                                               or b.Remarks is not null
                                             )
{
  key b.Remarks,
  key a.Contnoext

}
