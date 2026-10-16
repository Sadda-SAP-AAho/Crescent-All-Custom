@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shop Floor vs Actual production Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_SHPFLR_VS_PROD_FIN
  as select from ZCDS_PP_SHPFLR_VS_PROD as a
  left outer join ZCDS_TOTAL_PROD_QTY as b on a.matnr = b.Material
{
  key a.id,
  key a.item,
      a.dept,
      a.deptname,
      a.opr,
      a.oprname,
      a.plant,
      a.PlantName,
      a.matnr,
      a.maktx,
      a.meins,
      a.qtyperbox,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.goodcast,
      a.simqty,
      a.shpflrno,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.rejqty,
      a.simrejqty,
      a.shpflrdt,
      a.contname,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.recqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.rejrecqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.castdif,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.rejdif,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.simdif,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      a.simrejdif,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.netwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.grossWt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      cast( ( a.netwt * ( a.castdif + a.rejdif ) ) as abap.quan( 23, 2 ) )  as pendwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      cast( ( a.netwt * ( a.goodcast + a.rejqty ) ) as abap.quan( 23, 2 ) ) as weight,
      a.wtunit,
      b.ProductionUnit,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      cast( ( b.Total_Ord_Qty - b.Total_Del_Qty ) as abap.quan( 23, 2 ) ) as Open_Prod_Qty
}
