@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List wise Shortage Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PLANING_RPT_V7
  as select from ZCDS_PLANING_RPT_V1
{
  key SalesDocument,
  key SalesDocumentItem,
  key piority,
  key docentey,
  key DeliveryDocumentItem,
  key bomlevel,
  key parent,
  key component,
      CreationDate,
      docdate,
      fgsino,
      ShippingPoint,
      DeliveryDate,
      cardcode,
      itemcode,
      itemname,
      soholdstat,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      weight,
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      ordqty,
      DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      fgstock,
      MaterialBaseUnit,
      father,
      ProductGroupTextf,
      child,
      ProductGroupText,
      bomitemqty,
      sodelqty,
      // reqdqty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      caststock2,
      MaterialBaseUnit1,
      cast( ( tsstck  ) as abap.dec( 13, 3 ) ) as totsfgstock,
//      case when reqdqty <= 0 then cast( 0 as abap.dec( 13, 3 ) )
//           else cast( 0 as abap.dec( 13, 3 ) ) end                                as avasfgstock,
      paintitm,
      paintitmtxt,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      paintstock,
      macitm,
      macitmtxt,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      macstock,
      macbiqty,
      bomitemqtyunit,
      grinditm,
      grinditmtxt,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      grindstock,
      grindbiqty,
      castitm,
      castitmtxt,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      Caststock,
      castbiqty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit2'
      totpaistock,
      MaterialBaseUnit2,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit3'
      totmacstock,
      MaterialBaseUnit3,
      contno,
      moc,
      comdeldt,
      transtyp,
      produnit,
      ptnirs,
      salesord,
      cusrefno,
      cusorddt,
      cusdesc,
      ordstatus,
      mouldtype,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      bunchwt,
      subrescode,
      typeofmould,
      qtyperbox,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit1'
      unitweight,
      WeightUnit1,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit1'
      totordweight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit1'
      totfgweight,
      fgcode
}
where ordqty is not initial
