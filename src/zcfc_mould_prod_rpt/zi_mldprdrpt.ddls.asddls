@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mould Production Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MLDPRDRPT
  as select distinct from ZI_MLDPRDREGHED as a
    left outer join       ZI_MLDPRDREGITM as b on a.ID = b.Id
{
  key a.ID,
  key b.Item,
      a.prddate,
      a.plntcd,
      a.plntnm,
      a.cstcntr,
      a.cstcntrnm,
      a.prftcntr,
      a.prftcntrnm,
      b.typeofmould,
      cast( b.Qty as abap.dec(15,3) ) as Qty,
      b.Remarks,
      cast( b.Extra1 as abap.dec(15,3) ) as Extra1,
      b.Extra2
}
