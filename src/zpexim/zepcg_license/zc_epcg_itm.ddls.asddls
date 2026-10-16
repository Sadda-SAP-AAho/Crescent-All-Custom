@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'EPCG Item'
define view entity ZC_EPCG_ITM
  as projection on ZI_EPCG_ITM
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Ecom Number'
      Ecomno,
      @EndUserText.label: 'Company Code Currency'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Waers,
      @EndUserText.label: 'CurrencyFc'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Waersfc,
      @EndUserText.label: 'CurrencyFr'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Waersfr,
      @EndUserText.label: 'CurrencyInc'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Waersinc,
      @EndUserText.label: 'Item'
      Itemno,
      @EndUserText.label: 'HSN code'
      Hsn,
      @EndUserText.label: 'Material Description'
      Matdesc,
      @EndUserText.label: 'Meins'
      Meins,
      @EndUserText.label: 'Quantity'
      Qty,
      @EndUserText.label: 'UOM'
      Uom,
      @EndUserText.label: 'Duty Save Value(FC)'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Dutysavevalfc,
      @EndUserText.label: 'Duty Save Value(INR)'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Dutysavevalinr,
      @EndUserText.label: 'Exchange Rate To INR'
      Excrateinr,
      @EndUserText.label: 'CIF Value In FC'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Cifvalfc,
      @EndUserText.label: 'Freight Charges'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Freightcharge,
      @EndUserText.label: 'Insurance Charges'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Inschange,
      @EndUserText.label: 'CIF Value In INR'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Cifvalinr,
      @EndUserText.label: 'Exchange Rate To USD'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Excrateusd,
      @EndUserText.label: 'CIF Value In USD'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Cifvalusd,
      @EndUserText.label: 'Assessabel Value'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Accessval,
      @EndUserText.label: 'Duty Save %'
      Dutysavper,
      @EndUserText.label: 'SWCESS %'
      Swcessperc,
      @EndUserText.label: 'IGST %'
      Igstperc,
      @EndUserText.label: 'Gross Price(FC)'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Grosspricefc,
      @EndUserText.label: 'Payable % Through EPCG'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Payperc,
      @EndUserText.label: 'Remain Duty Saver(INR)'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Remdutysaveinr,
      @EndUserText.label: 'Remarks'
      Remarks,
      /* Associations */
      _head : redirected to parent ZC_EPCG_HDR

}
