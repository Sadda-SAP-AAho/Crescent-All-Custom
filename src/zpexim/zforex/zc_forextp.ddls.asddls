@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Forward Contract Booking'
define root view entity ZC_FOREXTP 
   provider contract transactional_query
as projection on ZI_FOREXTP
{ 
        @EndUserText.label: 'ID'
    key Id,
        @Search.defaultSearchElement: true
    @EndUserText.label: 'Forward Contract Number'
    Contnoext,
    @EndUserText.label: 'Bank'
    Bankname,
    @EndUserText.label: 'Currency'
    @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
    Waers,
    Exchagecurr,
    @EndUserText.label: 'Contract Date'
    Contractdate,
    @EndUserText.label: 'Exchange Rate'
    @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
    Exchangerate,
    @EndUserText.label: 'Contract Booking Amount'
    @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
    Contamt,
    @EndUserText.label: 'Balance Value'
    @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
    Balanceval,
    @EndUserText.label: 'Booking Date'
    Bookdate,
    @EndUserText.label: 'Maturity Date'
    Maturitydate,
    @EndUserText.label: 'Option Period Open Dt'
    Opendate,
    @EndUserText.label: 'Booking Allocation Dt'
    Allocdate,
    @EndUserText.label: 'Update'
    Upd,
    
    /* Associations */
    _item : redirected to composition child ZC_FOREXITMTP
    // Make association public
}
