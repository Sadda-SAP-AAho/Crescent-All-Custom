@Metadata.allowExtensions: true
@EndUserText.label: 'Shipment Information-Insia'
@Metadata.ignorePropagatedAnnotations: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_SHIPINFOINSIA
  provider contract transactional_query
  as projection on ZI_SHIPINFOINSIA
{
      @EndUserText.label: 'TAX Invoice Number'
      @Search.defaultSearchElement: true
  key Tax_Inv_No,
      @EndUserText.label: 'TAX Invoice Date'
  key Tax_Inv_Date,
      @EndUserText.label: 'Commercial Invoice Number'
  key Comm_Inv_No,
      @EndUserText.label: 'Commercial Invoice Date'
      Comm_Inv_Date,
      @EndUserText.label: 'Create Date'
      CreateDate,
      @EndUserText.label: 'Update Date'
      UpdateDate,
      @EndUserText.label: 'Customer'
      Customer,
      @EndUserText.label: 'B/L No.'
      BL_No,
      @EndUserText.label: 'B/L Date'
      BL_Date,
      @EndUserText.label: 'Container No.'
      Container_No,
      @EndUserText.label: 'Net Weight'
      Net_Weight,
      @EndUserText.label: 'Gross Weight'
      Gross_Weight,
      @EndUserText.label: 'Tentative ETA'
      Tentative_ETA,
      @EndUserText.label: 'Actual ETA/ATA'
      Actual_ETA,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Exchange Rate'
      ExchangeRate,
      @EndUserText.label: 'Value(Commercial Inv) In DC'
      ValueInDC,
      @EndUserText.label: 'VALUE (COMMERCIAL INV) IN LC'
      ValueInLC
}
