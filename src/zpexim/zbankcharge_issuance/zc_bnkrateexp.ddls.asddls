@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of Export'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_BNKRATEEXP
  as projection on ZI_BNKRATEEXP
{
  key Id,
      @Search.defaultSearchElement: true
  key Item,
  @EndUserText.label:'Charge Head'
  Chargehead,
  @EndUserText.label:'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
  Waers,
  @EndUserText.label:'Rate'
  Rate,
  /* Associations */
 _head : redirected to parent ZC_BNKRATE_HDR
 }
