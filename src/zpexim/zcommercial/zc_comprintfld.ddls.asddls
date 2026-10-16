@EndUserText.label: 'Consumtion View for Commercial Print Field'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@Search.searchable: true
define view entity ZC_COMPRINTFLD 
as projection on ZI_COMPRINTFLD
{
@EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Commercial No'
    key Commid,
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
      _head : redirected to parent ZC_COMM_HED
}
