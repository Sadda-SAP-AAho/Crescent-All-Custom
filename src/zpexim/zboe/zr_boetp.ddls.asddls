@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOE'
define root view entity ZR_BOETP

  as select from zim_boe_hdr

  composition [0..*] of ZR_BOEITEMTP as _BOEItem

  composition [0..*] of ZR_BOELICTP  as _BOELIC

{
  key internalboe        as InternalBoe,
      boenumber          as Boenumber,
      boedate            as Boedate,
      blnumber           as Blnumber,
      bldate             as Bldate,
      exchangerate       as Exchangerate,
      supplier           as Supplier,
      suppliername,
      shipmentmode       as Shipmentmode,
      loadingport        as Loadingport,
      unloadingport      as Unloadingport,
      incoterms          as Incoterms,
      zim_boe_hdr.assessableamount,
      zim_boe_hdr.usageamount,

      locallastchangedat as Locallastchangedat,

      _BOEItem,
      _BOELIC
}
