@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Confirmation Header'
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_CONF_HDR
  as select from zdt_conf_hdr
  composition [0..*] of ZI_CONF_ITM as _Item
  composition [0..*] of ZI_CONF_ORD as _Ord
{
  key id         as Id,
      shpflrno   as Shpflrno,
      keyid      as Keyid,
      dept       as Dept,
      deptname   as Deptname,
      opr        as Opr,
      oprname    as Oprname,
      cont       as Cont,
      contname   as Contname,
      skilab     as Skilab,
      sskilab    as Sskilab,
      uskilab    as Uskilab,
      creon      as Creon,
      creby      as Creby,
      plant      as Plant,
      plantid    as Plantid,
      header     as Header,
      simu       as Simu,
      alloc      as Alloc,
      scanbrcode as Scanbrcode,
      shpflrdt   as Shpflrdt,
      genser     as Genser,
      arpacharg  as Arpacharg,
      rhinocharg as Rhinocharg,
      handmochrg as Handmochrg,
      lostfmchrg as Lostfmchrg,
      excwtadj   as Excwtadj,
      _Item, // Make association public
      _Ord
}
