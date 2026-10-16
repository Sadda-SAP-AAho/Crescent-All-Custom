@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Entry Export'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_BNKENT_EXP_I
  as projection on ZI_BNKENT_EXP_I
{
 key Id,
  @Search.defaultSearchElement: true
 key Item,
 @EndUserText.label:'Charge Head'
 Chargehed1,
 @EndUserText.label:'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
 Waers,
 @EndUserText.label:'Rate'
 Amt1,
 @EndUserText.label:'GL Account'
 Glaccount1,
 @EndUserText.label:'Tax Code'
 Taxc1,
 @EndUserText.label:'Charges Waived'
 Status1,
 @EndUserText.label:'Cost Center'
 Costcenter1,
 /* Associations */
 _head : redirected to parent ZC_BNKENT_HDR
}
