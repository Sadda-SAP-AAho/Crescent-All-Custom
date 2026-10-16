@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of BG'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_BNKRATEBG
  as projection on ZI_BNKRATEBG
{
  key Id,
      @Search.defaultSearchElement: true
  key Item,
  @EndUserText.label:'Charge Head'
  Chargehead2,
  @EndUserText.label:'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
  Waers,
  @EndUserText.label:'Rate'
  Rate2,
  /* Associations */
 _head : redirected to parent ZC_BNKRATE_HDR
 }
