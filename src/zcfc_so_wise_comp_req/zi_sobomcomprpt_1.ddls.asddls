@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order-wise Component Requirement Report-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_SOBOMCOMPRPT_1
  as select distinct from ZI_SO_COMPREQ  as a
    left outer join       ZTF_SOCOMPTBOM as b on  a.SalesOrderNo = b.SalesOrderNo
                                              and a.SORowNumber  = b.SORowNumber

{
  key    a.SalesOrderNo                  as SO_No,
  key    a.SORowNumber                   as SO_Row_Number,
         a.SODate                        as SO_Dt,
         a.RequestedDelDate              as Del_Dt,
         a.CustomerCode                  as Customer_Code,
         a.plant                         as Plant,
         a.MaterialNo                    as Material_No,
         a.MaterialName                  as Material_Name,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         a.SOOpenQty                     as SO_Open_Qty,
         a.OrderQuantityUnit             as OrderQuantityunit,
         a.ProfitCenterName              as Profit_Center_Name,
         a.OurCommittedDelDate           as Our_Committed_Del_Date,
         b.ComponentMaterial             as Component_Material_Code,
         b.componentmaterialname         as Component_Material_Name,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         sum( b.ComponentQty )           as Component_Qty,
         b.Component_Material_Group_Name as Component_Material_Group_Name,
         @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
         b.Component_Stock               as Component_Stock

}

group by
  a.SalesOrderNo,
  a.SORowNumber,
  a.SODate,
  a.RequestedDelDate,
  a.CustomerCode,
  a.plant,
  a.MaterialNo,
  a.MaterialName,
  a.SOOpenQty,
  a.OrderQuantityUnit,
  a.ProfitCenterName,
  a.OurCommittedDelDate,
  b.ComponentMaterial,
  b.componentmaterialname,
  b.Component_Material_Group_Name,
  b.Component_Stock
