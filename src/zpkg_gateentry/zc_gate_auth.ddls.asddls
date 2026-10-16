@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Gate Authorization Maintenance'
define root view entity ZC_GATE_AUTH
  provider contract transactional_query
  as projection on Zi_gate_auth
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Gate Entry Type'
      Type,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'User Id'
      Userid
}
