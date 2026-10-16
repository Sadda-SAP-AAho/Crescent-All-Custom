@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumption View of Bank Charges Header'
define root view entity ZC_BNKCHARGE_HDR
  provider contract transactional_query
  as projection on ZI_BNKCHARGE_HDR
{
  @EndUserText.label: 'ID'
  key Id,
  @EndUserText.label: 'Bank Charge Name'
  Bnkchargename,
  @EndUserText.label: 'Category'
  @Search.defaultSearchElement: true
  Category,
  @EndUserText.label: 'Active'
  Active,
  @EndUserText.label: 'GL Code'
  Glcode
}
