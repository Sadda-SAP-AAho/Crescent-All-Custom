@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of Import'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_BNKRATEIMP
  as projection on ZI_BNKRATEIMP
{
  key Id,
      @Search.defaultSearchElement: true
  key Item,
  @EndUserText.label:'Charge Head'
  Chargehead1,
  @EndUserText.label:'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
  Waers,
  @EndUserText.label:'Rate'
  Rate1,
  /* Associations */
 _head : redirected to parent ZC_BNKRATE_HDR
 }
