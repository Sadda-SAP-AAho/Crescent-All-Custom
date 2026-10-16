@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attach PO Details'
@Metadata.allowExtensions: true
define view entity zi_ATTACHPO
  as select from zdt_bgattachpo
  association to parent zi_bgheader as _HEAD on $projection.Id = _head.Id
{
  key zdt_bgattachpo.id as Id,
  key zdt_bgattachpo.item3 as Item3,
  zdt_bgattachpo.zeximbgrefno as Zeximbgrefno,
  zdt_bgattachpo.version as Version,
  zdt_bgattachpo.ebeln as Ebeln,
  zdt_bgattachpo.waers as Waers,
  zdt_bgattachpo.netwr as Netwr,
  zdt_bgattachpo.availamount as Availamount,
  zdt_bgattachpo.applamtlc as Applamtlc,
  zdt_bgattachpo.applamtothlc as Applamtothlc,
  zdt_bgattachpo.amountlevel as Amountlevel,
  zdt_bgattachpo.cancel as Cancel,
  zdt_bgattachpo.meins as Meins,
  zdt_bgattachpo.applqty as Applqty,
  zdt_bgattachpo.locallastchangedat as Locallastchangedat,
      _head
}
