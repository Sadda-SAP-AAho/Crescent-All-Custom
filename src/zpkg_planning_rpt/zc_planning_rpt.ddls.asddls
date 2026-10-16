@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List wise Shortage Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_PLANNING_RPT 
as select from zdt_packing_det //ZCDS_PLANING_RPT_V8
{
    @UI.hidden: true
    key shippingpoint as Plant,
    @UI.hidden: true
    key comdeldt as comdt,
    @UI.hidden: true
    key piority,
    @EndUserText.label: 'Sales Order'
    key salesdocument,
    @EndUserText.label: 'Sales Order Item'
    key salesdocumentitem,
    @EndUserText.label: 'Packing List No'
    key docentey,
    @EndUserText.label: 'Packing List Item'
    key deliverydocumentitem,
    @UI.hidden: true
    key bomlevel,
    @UI.hidden: true
    key parent,
    @UI.hidden: true
    key component,
    @UI.hidden: true
    creationdate,
    @EndUserText.label: 'Doc Date'
    docdate,
    @EndUserText.label: 'FG Sl No'
    fgsino,
    @UI.hidden: true
    shippingpoint,
    @UI.hidden: true
    deliverydate,
    @EndUserText.label: 'Card Code'
    cardcode,
    @EndUserText.label: 'Item Code'
    itemcode,
    @EndUserText.label: 'Item Name'
    itemname,
    @EndUserText.label: 'Hold Status'
    soholdstat,
    @EndUserText.label: 'Weight'
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    weight,
    @UI.hidden: true
    weightunit,
    @EndUserText.label: 'Order Qty'
    @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
    ordqty,
    @UI.hidden: true
    deliveryquantityunit,
    @EndUserText.label: 'FG Stock'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    fgstock,
    @UI.hidden: true
    materialbaseunit,
    @EndUserText.label: 'Avail FG Stock'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    avlfgstock,
    @EndUserText.label: 'Balance FG Stock'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    balfgstock,
    @EndUserText.label: 'Father'
    father,
    @EndUserText.label: 'Father Oprn Code'
    productgrouptextf,
    @EndUserText.label: 'Child'
    child,
    @EndUserText.label: 'Oprn Code'
    productgrouptext,
    @EndUserText.label: 'Reqd Qty'
    reqdqty,
    @EndUserText.label: 'CASTING Stock'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
    caststock2,
    @UI.hidden: true
    materialbaseunit1,
    @EndUserText.label: 'Total SFG Stock'
    totsfgstock,
    @EndUserText.label: 'Avail SFG Stock'
    avasfgstock,
    @EndUserText.label: 'Balance SFG Stock'
    balsfgstock,
    @EndUserText.label: 'PAINTING Item'
    paintitm,
    @EndUserText.label: 'PAINTING Item Name'
    paintitmtxt,
    @EndUserText.label: 'PAINTING Stock'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
    paintstock,
    @EndUserText.label: 'MACHINING Item'
    macitm,
    @EndUserText.label: 'MACHINING Item Name'
    macitmtxt,
    @EndUserText.label: 'MACHINING Stock'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
    macstock,
    @EndUserText.label: 'MCBOMQTY'
    @Semantics.quantity.unitOfMeasure: 'bomitemqtyunit'
    macbiqty,
    @UI.hidden: true
    bomitemqtyunit,
    @EndUserText.label: 'GRINDING Item'   
    grinditm,
    @EndUserText.label: 'GRINDING Item Name'
    grinditmtxt,
    @EndUserText.label: 'GRINDING Stock'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
    grindstock,
    @EndUserText.label: 'GRBOMQTY'
    @Semantics.quantity.unitOfMeasure: 'bomitemqtyunit'
    grindbiqty,
    @EndUserText.label: 'CASTING Item'
    castitm,
    @EndUserText.label: 'CASTING Item Name'
    castitmtxt,
    @EndUserText.label: 'CASTING Stock'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
    caststock,
    @EndUserText.label: 'CASTBOMQTY'
    @Semantics.quantity.unitOfMeasure: 'bomitemqtyunit'
    castbiqty,    
    @EndUserText.label: 'Total PAINT Stock'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit2'
    totpaistock,
    @UI.hidden: true
    materialbaseunit2,
    @EndUserText.label: 'Total MACHINING Stock'
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit3'
    totmacstock,
    @UI.hidden: true
    materialbaseunit3,
    @EndUserText.label: 'Container Nick Name'
    contno,
    @EndUserText.label: 'Dept'
    moc,
    @EndUserText.label: 'Comt. Del. Date'
    comdeldt,
    @EndUserText.label: 'Trans Type'
    transtyp,
    @EndUserText.label: 'Production Unit'
    produnit,
    @EndUserText.label: 'Pattern IR Sent'
    ptnirs,
    @EndUserText.label: 'Sales Order No'
    salesord,
    @EndUserText.label: 'Customer Ref No'
    cusrefno,
    @EndUserText.label: 'Customer Order Date'
    cusorddt,
    @EndUserText.label: 'Customer Description'
    cusdesc,
    @EndUserText.label: 'Order Status'
    ordstatus,
    @EndUserText.label: 'Mould Type'
    mouldtype,
    @EndUserText.label: 'Bunch Wt'
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    bunchwt,
    @EndUserText.label: 'Sub-Resource Code'
    subrescode,
    @EndUserText.label: 'Type of Moulding'
    typeofmould,
    @EndUserText.label: 'Qty per Box'
    qtyperbox,
    @EndUserText.label: 'Unit Weight'
    @Semantics.quantity.unitOfMeasure: 'WeightUnit1'
    unitweight,
    @UI.hidden: true
    weightunit1,
    @EndUserText.label: 'Total Order Weight'
    @Semantics.quantity.unitOfMeasure: 'WeightUnit1'
    totordweight,
    @EndUserText.label: 'Total FG Weight'
    @Semantics.quantity.unitOfMeasure: 'WeightUnit1'
    totfgweight,
    @EndUserText.label: 'FG Code'
    fgcode
}
