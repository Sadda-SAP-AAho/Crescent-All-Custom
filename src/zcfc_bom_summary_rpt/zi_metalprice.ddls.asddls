@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Metal Price-Pig Iron & Ferro Alloys'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_METALPRICE
  as select distinct from ZR_BOMCOST_RPT as a
    left outer join       ZI_SPLRTMSTHED as b on  a.Component    = b.Lmcd
                                              and a.Plant        = b.Plntcd
                                              and a.ChildGrpCode = 'Z021'
    left outer join       ZI_SPLRTMSTITM as c on b.Id = c.Id


{
  key a.Plant,
  key a.Hedmaterial,
      coalesce(c.Rate,0) as metalprc

}

where
      c.Datefrom <= $session.system_date
  and c.Dateto   >= $session.system_date
