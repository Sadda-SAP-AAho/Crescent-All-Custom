@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FX Date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_FXDATE
  as select distinct from ZI_FOREXTP    as a
    left outer join       ZI_FOREXTPITM as b on a.Id = b.Id
{
  key b.Instructdate,
  key a.Bankname,
  key a.Bookdate    
      
}
