@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Expense Condition Record Dashboard'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_EXPENSECOND
  provider contract transactional_query
  as projection on ZI_EXPENSECOND
  
{
  key id,
      @EndUserText.label: 'Company Code'
  key companycode,
//      @EndUserText.label: 'Container'
//      @Search.defaultSearchElement: true
//      Contno,
      
      @EndUserText.label: 'Container Size'
      @Search.defaultSearchElement: true
      Contsize,
      
      @EndUserText.label: 'Shipping Line'
      Shipline,

      @EndUserText.label: 'Forwarder'
      @Search.defaultSearchElement: true
      Forwarder,
      
      @EndUserText.label: 'Country of Destination'
      @Search.defaultSearchElement: true
      Countrydest,
      
      @EndUserText.label: 'Expense Type'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_EXPENSETYPE_F4', element: 'Expansetype'} } ]
      Expansetype,
      
      @EndUserText.label: 'Per Container/Shipment'
      percontship,
      
      @EndUserText.label: 'From Date'
      Fromdate,
      
      @EndUserText.label: 'To Date'
      Todate,
      
      @EndUserText.label: 'Amount'
      Amount,
      
      @EndUserText.label: 'Currency'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
      Currency
}
//ZI_ExpenseTypeMaintain
