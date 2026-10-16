@EndUserText.label: 'Commercial Additional'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_EXIMCOMMADD

  as projection on ZI_EXIMCOMMADD

{

      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Payment Text'
      Paymenttext,
      @EndUserText.label: 'Invoice Remarks 1'
      Invoiceremarks1,
      @EndUserText.label: 'Invoice Remarks 2'
      Invoiceremarks2,
      @EndUserText.label: 'Invoice Remarks 3'
      Invoiceremarks3,
      @EndUserText.label: 'Tax Remarks'
      Taxremarks,
      @EndUserText.label: 'Material Desc. 1'
      Materialdesc1,
      @EndUserText.label: 'Material Desc. 2'
      Materialdesc2,
      @EndUserText.label: 'Material Desc. 3'
      Materialdesc3,

      /* Associations */
      _head : redirected to parent ZC_EXIMCOMMHDR

}
