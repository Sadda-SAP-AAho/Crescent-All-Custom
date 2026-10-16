@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'PROJECTION VIEW ZI_LABOUR_BOOK_ITEM'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_LABOUR_BOOK_ITEM as projection on ZI_LABOUR_BOOK_ITEM
{

  @EndUserText.label: 'ID'
  key Id,
  @EndUserText.label: 'Item'
  key Item,
  @EndUserText.label: 'Work Code'
  Workcode,
  @EndUserText.label: 'Work Name'
  Workname,
  @EndUserText.label: 'UOM'
  Uom,
  @EndUserText.label: 'Quantity'
  Quantity,
  @EndUserText.label: 'Rate'
  Rate,
  @EndUserText.label: 'Amount'
  Amount,
  @EndUserText.label: 'Approved By Code'
  Approvedbycode,
  @EndUserText.label: 'Approved By Name'
  Approvedbyname,
  /* Associations */
  _Head : redirected to parent ZC_LABOUR_BOOK

}
