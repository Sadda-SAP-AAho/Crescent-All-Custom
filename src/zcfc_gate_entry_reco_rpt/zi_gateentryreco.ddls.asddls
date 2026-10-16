@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry Reco Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_GATEENTRYRECO
  as select distinct from ZI_GATEENTRYRECO_1 as a
    left outer join       ZTBL_PO_ITEM_TEXT  as b on  a.PONo           = b.PurchaseOrder
                                                  and a.POLine         = b.PurchaseOrderItem
                                                  and b.Language       = 'E'
                                                  and b.TextObjectType = 'F01'



{
  key a.Type,
  key a.Id,
  key a.Item,
  key a.MaterialDocument,
      a.POType,
      a.POTypeName,
      a.PONo,
      a.POLine,
      a.VenodrCode,
      a.VenodrName,
      a.MatlCode,
      a.MatlName,
      b.PlainLongText as POText,
      a.GateEntryNo,
      a.GateEntryDt,
      a.ChallanNo,
      a.ChallanDt,
      a.PlantCode,
      a.PlantName,
      a.ShipmentTyp,
      a.VehicleNo,
      a.CreatedBy,
      a.CreatedOn,
      a.TranspoterCode,
      a.TransporterName,
      a.FromPlace,
      a.ToPlace,
      a.meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.OrderQty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.ChallanQty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.PlantQty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.DelQty,
      a.wtunit,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.NetWt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.TareWt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.GrossWt,
      a.MatlDocNo,
      a.PostingDate,
      a.DocumentDate,
      a.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      a.Qty,
      a.StorageLocation

}
