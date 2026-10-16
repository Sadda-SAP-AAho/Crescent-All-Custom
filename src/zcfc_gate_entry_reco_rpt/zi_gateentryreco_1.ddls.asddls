@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry Reco Report-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_GATEENTRYRECO_1
  as select distinct from zdt_ghead                    as a
    inner join            zdt_gitem                    as b on  b.id       = a.id
                                                            and b.gatepass = a.gatepass
                                                            and a.cancel   is initial
    inner join            I_Supplier                   as c on c.Supplier = b.vendor
    inner join            I_Plant                      as d on d.Plant = a.plantgateno
    inner join            I_BusinessUserBasic          as e on e.UserID = a.ernam
    inner join            I_PurchaseOrderAPI01         as f on f.PurchaseOrder = b.ebeln
    inner join            I_PurchasingDocumentTypeText as g on  g.PurchasingDocumentType = f.PurchaseOrderType
                                                            and g.Language               = 'E'
    left outer join       ZI_GRNDETAILS                as h on  h.PurchaseOrder     = b.ebeln
                                                            and h.PurchaseOrderItem = b.ebelp
                                                            and h.GateEntryNo       = ltrim( a.gatepass, '0' )


{
  key (case when h.MaterialDocument is not initial 
            then 'GRN Done'
            else 'GRN Not Done' end )    as Type,
  key a.id                               as Id,
  key b.item                             as Item,
  key h.MaterialDocument,
      f.PurchaseOrderType                as POType,
      g.PurchasingDocumentTypeName       as POTypeName,
      b.ebeln                            as PONo,
      cast( b.ebelp as abap.char( 5 ) )  as POLine,
      b.vendor                           as VenodrCode,
      c.SupplierName                     as VenodrName,
      b.matnr                            as MatlCode,
      cast( b.maktx as abap.char(40) )   as MatlName,
//      cast( b.potext as abap.char(200) ) as POText,
      b.gatepass                         as GateEntryNo,
      a.gatepassdate                     as GateEntryDt,
      a.challannumber                    as ChallanNo,
      a.challandate                      as ChallanDt,
      a.plantgateno                      as PlantCode,
      d.PlantName                        as PlantName,
      a.shipmenttype                     as ShipmentTyp,
      a.vehno                            as VehicleNo,
      e.PersonFullName                   as CreatedBy,
      a.erdat                            as CreatedOn,
      a.transportercode                  as TranspoterCode,
      a.transportername                  as TransporterName,
      a.fromplace                        as FromPlace,
      a.toplace                          as ToPlace,
      b.meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.orderqty                         as OrderQty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.challanqty                       as ChallanQty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.plantqty                         as PlantQty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.deliverqty                       as DelQty,
      b.wtunit,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      b.netwt                            as NetWt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      b.tarwt                            as TareWt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      b.grswt                            as GrossWt,
      h.MaterialDocument                 as MatlDocNo,
      h.PostingDate                      as PostingDate,
      h.DocumentDate                     as DocumentDate,
      h.BaseUnit                         as BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      h.QuantityInBaseUnit               as Qty,
      h.StorageLocation                  as StorageLocation

}

where
      f.PurchaseOrderType <> 'ZSTO'
  and f.PurchaseOrderType <> 'ZSRV'
  and b.ebeln             is not initial
