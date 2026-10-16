@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BG FD Details'
@Metadata.allowExtensions: true
define view entity zi_Bgfdassign
  as select from zdt_bgfdassign
  association to parent ZI_BGHEADER as _head on $projection.Id = _head.Id
{
  key zdt_bgfdassign.id as Id,
  key zdt_bgfdassign.item as Item,
  zdt_bgfdassign.fdno as Fdno,
  zdt_bgfdassign.zeximbgrefno as Zeximbgrefno,
  zdt_bgfdassign.fdsubnumber as Fdsubnumber,
  zdt_bgfdassign.waers as Waers,
  zdt_bgfdassign.totalfdamt as Totalfdamt,
  zdt_bgfdassign.linktype as Linktype,
  zdt_bgfdassign.fdavlamt as Fdavlamt,
  zdt_bgfdassign.fdlinkamt as Fdlinkamt,
  zdt_bgfdassign.locallastchangedat as Locallastchangedat,
      _head
}
