@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO BOM Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.entitySet.name: 'BOMReport'
define view entity ZSO_BOM_REPORT
    with parameters
      P_SO : vbeln
  as select from    ZC_SO_CompReq_Param(P_SO: $parameters.P_SO) as so
    left outer join ZTF_SOCompBOM(p_so: $parameters.P_SO)       as bom on  so.SalesOrderNo = bom.SalesOrderNo
                                               and so.SORowNumber  = bom.SORowNumber
  //    left outer join ZCDS_Material_details(P_SO: $parameters.P_SO) as mat on bom.ComponentMaterial = mat.Comp_mat
{
         @UI.lineItem: [{ position: 10 }]
         @EndUserText.label: 'SO_No'
  key    so.SalesOrderNo                   as SO_No,
         @UI.lineItem: [{ position: 60 }]
         @EndUserText.label: 'SO_Row_Number'
  key    so.SORowNumber                    as SO_Row_Number,
         @UI.lineItem: [{ position: 20 }]
         @EndUserText.label: 'SO_Dt'
         so.SODate                         as SO_Dt,
         @UI.lineItem: [{ position: 30 }]
         @EndUserText.label: 'Del_Dt'
         so.RequestedDelDate               as Del_Dt,
         @UI.lineItem: [{ position: 40 }]
         @EndUserText.label: 'Customer_Code'
         so.CustomerCode                   as Customer_Code,
         @UI.lineItem: [{ position: 50 }]
         @EndUserText.label: 'Plant'
         so.plant                          as Plant,
         @UI.lineItem: [{ position: 70 }]
         @EndUserText.label: 'Material_No'
         so.MaterialNo                     as Material_No,
         @UI.lineItem: [{ position: 80 }]
         @EndUserText.label: 'Material_Name'
         so.MaterialName                   as Material_Name,
         @UI.lineItem: [{ position: 90 }]
         @EndUserText.label: 'SO_Open_Qty'
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         so.SOOpenQty                      as SO_Open_Qty,
         @UI.lineItem: [{ position: 100 }]
         @EndUserText.label: 'Order_Quantity_Unit'
         so.OrderQuantityUnit              as OrderQuantityunit,
         @UI.lineItem: [{ position: 110 }]
         @EndUserText.label: 'Profit_Center_Name'
         so.ProfitCenterName               as Profit_Center_Name,
         @UI.lineItem: [{ position: 120 }]
         @EndUserText.label: 'Our_Committed_Del_Date'
         so.OurCommittedDelDate            as Our_Committed_Del_Date,
         @UI.lineItem: [{ position: 130 }]
         @EndUserText.label: 'Component_Material_Code'
         bom.ComponentMaterial             as Component_Material_Code,
         @UI.lineItem: [{ position: 140 }]
         @EndUserText.label: 'Component_Material_name'
         bom.componentmaterialname         as Component_Material_Name,
         @UI.lineItem: [{ position: 150 }]
         @EndUserText.label: 'Component_Qty'
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.ComponentQty                  as Component_Qty,
         @UI.lineItem: [{ position: 160 }]
         @EndUserText.label: 'Component_Material_Group_Name'
         bom.Component_Material_Group_Name as Component_Material_Group_Name,
         @UI.lineItem: [{ position: 170 }]
         @EndUserText.label: 'Component_Stock'
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.Component_Stock               as Component_Stock,
         @UI.lineItem: [{ position: 180 }]
         @EndUserText.label: 'PR_No'
         bom.purchaserequisition           as PR_No,
         @UI.lineItem: [{ position: 190 }]
         @EndUserText.label: 'PR_Date'
         bom.pr_creationdate               as PR_Date,
         @UI.lineItem: [{ position: 200 }]
         @EndUserText.label: 'PR_Qty'
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.pr_qty                        as PR_Qty,
         @UI.lineItem: [{ position: 210 }]
         @EndUserText.label: 'Open_PO_Qty'
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.open_po_qty                   as Open_PO_Qty,
         @UI.lineItem: [{ position: 220 }]
         @EndUserText.label: 'Open_PR_Qty'
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.open_pr_qty                   as Open_PR_Qty,
         @UI.lineItem: [{ position: 230 }]
         @EndUserText.label: 'Pallet_PCD_Box_Size'
         bom.Pallet_PCD_Box_Size           as Pallet_PCD_Box_Size,
         @UI.lineItem: [{ position: 240 }]
         @EndUserText.label: 'BOLT_SIZE'
         bom.BOLT_SIZE                     as BOLT_SIZE,
         @UI.lineItem: [{ position: 250 }]
         @EndUserText.label: 'Qty_of_Pallet_PCD_Box'
         bom.Qty_of_Pallet_PCD_Box         as Qty_of_Pallet_PCD_Box,
         @UI.lineItem: [{ position: 260 }]
         @EndUserText.label: 'Std_No_of_Pcs_Pack'
         bom.Std_No_of_Pcs_Pack            as Std_No_of_Pcs_Pack,
         @UI.lineItem: [{ position: 270 }]
         @EndUserText.label: 'Qty_of_Bolt'
         bom.Qty_of_Bolt                   as Qty_of_Bolt,
         @UI.lineItem: [{ position: 280 }]
         @EndUserText.label: 'BOLT_REQD'
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.Bolt_Reqd                     as BOLT_REQD,
         @UI.lineItem: [{ position: 290 }]
         @EndUserText.label: 'PALLET_REQD'
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.Pallet_Reqd                   as PALLET_REQD,
         @UI.lineItem: [{ position: 300 }]
         @EndUserText.label: 'SHOP_FLOOR_NO'
         bom.shop_floor_no                 as SHOP_FLOOR_NO



}
