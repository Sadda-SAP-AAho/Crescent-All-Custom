@AbapCatalog.sqlViewName: 'ZCMATSTOCKQ'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Stock Overview'
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION

define view ZC_MATSTOCKOVERVIEW
  with parameters
    p_date_low   : zde_date,
    p_date_high  : zde_date,
    p_plant      : zde_plant_cd,
    p_mat_Grp    : zde_mat_grp,
    p_date_low_1 : zde_date

  as select from ZI_MATSTOCKOVERVIEW(
                 p_date_low   : $parameters.p_date_low,
                 p_date_high  : $parameters.p_date_high,
                 p_plant      : $parameters.p_plant,
                 p_mat_Grp    : $parameters.p_mat_Grp,
                 p_date_low_1 : $parameters.p_date_low_1
                 )
{
      @EndUserText.label: 'Material'
      @Search.defaultSearchElement: true
  key Material,
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Storage Location'
  key StorageLocation,
      @EndUserText.label: 'Company Code'
      CompanyCode,
      @EndUserText.label: 'Valuation Area'
      ValuationArea,
      @EndUserText.label: 'ValuationClass'
      ValuationClass,
      @EndUserText.label: 'ProductType'
      ProductType,
      @EndUserText.label: 'ProductGroup'
      ProductGroup,
      @EndUserText.label: 'Material Description'
      MatDesc,
      @EndUserText.label: 'Ext. Material Group'
      ExternalProductGroup,
      @EndUserText.label: 'PurchasingvGroup'
      PurchasingGroup,
      @EndUserText.label: 'Base Unit of Measure'
      BaseUoM,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'PriceCvontrol'
      PriceControl,
      @EndUserText.label: 'Stock Quantity on Period Start'
      OpenStkQty,
      @UI.hidden: true
      MaterialBaseUnit,
      @EndUserText.label: 'Total Goods Receipt Quantity'
      GoodsReceiptQty,
      @UI.hidden: true
      CompanyCodeCurrency,
      @EndUserText.label: 'Total Goods Receipt Value'
      GoodsReceiptValue,
      @EndUserText.label: 'Total Goods Issue Quantity'
      GoodsIssueQty,
      @EndUserText.label: 'Total Goods Issue Value'
      GoodsIssueValue,
      @EndUserText.label: 'Stock Quantity on Period End'
      ClosingStkQty
}
