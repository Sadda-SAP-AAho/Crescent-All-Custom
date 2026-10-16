@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for ICICI Pay'
@Metadata.allowExtensions: true
//@Search.searchable: true
define root view entity ZC_ICICI_PAY
provider contract transactional_query
as projection on ZI_ICICI_PAY
{
      key Filename,
      key Createdon,
      key Createdat,
      Filecontent,
      Processed
}
