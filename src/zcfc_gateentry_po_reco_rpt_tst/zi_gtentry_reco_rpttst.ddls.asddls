@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Regiester Short Form Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root view entity ZI_GTENTRY_RECO_RPTTST
  as select from    ZI_GITEM                 as a
    inner join      zi_ghead                 as b on  a.Id       = b.Id
                                                  and a.plant    = b.Plant
                                                  and a.Gatepass = b.Gatepass
    left outer join I_MaterialDocumentItem_2 as c on  a.Matnr = c.Material
                                                  and a.plant = c.Plant
    left outer join I_BusinessUserBasic      as d on b.Ernam = d.CreatedByUser
{

  key    b.Id,
  key    c.PurchaseOrder,
  key    c.PurchaseOrderItem,
         a.Matnr,
         a.Maktx,
         b. Plant,
         a. Vendor,
         a. Potext,
         a.Gatepass,
         b.Gateentrydate,
         b.Challannumber,
         b. Challandate,
         b.Shipmenttype,
         b. Vehno,
         d.PersonFullName,
         d.CreationDate,
         b.Vesselname,
         b. Fromplace,
         b.Meins,
         b. Toplace,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         a.Orderqty,
         a. Challanqty,
         a. Plantqty,
         @Semantics.quantity.unitOfMeasure: 'Meins'
         a. Deliverqty,
         @Semantics.quantity.unitOfMeasure : 'Wtunit'
         a.netwt,
         @Semantics.quantity.unitOfMeasure : 'Wtunit'
         a.tarwt,
         @Semantics.quantity.unitOfMeasure : 'Wtunit'
         a. grswt,
         a. Wtunit,
         c. MaterialDocument,
         c. PostingDate,
         c. DocumentDate,
         c.MaterialBaseUnit,
         @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
         c.QuantityInBaseUnit,
         c.GoodsMovementType,
         c.StorageLocation

}
where
  c.GoodsMovementType = '101'
