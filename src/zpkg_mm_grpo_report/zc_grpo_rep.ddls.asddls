@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GRPO Standard Actual Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_GRPO_REP 
as select from ZCDS_GRPO_REP_1
{
    @EndUserText.label: 'GRPO No.'
    key MaterialDocument,
    @UI.hidden: true
    key MaterialDocumentItem,
    @UI.hidden: true
    key MaterialDocumentYear,
    @EndUserText.label: 'Doc Date'
    DocumentDate,
    @EndUserText.label: 'Card Code'
    Supplier,
    @EndUserText.label: 'Card Name'
    SupplierFullName,
    @EndUserText.label: 'Vendor Ref No.'
    YY1_ChallanNumber_MMI,
    @EndUserText.label: 'Ref. Dt.'
    YY1_ChallanDate_MMI,
    @EndUserText.label: 'GRPO Quality Approval'
    decision,
    @EndUserText.label: 'A/P Inv Dt'
    @UI.hidden: true
    apinvdt,
    @EndUserText.label: 'Approver Name'
    @UI.hidden: true
    appname,
    @EndUserText.label: 'Location'
    Plant,
    @EndUserText.label: 'Department'
    StorageLocation,
    @EndUserText.label: 'ItemCode'
    Material,
    @EndUserText.label: 'Dscription'
    ProductName,
    @EndUserText.label: 'Mat. Group Code'
    ProductGroup,
    @EndUserText.label: 'Mat. Group Name'
    ProductGroupName,
    @EndUserText.label: 'Quantity'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    QuantityInEntryUnit,
    @EndUserText.label: 'Unit'
    @UI.hidden: true
    MaterialBaseUnit,
    @EndUserText.label: 'Item CE% Max.'
    ceupp,
    @EndUserText.label: 'Item CE% Min.'
    celow,
    @EndUserText.label: 'GRPO CE%'
    ceact,
    @EndUserText.label: 'Item S% Max'
    supp,
    @EndUserText.label: 'Item S% Min'
    slow,
    @EndUserText.label: 'GRPO S%.'
    sact,
    @EndUserText.label: 'Item Mn% Max'
    mnupp,
    @EndUserText.label: 'Item Mn% Min'
    mnlow,
    @EndUserText.label: 'GRPO Mn%'
    mnact,
    @EndUserText.label: 'Item Si% Max'
    siupp,
    @EndUserText.label: 'Item Si% Min'
    silow,
    @EndUserText.label: 'GRPO Si%'
    siact,
    @EndUserText.label: 'Item C% Max'
    cupp,
    @EndUserText.label: 'Item C% Min'
    clow,
    @EndUserText.label: 'GRPO C%.'
    cact,
    @EndUserText.label: 'Item VM% Max'
    vmupp,
    @EndUserText.label: 'Item VM% Min'
    vmlow,
    @EndUserText.label: 'GRPO VM%'
    vmact,
    @EndUserText.label: 'Item Sr% Max'
    srupp,
    @EndUserText.label: 'Item Sr% Min'
    srlow,
    @EndUserText.label: 'GRPO Sr%'
    sract,
    @EndUserText.label: 'Item P%'
    pupp,
    @EndUserText.label: 'GRPO P%'
    pact,
    @EndUserText.label: 'Item Ca%'
    caupp,
    @EndUserText.label: 'GRPO Ca%'
    caact,
    @EndUserText.label: 'U_BAMIN'
    ubamin,
    @EndUserText.label: 'Item Al%'
    aiupp,
    @EndUserText.label: 'GRPO Al%'
    aiact,
    @EndUserText.label: 'Item Ash%'
    ashupp,
    @EndUserText.label: 'GRPO Ash%'
    ashact,
    @EndUserText.label: 'Item Fix C%'
    fixcupp,
    @EndUserText.label: 'GRPO Fix C%'
    fixcact,
    @EndUserText.label: 'Item Moisture%'
    moisupp,
    @EndUserText.label: 'GRPO Moisture%'
    moisact,
    @EndUserText.label: 'Item Gel Index%'
    gelupp,
    @EndUserText.label: 'GRPO Gel Index%'
    gelact
}
