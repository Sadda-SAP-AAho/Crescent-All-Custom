@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gatepass F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_HGATE_F4
  as select distinct from ZI_HGATE_PASS    as a
    inner join            ZI_ItemGATE_PASS as b on(
      a.Id = b.Id
    )
{

  key a.Gatepass,

      a.Gatetype,

      a.CreateDate,
      @EndUserText.label: 'Department Code'
      a.Depmtcode
}
where
      a.Gatetype    = 'RGP'
  and a.Appr4status is not initial
  and b.gateno      is initial
