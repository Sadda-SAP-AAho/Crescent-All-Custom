@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cons View for Vendor Bank Item Upload'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_VEND_BANK_ITM as projection on ZI_VEND_BANK_ITM
{ 
    @EndUserText.label: 'Id'
    key Id,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Vendor'
    key Supp,
    @EndUserText.label: 'Upload Status'
    Updstatus,
    @EndUserText.label: 'criticality Status'
    @UI.hidden: true
    Crcriticalitystatus,
    @EndUserText.label: 'Vendor Name'
    Suppname,
    @EndUserText.label: 'Bank Name'
    Bankname,
    @EndUserText.label: 'Bank Account'
    Bankacc,
    @EndUserText.label: 'Bank Country'
    Bankcou,
    @EndUserText.label: 'Bank Key'
    Bankkey,
    @EndUserText.label: 'Status'
    @UI.hidden: true
    Status,
    /* Associations */
    _head : redirected to parent ZC_VEND_BANK_HDR
}
