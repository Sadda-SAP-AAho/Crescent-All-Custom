@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Entry BG'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_BNKENT_BG_I
  as projection on ZI_BNKENT_BG_I
{
  key Id,
   @Search.defaultSearchElement: true
 key Item,
 @EndUserText.label:'Charge Head'
 Chargehed3,
 @EndUserText.label:'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
 Waers,
 @EndUserText.label:'Rate'
 Amt3,
 @EndUserText.label:'GL Account'
 Glaccount3,
 @EndUserText.label:'Tax Code'
 Taxc3,
 @EndUserText.label:'Charges Waived'
 Status3,
 @EndUserText.label:'Cost Center'
 Costcenter3,
 /* Associations */
 _head : redirected to parent ZC_BNKENT_HDR
 
   }
