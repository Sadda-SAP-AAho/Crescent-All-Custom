@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'BOE Form'
define root view entity ZC_BOEFORM
  provider contract transactional_query
  as projection on ZI_BOEFORM
{
      @EndUserText.label: 'Invoice No'
      @Search.defaultSearchElement: true
  key BillNo,
      @EndUserText.label: 'Invoice Date'
      BillDate,
      @EndUserText.label: 'BOE Date'
      Boeddt,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Net Amount'
      NetAmt,
      @EndUserText.label: 'Payment Terms'
      TOP,
      @EndUserText.label: 'Bank Address'
      BankAddr,
      @EndUserText.label: 'Customer Name'
      CustName,
      @EndUserText.label: 'Street'
      StreetName,
      @EndUserText.label: 'Postal Code'
      PostalCode,
      @EndUserText.label: 'City'
      CityName,
      @EndUserText.label: 'Country'
      Country,
      @EndUserText.label: 'Print Flag1'
      printflag1,
      @EndUserText.label: 'Print Flag2'
      printflag2,
      flag
}
