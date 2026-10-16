@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Bank Wise Rate Maintenance'
define root view entity ZC_BNKRATE_HDR
  provider contract transactional_query
  as projection on ZI_BNKRATE_HDR
{
      @EndUserText.label: 'ID'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Bank Name'
      Bankname,
      @EndUserText.label: 'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
      Waers,
      @EndUserText.label: 'Bank Key'
      Bankkey,
      @EndUserText.label: 'Account Id'
      Housebnkid,
      @EndUserText.label: 'House Bank'
      Accountid,
      /* Associations */
      _item  : redirected to composition child ZC_BNKRATEEXP,
      _item1 : redirected to composition child ZC_BNKRATEIMP,
      _item2 : redirected to composition child ZC_BNKRATEBG
}
