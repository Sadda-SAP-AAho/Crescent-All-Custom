@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consuption View for Invoice Data file'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_INVITEM_FILE
  as projection on ZI_INVITEM_FILE
{
      @EndUserText.label: 'Id'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Commercial No'
  key Commid,
      @EndUserText.label: 'Upload Status'
      Updstatus,
      @EndUserText.label: 'criticality Status'
      @UI.hidden: true
      Crcriticalitystatus,
      @EndUserText.label: 'Message'
      Msg,
      @EndUserText.label: 'Status'
      @UI.hidden: true
      Status,
      @EndUserText.label: 'Bank Ref No'
      Bankrefno,
      @EndUserText.label: 'Bill Closed Flag'
      Billcloseflag,
      @EndUserText.label: 'Fund Planning Remarks'
      Fundplanremark,
      @EndUserText.label: 'Planning Month'
      Planingmonth,
      /* Associations */
      _head : redirected to parent ZC_INVINFO_FILE
}
