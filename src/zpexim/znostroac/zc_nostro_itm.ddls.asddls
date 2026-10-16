@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumtion View for NOSTRO Item'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_NOSTRO_Itm
  as projection on ZI_NOSTRO_itm
{
      @EndUserText.label: 'Id'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Check Box'
      Checkbox,
      @EndUserText.label: 'Accounting Document'
      @Search.defaultSearchElement: true
      Accountingdocument,
      @EndUserText.label: 'Accounting Document Item'
      accountingdocumentitem,
      @EndUserText.label: 'Reference'
      Referenceno,
      @EndUserText.label: 'Document Type'
      Accountingdocumenttype,
      @EndUserText.label: 'Document Date'
      Documentdate,
      @EndUserText.label: 'Posting Date'
      Postingdate,
      @EndUserText.label: 'Amount In Doc Currency'
      Amountdc,
      @EndUserText.label: 'Currency'
      Currencydc,
      @EndUserText.label: 'Remaining Amount'
      remainamtdc,
      @EndUserText.label: 'Amount In Co Code Curr'
      Amountcc,
      @EndUserText.label: 'Currency'
      Currencycc,
      @EndUserText.label: 'Payment Term'
      payterm,
      @EndUserText.label: 'Due Date' 
      Duedate,
      @EndUserText.label: 'Inward Reference Number'
      Inwardrefno,
      @EndUserText.label: 'Inward Date'
      Inwarddate,
      @EndUserText.label: 'Swift Date'
      Swiftdate,
      @EndUserText.label: 'Inward Amount'
      Inwardamount,
      @EndUserText.label: 'Currency'
      Currencyinward,
      @EndUserText.label: 'Inward Rec Status in Full'
      Inwardrecordstatus,
      @EndUserText.label: 'AccUpdate'
      Accupdateitm,
      /* Associations */
      _Head : redirected to parent ZC_NOSTRO_hed
}
