@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Application'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_SALESAPP

  provider contract transactional_query

  as projection on ZR_SALESAPP

{
      @EndUserText.label: 'ID'
  key id,
      @EndUserText.label: 'Order ID'
      orderid,
      @EndUserText.label: 'Material'
      material,
      @EndUserText.label: 'Plant'
      plant,
      @EndUserText.label: 'Product Name'
      productname,
      @EndUserText.label: 'Material UoM'
      materialbaseunit,
      @EndUserText.label: 'Stock'
      @Semantics.quantity.unitOfMeasure: 'materialbaseunit'
      stock,
      @EndUserText.label: 'VAT %'
      vat,
      @EndUserText.label: 'Unit Price'
      unitprice,
      @EndUserText.label: 'Created On'
      creationdate
}
