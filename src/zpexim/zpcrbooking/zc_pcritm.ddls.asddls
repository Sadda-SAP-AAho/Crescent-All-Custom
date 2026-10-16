@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Adjustment Document Details'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_PCRITM
  as projection on ZI_PCRITM
{
  key Id,
      @Search.defaultSearchElement: true
  key Item,
      @EndUserText.label:'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
      Waers,
      @EndUserText.label:'Adjustment Doc Type'
      Adjustdoctype,
      @EndUserText.label:'A/R Inv No'
      Invno,
      @EndUserText.label:'A/R Inv Date'
      Invdt,
      @EndUserText.label:'Invoice Open Amount'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
      Invopenamt,
      @EndUserText.label:'Remarks'
      Remarks,
      @EndUserText.label:'Instruction Date'
      Instructdt,
      @EndUserText.label:'Adjusted Amount'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
      Adjamt,
      @EndUserText.label:'LC Number'
      Lcnumber,
      @EndUserText.label:'LC Date'
      Lcdate,
//      @EndUserText.label:'Fiscal Year'
//      Fiscalyear,
//      @EndUserText.label:'Company Code'
//      Cocode,
      Lcurr,
      @EndUserText.label:'LC Amount'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
      Lcamt,
      @EndUserText.label:'Fiscal Year'
      Fiscalyear,
      @EndUserText.label:'Company Code'
      Cocode,
      Othercurr,
      @EndUserText.label:'Other Amount'
      Otheramt,
      @EndUserText.label:'Other'
      Othertext,
      /* Associations */
      _head : redirected to parent ZC_PCRHDR
}
