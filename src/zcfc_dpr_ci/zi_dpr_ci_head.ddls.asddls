@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR CI HEADER'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZI_DPR_CI_HEAD
  as select from    ZI_CC_TYPE_DPR_CI as a
    left outer join zdt_dpr_ci     as b on  b.plant = '1100'
                                        and b.kostl = a.Kostl
  composition [0..*] of ZI_DPR_CI_ITM as _item
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
  a.Cctype = 'CI'
