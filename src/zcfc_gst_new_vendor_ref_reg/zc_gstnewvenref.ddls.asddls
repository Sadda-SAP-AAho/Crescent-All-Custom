@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST New Vendor Ref Register'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_GSTNEWVENREF
  provider contract transactional_query
  as projection on ZI_GSTNEWVENREF
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Fiscal Year'
      Fisyear,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Journal Entry No'
      Jeno,
      @EndUserText.label: 'Posting Date'
      Jedate,
      @EndUserText.label: 'Supplier Code'
      Supplcode,
      @EndUserText.label: 'JE Reference No'
      Jerefno,
      @EndUserText.label: 'New Vendor Reference No'
      Newvendrefno
}
