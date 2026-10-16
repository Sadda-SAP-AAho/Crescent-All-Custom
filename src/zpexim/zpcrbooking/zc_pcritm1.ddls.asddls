@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SOFR Interest Rate'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_PCRITM1
  as projection on ZI_PCRITM1
{
      @EndUserText.label: 'Id'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label:'SOFR/EURO Interest Rate (%)'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
      Sofr,
//      @EndUserText.label:'Currency'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//        }
//      } ]
      @Semantics.currencyCode: true
      Waers,
      @EndUserText.label: 'Valid From'
      Validfromdt,
      @EndUserText.label: 'Valid To'
      Validtodt,

      /* Associations */
      _head : redirected to parent ZC_PCRHDR
}
