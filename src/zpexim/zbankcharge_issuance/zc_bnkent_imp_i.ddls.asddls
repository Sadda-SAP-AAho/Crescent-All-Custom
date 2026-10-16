@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Entry Import'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_BNKENT_IMP_I
  as projection on ZI_BNKENT_IMP_I
{
  key Id,
   @Search.defaultSearchElement: true
 key Item,
 @EndUserText.label:'Charge Head'
 Chargehed2,
 @EndUserText.label:'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
 Waers,
 @EndUserText.label:'Rate'
 Amt2,
 @EndUserText.label:'GL Account'
 Glaccount2,
 @EndUserText.label:'Tax Code'
 Taxc2,
 @EndUserText.label:'Charges Waived'
 Status2,
 @EndUserText.label:'Cost Center'
 Costcenter2,
 /* Associations */
 _head : redirected to parent ZC_BNKENT_HDR
 
   }
