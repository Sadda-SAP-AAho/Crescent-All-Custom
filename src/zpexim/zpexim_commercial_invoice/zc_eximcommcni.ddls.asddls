@EndUserText.label: 'Commercial Container Item'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_EXIMCOMMCNI

  as projection on ZI_EXIMCOMMCNI

{

      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Container No.'
      Containerno,
      @EndUserText.label: 'Container Size'
      Containersize,
      @EndUserText.label: 'Seal No.'
      Sealno,
      @EndUserText.label: 'UoM'
      Uom,
      @EndUserText.label: 'Tare Weight'
      Tareweight,
      @EndUserText.label: 'Gross Weight'
      Grossweight,
      @EndUserText.label: 'E-Way Bill No.'
      Ewaybillno,
      @EndUserText.label: 'Remarks'
      Remarks,

      /* Associations */
      _head : redirected to parent ZC_EXIMCOMMHDR

}
