@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forShippingBillItem'
@ObjectModel.semanticKey: [ 'InternalShipbillItem' ]
@Search.searchable: true
define view entity ZC_ShippingBillItemTP
  as projection on ZR_ShippingBillItemTP
{
         @Search.defaultSearchElement: true
         @Search.fuzzinessThreshold: 0.90
  key    InternalShipbillItem,
  key    InternalShipbill,
         @EndUserText.quickInfo: 'Invoice Number'
         @EndUserText.label: 'Invoice Number'

         @Consumption.valueHelpDefinition: [{
           entity:{ element: 'BillingDocument', name: 'ZI_BILLINGDOCUMENTITEM_2_1' },

           distinctValues: true,
           useForValidation: true,

           additionalBinding: [
                               { localElement: 'InvoiceDate', element: 'BillingDocumentDate', usage: #RESULT },
                                          { localElement: 'InvoiceValueFcV', element: 'NetAmount', usage: #RESULT },
                                          { localElement: 'InvoiceValueFcC', element: 'TransactionCurrency', usage: #RESULT },
                               { localElement: 'Exchangerate', element: 'PriceDetnExchangeRate', usage: #RESULT },
         //                                 { localElement: 'total_duty_drawback_lc', element: 'DutyDrawbackP', usage: #RESULT },
                                          { localElement: 'total_duty_drawback_v_lc', element: 'DutyDrawbackV', usage: #RESULT },
                                          { localElement: 'total_duty_drawback_v_fc', element: 'DutyDrawbackVfc', usage: #RESULT },
         //                                 { localElement: 'total_rodtep_lc', element: 'RoDTEPP', usage: #RESULT },
                                          { localElement: 'total_rodtep_v_lc', element: 'RoDTEPV', usage: #RESULT },
                                          { localElement: 'total_rodtep_v_fc', element: 'RoDTEPVfc', usage: #RESULT },
                                          { localElement: 'InvoiceValueLcC', element: 'LocalCurrency', usage: #RESULT }
                               ] }]
         Invoice,
         @EndUserText.quickInfo: 'Invoice Date'
         @EndUserText.label: 'Invoice Date'
         InvoiceDate,
         @EndUserText.quickInfo: 'Invoice Value FC'
         @EndUserText.label: 'Invoice Value FC'
         @Semantics.amount.currencyCode: 'InvoiceValueFcC'
         InvoiceValueFcV,
         @EndUserText.quickInfo: 'Foreign Currency'
         @EndUserText.label: 'Foreign Currency'
         @Consumption.valueHelpDefinition: [ {
           entity: {
             name: 'I_Currency',
             element: 'Currency'
           }
         } ]
         InvoiceValueFcC,
         @EndUserText.quickInfo: 'Exchange Rate'
         @EndUserText.label: 'Exchange Rate'
         Exchangerate,
         @EndUserText.quickInfo: 'Invoice Value LC'
         @EndUserText.label: 'Invoice Value LC'
         @Semantics.amount.currencyCode: 'InvoiceValueLcC'
         InvoiceValueLcV,
         @EndUserText.quickInfo: 'Local Currency'
         @EndUserText.label: 'Local Currency'
         @Consumption.valueHelpDefinition: [ {
           entity: {
             name: 'I_Currency',
             element: 'Currency'
           }
         } ]
         InvoiceValueLcC,
         @EndUserText.quickInfo: 'Duty Drawback %'
         @EndUserText.label: 'Duty Drawback %'
         total_duty_drawback_lc,
         @EndUserText.quickInfo: 'Duty Drawback Value(LC)'
         @EndUserText.label: 'Duty Drawback Value(LC)'
         @Semantics.amount.currencyCode: 'InvoiceValueLcC'
         total_duty_drawback_v_lc,
         @EndUserText.quickInfo: 'RoDTEP %'
         @EndUserText.label: 'RoDTEP %'
         total_rodtep_lc,
         @EndUserText.quickInfo: 'RoDTEP Value(LC)'
         @EndUserText.label: 'RoDTEP Value(LC)'
         @Semantics.amount.currencyCode: 'InvoiceValueLcC'
         total_rodtep_v_lc,
         @Semantics.systemDateTime.localInstanceLastChangedAt: true
         LocalLastChangedAt,

         @EndUserText.quickInfo: 'Duty Drawback Value(FC)'
         @EndUserText.label: 'Duty Drawback Value(FC)'
         @Semantics.amount.currencyCode: 'InvoiceValueFcC'

         total_duty_drawback_v_fc,
         @EndUserText.quickInfo: 'RoDTEP Value(FC)'
         @EndUserText.label: 'RoDTEP Value(FC)'
         @Semantics.amount.currencyCode: 'InvoiceValueFcC'
         total_rodtep_v_fc,


         _ShippingBill : redirected to parent ZC_ShippingBillTP
}
