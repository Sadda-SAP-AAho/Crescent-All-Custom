@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXIM Club Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_EXIMCLUBITM

  as projection on ZI_EXIMCLUBITM

{
      @EndUserText.label: 'ID'
  key id,
      @EndUserText.label: 'Item'
  key item,
      @EndUserText.label: 'SAP Clubbing No.'
      clubnointernal,
      @EndUserText.label: 'Choose Invoice'
      choose,
      @EndUserText.label: 'Invoice'
      invoice,
      @EndUserText.label: 'Item'
      posnr,
      @EndUserText.label: 'Material'
      matnr,
      @EndUserText.label: 'Desc.'
      maktx,
      @EndUserText.label: 'HSN-SAC'
      hsnsac,
      @EndUserText.label: 'Available Quantity'
      @Semantics.quantity.unitOfMeasure: 'uom'
      availableqty,
      @EndUserText.label: 'Applied Quantity'
      @Semantics.quantity.unitOfMeasure: 'uom'
      appliedqty,
      @EndUserText.label: 'UoM'
      uom,
      @EndUserText.label: 'Net Price'
      @Semantics.amount.currencyCode: 'currency'
      netprice,
      @EndUserText.label: 'Net Value'
      @Semantics.amount.currencyCode: 'currency'
      netvalue,
      @EndUserText.label: 'Currency'
      currency,
      @EndUserText.label: 'Net Weight'
      @Semantics.quantity.unitOfMeasure: 'uom'
      netweight,
      @EndUserText.label: 'Gross Weight'
      @Semantics.quantity.unitOfMeasure: 'uom'
      grossweight,
      @EndUserText.label: 'Plant'
      plant,
      /* Associations */
      _head : redirected to parent ZC_EXIMCLUBHDR
}
