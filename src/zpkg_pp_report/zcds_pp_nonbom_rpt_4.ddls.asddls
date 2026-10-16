@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Package NonBOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_NONBOM_RPT_4
  as select from ZCDS_PP_NONBOM_RPT_2
{
  key MaterialDocument,
  key MaterialDocumentYear,
  key PostingDate,
  key Material,
  key Plant,
  key consbase,
  key CostCenter,
  key GLAccount,
  key typeofmould1              as typeofmould,
      ProductName,
      MaterialGroup,
      MaterialGroupName,
      //      CostCenterDescription,
      GLAccountLongName,
      qtyperbox,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      actissue                  as actissue,
      MaterialBaseUnit1,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      sum( QuantityInBaseUnit ) as QuantityInBaseUnit,
      conqty                    as conqty,
      @Semantics.amount.currencyCode: 'currency'
      actissval                 as actissval,
      currency

}

group by
  MaterialDocument,
  MaterialDocumentYear,
  PostingDate,
  Material,
  Plant,
  consbase,
  CostCenter,
  typeofmould1,
  GLAccount,
  ProductName,
  MaterialGroup,
  MaterialGroupName,
  //  CostCenterDescription,
  GLAccountLongName,
  qtyperbox,
  MaterialBaseUnit,
  actissue,
  MaterialBaseUnit1,
  conqty,
  actissval,
  currency
