@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Expense Calculation Item'
define view entity ZC_EXPENSECAL_I
  as projection on ZI_EXPENSECAL_I
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Commercial Invoice'
      @Search.defaultSearchElement: true
      Commid,
      @EndUserText.label: 'Expense Type'
      Expansetype,
      @EndUserText.label: 'Per Container/Per Shipment'
      Percontship,
      @EndUserText.label: 'Vendor '
      Forwarder,
      @EndUserText.label: 'No of Container/Shipment'
      countcontship,
      @EndUserText.label: 'Value'
      Amount,
      @EndUserText.label: 'Currency'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_Currency', element: 'Currency' } } ]
      Currency,
      @EndUserText.label: 'Exchange Rate'
      Exchangerate,
      @EndUserText.label: 'Bill in INR'
      Amountinr,
      @EndUserText.label: 'Service PO'
      Servicepo,
      @EndUserText.label: 'Service PO Line'
      Servicepoline,
      @EndUserText.label: 'Service Entry Sheet'
      Serentrysheet,
      @EndUserText.label: 'Service PO Button'
      Servicepobt,
      @EndUserText.label: 'Service Entry Sheet Button'
      serviceentrybt,
      @EndUserText.label: 'Service PO Ref'
      serviceporef,
      @EndUserText.label: 'Service Entry Sheet Ref'
      serviceentryref,
      @EndUserText.label: 'Copy'
      copy,
      /* Associations */
      _head : redirected to parent ZC_EXPENSECAL
}
