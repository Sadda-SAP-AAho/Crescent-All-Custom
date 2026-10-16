@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA HEADER'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZI_DPR_BARD_HEAD
  as select from    ZI_CC_TYPE_DPR_BARD as a
    left outer join zdt_dpr_bard        as b on  b.plant = '1400'
                                             and b.kostl = a.Kostl
  composition [0..*] of ZI_DPR_BARD_ITM as _item
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
      a.Cctype =  'BARD'
  and b.kostl  <> '140001'
