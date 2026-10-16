@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOE LIC'
define view entity ZR_BOELICTP

  //  as select from zim_boe_lic
  as select from zdt_boe_lic

  association to parent ZR_BOETP as _BOE on $projection.InternalBoe = _BOE.InternalBoe
{
  key zdt_boe_lic.internalboe        as InternalBoe,
  key zdt_boe_lic.internalitemboe    as InternalItemBoe,
      zdt_boe_lic.licencenumber      as Licencenumber,
      zdt_boe_lic.licenceint         as Licencint,
      @Semantics.amount.currencyCode : 'FobFc'
      zdt_boe_lic.usageamount        as Usageamount,
      @Semantics.amount.currencyCode : 'FobFc'
      zdt_boe_lic.pendingamount      as Pendingamount,
      @Semantics.amount.currencyCode : 'FobFc'
      zdt_boe_lic.assignamount       as assignamount,      
      zdt_boe_lic.fob_fc             as FobFc,
      zdt_boe_lic.locallastchangedat as Locallastchangedat,

      _BOE
}
