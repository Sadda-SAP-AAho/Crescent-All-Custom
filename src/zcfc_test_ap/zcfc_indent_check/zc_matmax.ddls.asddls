@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Indent Data'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MATMAX
  provider contract transactional_query
  as projection on ZI_MATMAX
{
      @EndUserText.label: 'Product'
      @Search.defaultSearchElement: true
  key Product,
      @EndUserText.label: 'Plant Code'
      @Search.defaultSearchElement: true
  key PlantCode,
      @EndUserText.label: 'Product Group'
      @Search.defaultSearchElement: true
  key ProductGroup,
      @EndUserText.label: 'Product Type'
  key ProductType,
      @EndUserText.label: 'Storage Location'
  key StorageLocation,
      @EndUserText.label: 'Material Base Unit'
      MaterialBaseUnit,
      @EndUserText.label: 'Max Stock'
      MaxStock,
      @EndUserText.label: 'Current Stock'
      CurrentStock,
      @EndUserText.label: 'PR Quantity'
      pr_qty,
      @EndUserText.label: 'PO Quantity'
      po_qty
}
