@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Application'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_SALESAPP

  as select from zdt_salesapp

{
  key id,
      orderid,
      material,
      plant,
      productname,
      materialbaseunit,
      @Semantics.quantity.unitOfMeasure: 'materialbaseunit'
      stock,
      vat,
      unitprice,
      creationdate
}
