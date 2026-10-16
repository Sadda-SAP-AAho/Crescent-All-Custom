@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'OC Form Print'
define root view entity ZC_OCFORM_HEADER
 provider contract transactional_query
 as projection on ZI_OCFORM_Header
{
      @EndUserText.label: 'Order No'
      @Search.defaultSearchElement: true
  key OrdNo,
      @EndUserText.label: 'Date'
      Dt,
      @EndUserText.label: 'Billed To Name'
      BillNm,
      @EndUserText.label: 'Ship To Name'
      ShpNm,
      @EndUserText.label: 'Bill to address'
      BillAdd,
      @EndUserText.label: 'Ship to Address'
      ShpAdd,
      @EndUserText.label: 'Order Currency'
      OrdCurrency,
      @EndUserText.label: 'POD'
      POD,
      @EndUserText.label: 'Shipping Type'
      ShippTyp,
      @EndUserText.label: 'FINAL DESTINATION'
      FnlDst,
      @EndUserText.label: 'Payment Terms'
      PaymentTerms,
      @EndUserText.label: 'Planned Month Of Shipment'
      PlndMnthShipment,
       @EndUserText.label: 'Print Flag'
      printflag,
       @EndUserText.label: 'Flag'
      flag
}
