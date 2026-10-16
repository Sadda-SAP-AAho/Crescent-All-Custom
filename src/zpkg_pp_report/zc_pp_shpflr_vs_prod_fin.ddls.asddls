@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shop Floor vs Actual Production Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_PP_SHPFLR_VS_PROD_FIN 
as select from ZCDS_PP_SHPFLR_VS_PROD_FIN 
{ 
    @UI.hidden: true
    key id,
    @UI.hidden: true
    key item,
    @EndUserText.label: 'Department/CC'
    dept,
    @EndUserText.label: 'Dept. Desc/CC Desc.'
    deptname,
    @EndUserText.label: 'Operation'
    opr,
    @EndUserText.label: 'Operation Name'
    oprname,
    @EndUserText.label: 'Plant Code'
    plant,
    @EndUserText.label: 'Plant Name'
    PlantName,
    @EndUserText.label: 'Item No.'
    matnr,
    @EndUserText.label: 'Item Description'
    maktx,
    @UI.hidden: true
    meins,
    @EndUserText.label: 'Qty per Box'
    qtyperbox,
    @EndUserText.label: 'Quantity'
    @Semantics.quantity.unitOfMeasure: 'Meins'
    goodcast,
    @EndUserText.label: 'Simulated Qty (Only Good Cast)'
    simqty,
    @EndUserText.label: 'SF Report DocEntry No'
    shpflrno,
    @EndUserText.label: 'Rej Qty'
    @Semantics.quantity.unitOfMeasure: 'Meins'
    rejqty,
    @EndUserText.label: 'Simulated Qty (Only Reject Cast)'
    simrejqty,
    @EndUserText.label: 'SF Report Date'
    shpflrdt,
    cast( shpflrdt as abap.char(10) ) as shpflrdt1,
    @EndUserText.label: 'Contractor Name'
    contname,
    @EndUserText.label: 'Recept Qty'
    @Semantics.quantity.unitOfMeasure: 'Meins'
    recqty,
    @EndUserText.label: 'Recpt Rej Qty'
    @Semantics.quantity.unitOfMeasure: 'Meins'
    rejrecqty,
    @EndUserText.label: 'Qty Difference'
    @Semantics.quantity.unitOfMeasure: 'Meins'
    castdif,
    @EndUserText.label: 'Rej Qty Difference'
    @Semantics.quantity.unitOfMeasure: 'Meins'
    rejdif,
    @EndUserText.label: 'Qty Difference with Simulated Qty'
    @Semantics.quantity.unitOfMeasure: 'Meins'
    simdif,
    @EndUserText.label: 'Rej Qty Difference with Simulated Qty'
    @Semantics.quantity.unitOfMeasure: 'Meins'
    simrejdif,
    @EndUserText.label: 'Unit Weight'
    @Semantics.quantity.unitOfMeasure: 'wtunit'
    netwt,
    @EndUserText.label: 'Gross Weight'
    @Semantics.quantity.unitOfMeasure: 'wtunit'
    grossWt,
    @EndUserText.label: 'Pending Weight'
    @Semantics.quantity.unitOfMeasure: 'wtunit'
    pendwt,
    @EndUserText.label: 'Weight'
    @Semantics.quantity.unitOfMeasure: 'wtunit'
    weight,
    @UI.hidden: true
    wtunit,
    @EndUserText.label: 'Open Production Order Qty'
    @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
    Open_Prod_Qty,
    @UI.hidden: true
    ProductionUnit
    
}
