@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for Final PL print fields'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_FPLPRINTFIELD as 
projection on ZI_FPLPRINTFIELD
{
@EndUserText.label: 'ID'
  key Id,
  @EndUserText.label: 'Packing List No'
  key Packinglist,
  @EndUserText.label: 'Item Id'
  key Item,
  @EndUserText.label: 'Print Field'
  Field,
  @EndUserText.label: 'Field Name'
  Fieldname,
  @EndUserText.label: 'Print Allow'
  Printallow,
  @EndUserText.label: 'Print Sequence'
  Printseq,
  /* Associations */
  _head: redirected to parent ZC_FINALPACK_HDR


}
