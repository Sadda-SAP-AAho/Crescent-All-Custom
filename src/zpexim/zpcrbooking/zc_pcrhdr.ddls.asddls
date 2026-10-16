@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Loan Dashboard'
define root view entity ZC_PCRHDR
  provider contract transactional_query
  as projection on ZI_PCRHDR
{
      @EndUserText.label: 'ID'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Loan Account Number'
      Loanacno,
      @EndUserText.label: 'Name'
      Name,
      @EndUserText.label: 'Loan Booking Date'
      Bookingdt,
      @EndUserText.label: 'Bank'

      Bankname,
      @EndUserText.label:'Currency'
      @Consumption.valueHelpDefinition: [ {
      entity: {
      name: 'I_Currency',
      element: 'Currency'
      }
      } ]
      Waers,
      @EndUserText.label:'Exchange Rate'
      //      @Consumption.valueHelpDefinition: [ {
      //      entity: {
      //      name: 'I_Currency',
      //      element: 'Currency'
      //      }
      //      } ]
      Exchangerate1,
      @EndUserText.label:'Loan Booking Amount'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Bookamt,
      @EndUserText.label:'Loan Balance Amount'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Balanceamt,
      @EndUserText.label: 'Loan Due Date'
      Duedt,
      @EndUserText.label: 'Loan Extended Due Date'
      Extduedt,
      @EndUserText.label: 'Interest Rate-Spread'
      Intratesp,
      @EndUserText.label: 'Benchmark Type'
      Benchmarktype,
      Intratelib,
      @EndUserText.label:'USD Amount '
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Amtusd,
      @EndUserText.label:'USD Exchange Rate'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Rateusd,
      @EndUserText.label:'EURO Amount'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Amteuro,
      @EndUserText.label:'EURO Exchange Rate'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Rateuro,
      @EndUserText.label:'NZD Amount'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Nzdamt,
      @EndUserText.label:'NZD Exchange Rate'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Ratenzd,
      @EndUserText.label:'GBP Amount'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Amtgbp,
      @EndUserText.label:'GBP Exchange Rate'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Rategbp,
      @EndUserText.label:'CAN Amount'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Amtcan,
      @EndUserText.label:'CAN Exchange Rate'
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Ratecan,
      @EndUserText.label:'Customer Code'
      Cuscode,
      @EndUserText.label:'Loan Type'
      Loantype,
      @EndUserText.label:'Base Document Type'
      Basedoctype,
      @EndUserText.label:'Benchmark Interest Rate'
//      @Consumption.valueHelpDefinition: [ {
//              entity: {
//              name: 'I_Currency',
//              element: 'Currency'
//              }
//              } ]
      Benchintrate,
      @EndUserText.label:'Interest Days'
      Interestdays,
      Intdays,
//      @Consumption.valueHelpDefinition: [ {
//      entity: {
//      name: 'I_Currency',
//      element: 'Currency'
//      }
//      } ]
      Exchratecurr,
      @Semantics.currencyCode: true
      Currency,
      Exchangerate,
      @EndUserText.label:'Loan GL Account'
      Cloanglacc,
      @EndUserText.label:'Loan House Bank'
      Cloanhousebank,
      @EndUserText.label:'Loan Bank Account ID'
      Cloanbankaccid,
      @EndUserText.label:'Debit GL/Bank Account'
      Dglbankacc,
      @EndUserText.label:'House Bank'
      Dhousebank,
      @EndUserText.label:'Bank Account ID'
      Dbankaccid,
      @EndUserText.label:'Account Post'
      Accpost,
      @EndUserText.label:'Account Doc No'
      Accountdocno,
      @EndUserText.label:'Account Doc Yr'
      Accountdocyr,
      @EndUserText.label:'Acc Ref'
      Accpostref,
      @EndUserText.label:'Account Posting Date'
      Accpostdate,
      @EndUserText.label:'Account Document Date'
      Accdocdate,
      @EndUserText.label:'Update'
      Upd,
      /* Associations */
      _item  : redirected to composition child ZC_PCRITM,
      _item1 : redirected to composition child ZC_PCRITM1,
      _item2 : redirected to composition child ZC_PCRITM2
      // Make association public
}
