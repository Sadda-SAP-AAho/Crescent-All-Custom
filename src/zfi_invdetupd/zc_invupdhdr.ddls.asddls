@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumption View for Invoice Update'
define root view entity ZC_INVUPDHDR 
provider contract transactional_query
as projection on ZI_INVUPDHDR
{
    @EndUserText.label: 'ID'
    key id,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Invoice Number'
    invno,
    @EndUserText.label: 'Invoice Year'
    invyr,
    @EndUserText.label: 'Invoice Date'
    invdt,
    @EndUserText.label: 'Customer Code'
    custcode,
    @EndUserText.label: 'Customer Name'
    custdesc,
    @EndUserText.label: 'Currency'
    @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
    waers,
    @EndUserText.label: 'Amount'
    @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
    contamt,
    @EndUserText.label: 'Net Due Date'
    netduedt,
    @EndUserText.label: 'Payment Term'
    pterm,
    @EndUserText.label: 'Shipping Bill Date'
    date1,
    @EndUserText.label: 'Next date'
    date2,
    @EndUserText.label: 'Date Indicator'
    datefld
}
