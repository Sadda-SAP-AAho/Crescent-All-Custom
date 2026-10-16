@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXIM Club Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_EXIMCLUBITM

  as select from zexim_club_itm

  association to parent ZI_EXIMCLUBHDR as _head on $projection.id = _head.id
{

  key id,
  key item,
      clubnointernal,
      choose,
      invoice,
      posnr,
      matnr,
      maktx,
      hsnsac,
      @Semantics.quantity.unitOfMeasure: 'uom'
      availableqty,
      @Semantics.quantity.unitOfMeasure: 'uom'
      appliedqty,
      uom,
      @Semantics.amount.currencyCode: 'currency'
      netprice,
      @Semantics.amount.currencyCode: 'currency'
      netvalue,
      currency,
      @Semantics.quantity.unitOfMeasure: 'uom'
      netweight,
      @Semantics.quantity.unitOfMeasure: 'uom'
      grossweight,
      plant,

      _head

}
