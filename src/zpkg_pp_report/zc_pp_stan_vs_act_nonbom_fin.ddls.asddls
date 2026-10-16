@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_PP_STAN_VS_ACT_NONBOM_FIN 
as select from ZCDS_PP_STAN_VS_ACT_NONBOM_FIN 
{
    @EndUserText.label: 'Posting Date'
    key PostingDate,
    @EndUserText.label: 'Plant'
    key Plant,
    @EndUserText.label: 'Department'
    key CostCenter,
//    @EndUserText.label: 'Department Name'
//    key CostCenterDescription,
    @EndUserText.label: 'G/L Code'
    key GLAccount,
    @EndUserText.label: 'G/L Name'
    key GLAccountLongName,
    @EndUserText.label: 'Consumption Base'
    key conbase,   
    @UI.hidden: true
    key MaterialBaseUnit,
    @EndUserText.label: 'Issued Comp. Code'
    key Material,
    @EndUserText.label: 'Issued Comp.Name'
    key ProductDescription,
    @EndUserText.label: 'Material Grp Code'
    MaterialGroup,
    @EndUserText.label: 'Material Grp Name'
    MaterialGroupName,
    @EndUserText.label: 'LM/Casting Produced Qty'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    lmqty,
    @EndUserText.label: 'Consumption/Tonne'
   // @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
    conqty,
    @UI.hidden: true
    MaterialBaseUnit1,
    @EndUserText.label: 'Actual Issued Qty-Kg'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit2'
    issqty,
    @UI.hidden: true
    MaterialBaseUnit2,
    @EndUserText.label: 'Actual Issue Value'
    @Semantics.amount.currencyCode: 'Currency'
    actissval,
    @UI.hidden: true
    currency,
    @EndUserText.label: 'Std Issue Qty'
    stdissue,
    @EndUserText.label: 'Last pur Price'
    lastpurprice,
    @EndUserText.label: 'Std Issue Value'
    stdissueval,
    @EndUserText.label: 'Value Difference'
    valdiff
    
}
