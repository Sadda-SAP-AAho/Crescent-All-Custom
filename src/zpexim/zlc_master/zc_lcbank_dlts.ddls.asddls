@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumption View for LC Bank Details'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZC_LCBANK_DLTS 
  as projection on zi_lcbank_dlts
{
    @EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Item'
    key Item1,
    @EndUserText.label: 'Bank Type'
    Banktype,
    @EndUserText.label: 'Country'
    Land1,
    @EndUserText.label: 'Account ID'
    Hktid,
    @EndUserText.label: 'Bank Key'
    Bankl,
    @EndUserText.label: 'House Bank'
    Hbkid,
    @EndUserText.label: 'Bank Name'
    Banka,
    @EndUserText.label: 'GL Account'
    Hkont,
    @EndUserText.label: 'Branch'
    Brnch,
    @EndUserText.label: 'City'
    Ort01,
    @EndUserText.label: 'State'
    Bezei,
    @EndUserText.label: 'BIC Code'
    Swift,
         Locallastchangedat,
    /* Associations */
    _head : redirected to parent zc_lchead
}
