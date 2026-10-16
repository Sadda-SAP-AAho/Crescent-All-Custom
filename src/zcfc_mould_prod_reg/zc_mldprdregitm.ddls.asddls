@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Mould Prod Reg Head'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_MLDPRDREGITM
  as projection on ZI_MLDPRDREGITM
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Type of Mould'
      typeofmould,
      @EndUserText.label: 'Qty'
      Qty,
      @EndUserText.label: 'Remarks'
      Remarks,
      @EndUserText.label: 'Extra 1(numeric)'
      Extra1,
      @EndUserText.label: 'Extra 2'
      Extra2,
      /* Associations */
      _Head : redirected to parent ZC_MLDPRDREGHED

}
