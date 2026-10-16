@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PGI Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PGI_DATA
  as select distinct from I_DeliveryDocumentItem as a
    inner join            ZI_MATL_DOC_DATA       as b on  b.DeliveryDocument     = a.DeliveryDocument
                                                      and b.DeliveryDocumentItem = a.DeliveryDocumentItem
    inner join            I_SalesOrderItem       as c on  a.ReferenceSDDocument     = c.SalesOrder
                                                      and a.ReferenceSDDocumentItem = c.SalesOrderItem


{
  key a.ReferenceSDDocument     as SalesOrder,
  key a.ReferenceSDDocumentItem as SalesOrderItem,
  key b.MaterialDocument        as PGINo,
  key b.PostingDate             as PGIDate,
  key b.Material,
      b.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      b.QuantityInBaseUnit      as TotalPGIQty
}
