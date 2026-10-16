@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order-wise Component Requirement Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_SOBOMCOMPRPT
  as select distinct from ZI_SOBOMCOMPRPT_1              as a
    left outer join       I_PurchaseRequisitionItemAPI01 as b on  a.SO_No         = b.RequisitionerName
                                                              and a.SO_Row_Number = b.RequirementTracking
    left outer join       ZTF_SOCOMPTBOM                 as c on c.purchaserequisition = b.PurchaseRequisition
    left outer join       ZI_PO_QTY                      as d on  a.Component_Material_Code = d.Material
                                                              and a.Plant                   = d.Plant
    left outer join       ZI_PR_QTY                      as e on  a.Component_Material_Code = e.Material
                                                              and a.Plant                   = e.Plant


{
  key a.SO_No,
  key a.SO_Row_Number,
  key a.Component_Material_Code                                                      as MaterialCode,
      a.SO_Dt,
      a.Del_Dt,
      a.Customer_Code,
      a.Plant,
      a.Material_No,
      a.Material_Name,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      a.SO_Open_Qty,
      a.OrderQuantityunit,
      a.Profit_Center_Name,
      a.Our_Committed_Del_Date,
      a.Component_Material_Code,
      a.Component_Material_Name,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      a.Component_Qty,
      a.Component_Material_Group_Name,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      a.Component_Stock,
      b.PurchaseRequisition                                                          as PR_No,
      c.pr_creationdate                                                              as PR_Date,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      e.PRQty                                                                        as PR_Qty,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      e.OpenPRQty                                                                    as Open_PR_Qty,
      cast( d.QtytobeDel as abap.dec(13,3) ) as Open_PO_Qty


}
