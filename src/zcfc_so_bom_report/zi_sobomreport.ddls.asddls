@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO wise BOM Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_SOBOMREPORT
  with parameters
    P_SO : abap.numc(10)

  as select distinct from ZC_SO_CompReq_Param( P_SO: $parameters.P_SO ) as so
    left outer join       ZTF_SOCompBOM( p_so: $parameters.P_SO )       as bom on  so.SalesOrderNo = bom.SalesOrderNo
                                                                               and so.SORowNumber  = bom.SORowNumber
{
  key    so.SalesOrderNo                   as SO_No,
  key    so.SORowNumber                    as SO_Row_Number,
         so.SODate                         as SO_Dt,
         so.RequestedDelDate               as Del_Dt,
         so.CustomerCode                   as Customer_Code,
         so.plant                          as Plant,
         so.MaterialNo                     as Material_No,
         so.MaterialName                   as Material_Name,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         so.SOOpenQty                      as SO_Open_Qty,
         so.OrderQuantityUnit              as OrderQuantityunit,
         so.ProfitCenterName               as Profit_Center_Name,
         so.OurCommittedDelDate            as Our_Committed_Del_Date,
         bom.ComponentMaterial             as Component_Material_Code,
         bom.componentmaterialname         as Component_Material_Name,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.ComponentQty                  as Component_Qty,
         bom.Component_Material_Group_Name as Component_Material_Group_Name,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.Component_Stock               as Component_Stock,
         bom.purchaserequisition           as PR_No,
         bom.pr_creationdate               as PR_Date,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.pr_qty                        as PR_Qty,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.open_po_qty                   as Open_PO_Qty,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.open_pr_qty                   as Open_PR_Qty,
         bom.Pallet_PCD_Box_Size           as Pallet_PCD_Box_Size,
         bom.BOLT_SIZE                     as BOLT_SIZE,
         bom.Qty_of_Pallet_PCD_Box         as Qty_of_Pallet_PCD_Box,
         bom.Std_No_of_Pcs_Pack            as Std_No_of_Pcs_Pack,
         bom.Qty_of_Bolt                   as Qty_of_Bolt,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.Bolt_Reqd                     as BOLT_REQD,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         bom.Pallet_Reqd                   as PALLET_REQD,
         bom.shop_floor_no                 as SHOP_FLOOR_NO
}
