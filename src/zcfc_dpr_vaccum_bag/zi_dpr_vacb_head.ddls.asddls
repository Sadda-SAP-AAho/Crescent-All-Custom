@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACUUM KUL HEADER'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZI_DPR_VACB_HEAD
  as select from    ZI_CC_TYPE_DPR_VACB as a
    left outer join zdt_dpr_vacb        as b on  b.plant = '1300'
                                             and b.kostl = a.Kostl
  composition [0..*] of ZI_DPR_VACB_ITM as _item
{
  key cast( a.Plant as werks_d ) as plant,
  key a.Kostl,
      b.indate,
      'X'                        as upd,
      b.lastupdby,
      b.lastupdon,
      b.lastupdat,
      _item
}
where
      a.Cctype =  'BAG1'
  and a.Kostl  <> '130001'
