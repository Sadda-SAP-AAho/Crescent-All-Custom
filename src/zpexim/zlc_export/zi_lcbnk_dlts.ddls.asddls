@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For LC Export Bank Details'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
define view entity ZI_LCBNK_DLTS
  as select from zdt_lcbnk_dtls
  association to parent ZI_LCEXPHEAD as _head on $projection.Id = _head.Id
{
  key zdt_lcbnk_dtls.id                 as Id,
  key zdt_lcbnk_dtls.item1              as Item1,
      zdt_lcbnk_dtls.banktype           as Banktype,
      zdt_lcbnk_dtls.land1              as Land1,
      zdt_lcbnk_dtls.hktid              as Hktid,
      zdt_lcbnk_dtls.bankl              as Bankl,
      zdt_lcbnk_dtls.hbkid              as Hbkid,
      zdt_lcbnk_dtls.banka              as Banka,
      zdt_lcbnk_dtls.hkont              as Hkont,
      zdt_lcbnk_dtls.brnch              as Brnch,
      zdt_lcbnk_dtls.ort01              as Ort01,
      zdt_lcbnk_dtls.bezei              as Bezei,
      zdt_lcbnk_dtls.swift              as Swift,
      zdt_lcbnk_dtls.locallastchangedat as Locallastchangedat,
      _head
}
