@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Scroll Number'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zf4_scroll_number
  as select from ZR_SCROLLHEAD as a
    inner join   ZR_SCROLLITEM as b on a.id = b.id
{
      @EndUserText.label: 'Scroll No'
  key a.scrollno,
      @EndUserText.label: 'Shipping Bill No'
  key b.shipping_bill

}
where
      a.post       is not initial
  and a.scrolltype = '1'
