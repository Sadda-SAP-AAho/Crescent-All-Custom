@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumption ~ Item'

define view entity ZC_SERVICE_INV_ITEM
  as projection on ZI_SERVICE_INV_ITEM
{
         @Search.defaultSearchElement: true
         @EndUserText.label: 'Invoice No'
  key    InvoiceNo,
         @EndUserText.label: 'Item'
  key    Item,
         @EndUserText.label: 'Fiscal Year'
  key    FiscalYear,
         @EndUserText.label: 'Description'
         Description,
         @EndUserText.label: 'HSN Code'
         HSNCode,
         @EndUserText.label: 'UOM'
         UOM,
         @EndUserText.label: 'Amount'
         Amount,
         @EndUserText.label: 'IGST'
         IGSTAmount,
         @EndUserText.label: 'Total Amt'
         Total,
         /* Associations */
         _Head : redirected to parent ZC_SERVICE_INV_HEAD
}
