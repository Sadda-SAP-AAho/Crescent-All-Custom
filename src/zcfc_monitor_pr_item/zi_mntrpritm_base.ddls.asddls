@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Monitor Purchase Requisition Item(Base)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MNTRPRITM_BASE
  as select distinct from I_PurchaseRequisitionItemAPI01 as a
    left outer join       I_Plant                        as b on a.Plant = b.Plant
    left outer join       I_Supplier                     as c on a.Supplier = c.Supplier
    left outer join       I_AcctAssignmentCategoryText   as d on  a.AccountAssignmentCategory = d.AccountAssignmentCategory
                                                              and d.Language                  = 'E'
    left outer join       I_ProductGroupText_2           as e on a.MaterialGroup = e.ProductGroup
    left outer join       I_BusinessUserBasic            as f on f.UserID = a.CreatedByUser


{

  key concat( concat( a.PurchaseRequisition , ' / '), a.PurchaseRequisitionItem )                                                                            as PurchaseRequisitionItem,
      a.PurchaseRequisition,
      a.PurchaseReqnCreationDate,
      f.PersonFullName                                                                                                                                       as CreatedByUser,
      a.RequisitionerName,
      a.Material,
      a.PurchaseRequisitionItemText,
      a.Plant,
      b.PlantName,
      a.StorageLocation,
      a.Supplier,
      c.SupplierName,
      a.BaseUnit,
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      a.RequestedQuantity,
      a.PurReqnItemCurrency,
      @Semantics.amount.currencyCode: 'PurReqnItemCurrency'
      a.PurchaseRequisitionPrice,
      @Semantics.amount.currencyCode: 'PurReqnItemCurrency'
      a.ItemNetAmount,
      a.DeliveryDate,
      substring( cast( a.LastChangeDateTime as abap.char(50) ), 1, 8 )                                                                                       as LastChangedDate,
      a.AccountAssignmentCategory,
      d.AcctAssignmentCategoryName,
      ( case when a.ProcessingStatus = 'B' then 'Yes'
           when a.ProcessingStatus = 'N' then 'No' end )                                                                                                     as Assigned,
      a.MaterialGroup,
      e.ProductGroupName,
      a.MRPController,
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      a.OrderedQuantity,
      ( case when a.MRPController = 'ZBP' then 'BOM Based Planner'
             when a.MRPController = 'ZRP' then 'Reorder Pt Planner' end )                                                                                    as MRPControllerDesc,
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      ( a.RequestedQuantity - a.OrderedQuantity )                                                                                                            as OpenQty,
      a.BaseUnit                                                                                                                                             as QtyUom,
      cast( cast( a.PurchaseRequisitionPrice as abap.dec(15,3) ) * cast( ( a.RequestedQuantity - a.OrderedQuantity)  as abap.dec(15,3) ) as abap.dec(15,3) ) as OpenValue

}

where
  a.IsDeleted is initial
