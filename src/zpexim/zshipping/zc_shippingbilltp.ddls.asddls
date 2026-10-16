@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forShippingBill'
@ObjectModel.semanticKey: [ 'InternalShipbill' ]
@Search.searchable: true

define root view entity ZC_ShippingBillTP
  provider contract transactional_query
  as projection on ZR_ShippingBillTP
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @EndUserText.label: 'Internal Shipping Bill'
  key InternalShipbill,
      @EndUserText.label: 'Shipping Bill'
      ShippingBill,
      @EndUserText.label: 'Shipping Bill Date'
      ShippingBillDate,
      @EndUserText.label: 'Scroll Number'
      ScrollNo,
      @EndUserText.label: 'Scroll Date'
      ScrollDate,
      @EndUserText.label: 'Custom Handling Agent'
      CustomHandlingAgent,
      @EndUserText.label: 'Port Code'
      PortCode,
      @EndUserText.label: 'Posting Date'
      PostingDate,
      @EndUserText.label: 'Bill of Lading'
      BillOfLading,
      @EndUserText.label: 'Bill of Lading Date'
      BillOfLadingDate,
      @EndUserText.label: 'LEO Date'
      LeoDate,
      @Semantics.amount.currencyCode: 'Fob_Lc_C'
      @EndUserText.label: 'FOB LC Value'
      Fob_Lc_V,
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
      @EndUserText.label: 'FOB LC Currency'
      Fob_Lc_C,
      @Semantics.amount.currencyCode: 'Fob_Fc_C'
      @EndUserText.label: 'FOB FC Value'
      Fob_Fc_V,
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
      @EndUserText.label: 'FOB FC Currency'
      Fob_Fc_C,
      @EndUserText.label: 'Exchange Rate'
      Exchangerate,
      @EndUserText.label: 'Usage Amount'
      UsageAmount,
      @EndUserText.label: 'Total Duty Drawback %'
      TotalDutyDrawback,
      @Semantics.amount.currencyCode: 'TotalDutyDrawbackC'
      @EndUserText.label: 'Total Duty Drawback Value'
      TotalDutyDrawbackV,
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
      @EndUserText.label: 'Total Duty Drawback Currency'
      TotalDutyDrawbackC,
      @EndUserText.label: 'Total RoDTEP %'
      Rodtep,
      @EndUserText.label: 'Total RoDTEP Currency'
      RodtepC,
      @EndUserText.label: 'Total RoDTEP Value'
      RodtepV,
      @EndUserText.label: 'Bill of Lading ~ Country'
      CountryBl,
      StateOfOrigin,
      @EndUserText.label: 'Destination Country'
      DestinationCountry,
      @EndUserText.label: 'Account Post'
      Tpost,
      @EndUserText.label: 'Account Doc No'
      Accountdocno,
      @EndUserText.label: 'Account Doc Yr'
      Accountdocyr,
      @EndUserText.label: 'Account Doc Ref'
      Accpostref,
      @EndUserText.label: 'Account Post'
      Tpostdbk,
      @EndUserText.label: 'Account Doc No'
      Accdocnodbk,
      @EndUserText.label: 'Account Doc Yr'
      Accdocyrdbk,
      @EndUserText.label: 'Account Doc Ref'
      Accpostrefdbk,
      CreatedAt,
      CreatedBy,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      @EndUserText.label: 'Status Cancel'
      Closestatus,
      @EndUserText.label: 'Status Cancel'
      statuscancel,
      @EndUserText.label: 'Invoice No'
      invoicehed,
      @EndUserText.label: 'Posting Date'
      PostingDateNew,
      @UI.hidden: true
      IsReversed,
      @EndUserText.label: 'BRC No.'
      BRCNo,
      @EndUserText.label: 'BRC Date'
      BRCDate,
      @EndUserText.label: 'BRC Value'
      BRCValue,
      _ShippingBillItem    : redirected to composition child ZC_ShippingBillItemTP,
      _ShippingBillItemLIC : redirected to composition child ZC_ShippingBillLICTP
//      _ShippingBillItemBRC : redirected to composition child ZC_BRC

}
