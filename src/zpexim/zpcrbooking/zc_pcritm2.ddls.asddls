@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order/Contract Details'
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_PCRITM2
  as projection on ZI_PCRITM2
{
      @EndUserText.label: 'Id'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label:'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
      Waers,
      @EndUserText.label: 'Sales Order Doc Entry'
      Sodocentry,
      @EndUserText.label: 'Sales Order/Sales Contract No'
      Sordno,
      @EndUserText.label: 'Sales Order Date'
      Sorddt,
      @EndUserText.label: 'Customer Code'
      Cuscode,
      @EndUserText.label: 'Payment Terms'
      Payterm,
      @EndUserText.label: 'Bank'
      Bank,
      @EndUserText.label: 'Basic Amount'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
      Basicamt,
      @EndUserText.label: 'Applicable amount'
      Applicableamt,
      /* Associations */
      _head : redirected to parent ZC_PCRHDR
}
