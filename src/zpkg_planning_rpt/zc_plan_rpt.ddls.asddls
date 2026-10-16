@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Planning Report'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_PLAN_RPT
  as select from ZI_PLAN_RPT
{
      @EndUserText.label: 'Plant'
      @Consumption.filter.mandatory: true
  key plant,
      //      @EndUserText.label: 'FG Material'
      //  key hedmaterial,
      @EndUserText.label: 'CastingItem'
  key component,
      @EndUserText.label: 'Casting Group'
      ProductGroup,
      @EndUserText.label: 'CastingName'
      ProductDescription,
      @EndUserText.label: 'Unit'
      WeightUnit,
      @EndUserText.label: 'Unit Wt-Kg'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      NetWeight,
      @EndUserText.label: 'Profit Center'
      @UI.hidden: true
      ProfitCenter,
      @EndUserText.label: 'Profit Center'
      ProfitCenterLongName,
      @EndUserText.label: 'CustCode'
      cuscode,
      @EndUserText.label: 'Sub Resource Code'
      subcode,
      @EndUserText.label: 'Qty per Box'
      qtyperbox,
      @EndUserText.label: 'Prodn capacity/Day'
      prodcapcday,
      @EndUserText.label: 'Box Size'
      boxsize,
      @EndUserText.label: 'Module Type'
      typemould,
      @EndUserText.label: 'OpenBulkOrderQty'
      OpenContQty,
      @EndUserText.label: 'OpenBulkOrderWt'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      OpenContQtyWt,
      @EndUserText.label: 'Open-SO-Qty'
      OpenSoQty,
      @EndUserText.label: 'Open-SO-Wt'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      OpenSoQtyWt,
      @EndUserText.label: 'FG-Live-Qty'
      FgLiveQty,
      @EndUserText.label: 'FG-Live-Wt'
      FgLivewt,
      @EndUserText.label: 'FGwise-Casting On Hand-Qty'
      castonhand,
      @EndUserText.label: 'FG-On Hand-Wt'
      castonhandWt,
      @EndUserText.label: 'FG-Dead-Qty'
      FgdeadQty,
      @EndUserText.label: 'FG-Dead-Wt'
      FgdeadWt,
      @EndUserText.label: 'FGwise-Special Paint On Hand-Qty'
      stockZ028,
      @EndUserText.label: 'FGwise-Machining On Hand-Qty'
      stockZ026,
      @EndUserText.label: 'FGwise-Grinding On Hand-Qty'
      stockZ027,
      @EndUserText.label: 'CS Stock - Realtime casting stock'
      stockZ025,
      @EndUserText.label: 'FGwise-Secondary Inspection On Hand-Qty'
      stockZ045,
      @EndUserText.label: 'FGwise-Molding On Hand-Qty'
      stockZ024,
      @EndUserText.label: 'SFG-On Hand-Qty'
      SfgOnHand,
      @EndUserText.label: 'SFG-On Hand-Wt'
      SfgOnHandWt,
      @EndUserText.label: 'SFG-Live-Qty'
      SfgLiveQty,
      @EndUserText.label: 'SFG-Live-Wt'
      SfgLiveWt,
      @EndUserText.label: 'SFG-Dead-Qty'
      SfgdeadQty,
      @EndUserText.label: 'SFG-Dead-Wt'
      SfgdeadWt,
      @EndUserText.label: 'Total Stock-Qty'
      Totalstockqty,
      @EndUserText.label: 'Total Stock-Wt'
      TotalstockWt,
      @EndUserText.label: 'Open SO Qty- 7 Days'
      OpenSoQty7,
      @EndUserText.label: 'Open SO Wt- 7 Days'
      OpenSoQty7Wt,
      @EndUserText.label: 'Open SO Qty- 8 to 15 Days'
      OpenSoQty8,
      @EndUserText.label: 'Open SO Wt- 8 to 15 Days'
      OpenSoQty8Wt,
      @EndUserText.label: 'Open SO Qty- 16 to 23 Days'
      OpenSoQty16,
      @EndUserText.label: 'Open SO Wt- 16 to 23 Days'
      OpenSoQty16Wt,
      @EndUserText.label: 'Open SO Qty- 24 to 30 Days'
      OpenSoQty23,
      @EndUserText.label: 'Open SO Wt- 24 to 30 Days'
      OpenSoQty23Wt,
      @EndUserText.label: 'Open SO Qty- 31 to 38 Days'
      OpenSoQty31,
      @EndUserText.label: 'Open SO Wt- 31 to 38 Days'
      OpenSoQty31Wt,
      @EndUserText.label: 'Open SO Qty- 39 to 46 Days'
      OpenSoQty39,
      @EndUserText.label: 'Open SO Wt- 39 to 46 Days'
      OpenSoQty39Wt,
      @EndUserText.label: 'Open SO Qty- 47 to 54 Days'
      OpenSoQty47,
      @EndUserText.label: 'Open SO Wt- 47 to 54 Days'
      OpenSoQty47Wt,
      @EndUserText.label: 'Open SO Qty- 55 to 62 Days'
      OpenSoQty55,
      @EndUserText.label: 'Open SO Wt- 55 to 62 Days'
      OpenSoQty55Wt,
      @EndUserText.label: 'Open SO Qty- 63 to 70 Days'
      OpenSoQty63,
      @EndUserText.label: 'Open SO Wt- 63 to 70 Days'
      OpenSoQty63Wt,
      @EndUserText.label: 'Open SO Qty- 71 to 365 Days'
      OpenSoQty71,
      @EndUserText.label: 'Open SO Wt- 71 to 365 Days'
      OpenSoQty71Wt,
      @EndUserText.label: 'Open SO Qty> 365 Days + Hold Qty'
      OpenSoQty366,
      @EndUserText.label: 'Open SO Wt> 365 Days + Hold Qty'
      OpenSoQty366Wt,
      @EndUserText.label: 'Open SO Qty 7 Days(Small-Weight)'
      OpenSoQtySwt7,
      @EndUserText.label: 'Open SO Qty 7 Days(Small-No of Line)'
      opensoqtysnl7,
      @EndUserText.label: 'Open SO Qty 7 Days(Single-Reqd Days )'
      OpenSoQtySrd7,
      @EndUserText.label: 'Open SOQty 8to15 Days(Small-Weight)'
      OpenSoQtySwt8,
      @EndUserText.label: 'Open SOQty 8to15 Days(Small-No of Line)'
      opensoqtysnl8,
      @EndUserText.label: 'Open SOQty 8to15 Days(Small-Reqd Days)'
      OpenSoQtySrd8,
      @EndUserText.label: 'Open SO Qty 16to23 Days(Small-Weight)'
      OpenSoQtySwt16,
      @EndUserText.label: 'Open SO Qty 16to23 Days(Small-Weight)'
      opensoqtysnl16,
      @EndUserText.label: 'Open SO Qty 16to23 Days(Small-Reqd Days)'
      OpenSoQtySrd16,
      @EndUserText.label: 'Open SOQty 24to30 Days(Small-Weight)'
      OpenSoQtySwt23,
      @EndUserText.label: 'Open SOQty 24to30 Days(Small-No of Line)'
      opensoqtysnl23,
      @EndUserText.label: 'Open SOQty 24to30 Days(Small-Reqd Days)'
      OpenSoQtySrd23,
      @EndUserText.label: 'Open SOQty 31to38 Days(Small-Weight)'
      OpenSoQtySwt31,
      @EndUserText.label: 'Open SOQty 31to38 Days(Small-No of Line)'
      opensoqtysnl31,
      @EndUserText.label: 'Open SOQty 31to38 Days(Small-Reqd Days)'
      OpenSoQtySrd31,
      @EndUserText.label: 'Open SOQty 39to46 Days(Small-Weight)'
      OpenSoQtySwt39,
      @EndUserText.label: 'Open SOQty 39to46 Days(Small-No of Line)'
      opensoqtysnl39,
      @EndUserText.label: 'Open SOQty 39to46 Days(Small-Reqd Days)'
      OpenSoQtySrd39,
      @EndUserText.label: 'Open SOQty 47to54 Days(Small-Weight)'
      OpenSoQtySwt47,
      @EndUserText.label: 'Open SOQty 47to54 Days(Small-No of Line)'
      opensoqtysnl47,
      @EndUserText.label: 'Open SOQty 47to54 Days(Small-Reqd Days)'
      OpenSoQtySrd47,
      @EndUserText.label: 'Open SOQty 55to62 Days(Small-Weight)'
      OpenSoQtySwt55,
      @EndUserText.label: 'Open SOQty 55to62 Days(Small-No of Line)'
      opensoqtysnl55,
      @EndUserText.label: 'Open SOQty 55to62 Days(Small-Reqd Days)'
      OpenSoQtySrd55,
      @EndUserText.label: 'Open SOQty 63to70 Days(Small-Weight)'
      OpenSoQtySwt63,
      @EndUserText.label: 'Open SOQty 63to70 Days(Small-No of Line)'
      opensoqtysnl63,
      @EndUserText.label: 'Open SOQty 63to70 Days(Small-Reqd Days)'
      OpenSoQtySrd63,
      @EndUserText.label: 'Open SOQty 71to365 Days(Small-Weight)'
      OpenSoQtySwt71,
      @EndUserText.label: 'Open SOQty 71-365 D(Small-No of Line)'
      opensoqtysnl71,
      @EndUserText.label: 'Open SOQty 71-365 D(Small-Reqd Days)'
      OpenSoQtySrd71,
      @EndUserText.label: 'Open SOQty> 365D+HoldQty(Small-Weight)'
      OpenSoQtySwt366,
      @EndUserText.label: 'Open SOQty> 365D+HoldQty(Small-No of Line)'
      opensoqtysnl366,
      @EndUserText.label: 'Open SOQty> 365D+HoldQty(Small-Reqd Days)'
      OpenSoQtySrd366

}
