@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Cost Report'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_BOMCOST_RPT
  as select from ZR_BOMCOST_RPT
{
        @EndUserText.label: 'Plant'
        //        @Consumption.filter.mandatory: true
  key   Plant,
        @EndUserText.label: 'Header Material'
        //        @Consumption.filter.mandatory: true
  key   Hedmaterial,
        @EndUserText.label: 'Header Mat. Grp. Code'
  key   HeaderGrpCode,
        @EndUserText.label: 'Header Mat. Grp. Name'
  key   HeaderGrpName,
        @EndUserText.label: 'Header Qty'
  key   HeadQty,
        @EndUserText.label: 'Level'
  key   Bomlevel,
        @EndUserText.label: 'Parent Material'
  key   Parent,
        @UI.hidden: true
  key   seq,
        @EndUserText.label: 'Costing Item Category'
  key   Costitemcat,
        @UI.hidden: true
  key   sequence,
        @EndUserText.label: 'Child Material/Activity'
  key   Component,
        @EndUserText.label: 'Parent Material Gross Weight'
        @Semantics.quantity.unitOfMeasure: 'ParentGrossWtUnit'
        ParentGrosswt,
        @UI.hidden: true
        ParentGrossWtUnit,
        @EndUserText.label: 'Parent Material Net Weight'
        @Semantics.quantity.unitOfMeasure: 'ParentNetWtUnit'
        ParentNetwt,
        @UI.hidden: true
        ParentNetWtUnit,
        
        @EndUserText.label: 'Material/Activity Name'
        ChildDesc,
        @EndUserText.label: 'Child Mat. Grp. Code'
        ChildGrpCode,
        @EndUserText.label: 'Child Mat. Grp. Name'
        ChildGrpName,
        @EndUserText.label: 'Child Storage Loc.'
        ChildStorageLoc,
        @EndUserText.label: 'Quantity'
        Childqty,
        @EndUserText.label: 'UOM'
        Bomitemqtyunit,
        @EndUserText.label: 'Net Weight'
        @Semantics.quantity.unitOfMeasure: 'ChildWtUnit'
        ChildNetwt,
        @EndUserText.label: 'Weight Unit'
        ChildWtUnit,
        @EndUserText.label: 'Child Mat. Plant'
        ChildPlant,
        
        @EndUserText.label: 'Stock UOM'
        MaterialBaseUnit,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        @EndUserText.label: 'Child Mat. Stock'
        ChildMatlStock,
        @EndUserText.label: 'Price Control'
        PriceControl,
        @EndUserText.label: 'Currency'
        Currency,
        @Semantics.amount.currencyCode: 'Currency'
        @EndUserText.label: 'Rate'
        Rate,
        @EndUserText.label: 'Rate Quantity'
        RateQty,
        @EndUserText.label: 'Amount'
        Amount
}
