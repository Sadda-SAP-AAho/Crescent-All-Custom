@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View Item Advance Upload'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_advanceuploaditm
  as select from zadvpay_itm
  association to parent zi_advanceupload as _head on $projection.Id = _head.Id
{
  key id            as Id,
  key item          as Item,
      companycode   as Companycode,
      documentdate  as Documentdate,
      postingdate   as Postingdate,
      text          as Text,
      reference     as Reference,
      currency      as Currency,
      exchangerate  as Exchangerate,
      vendorcode    as Vendorcode,
      splindicator  as Splindicator,
      amount        as Amount,
      glaccount     as Glaccount,
      valuedate     as Valuedate,
      profitcenter  as Profitcenter,
      businessplace as Businessplace,
      sectioncode   as Sectioncode,
      _head
}
