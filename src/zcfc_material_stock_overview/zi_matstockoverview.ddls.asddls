@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Stock Overview'
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MATSTOCKOVERVIEW
  with parameters
    p_date_low   : zde_date,
    p_date_high  : zde_date,
    p_plant      : zde_plant_cd,
    p_mat_Grp    : zde_mat_grp,
    p_date_low_1 : zde_date

  as select from    ZI_MATDETAILS as a

  // Opening Stock – CDS 1 already returns previous day
    inner join      ZI_MATLOPSTCK(
                        p_date_low_1 : $parameters.p_date_low_1
                    )             as b on  a.Material        = b.Product
                                       and a.Plant           = b.Plant
                                       and a.StorageLocation = b.StorageLocation

  // Closing Stock
    inner join      ZI_MATLCLSTCK(
                        p_date_high : $parameters.p_date_high
                    )             as c on  a.Material        = c.Product
                                       and a.Plant           = c.Plant
                                       and a.StorageLocation = c.StorageLocation

  // Goods Receipt
    left outer join ZI_GOODSRECEIPT(
                     p_date_low  : $parameters.p_date_low,
                     p_date_high : $parameters.p_date_high
                    )             as d on  a.Material        = d.Material
                                       and a.Plant           = d.Plant
                                       and a.StorageLocation = d.StorageLocation
                                       and d.GoodsReceiptQty > cast( '0' as abap.dec(15,3))

  // Goods Issue
    left outer join ZI_GOODSISSUE(
                     p_date_low  : $parameters.p_date_low,
                     p_date_high : $parameters.p_date_high
                    )             as e on  a.Material        = e.Material
                                       and a.Plant           = e.Plant
                                       and a.StorageLocation = e.StorageLocation
                                       and e.GoodsIssueQty   > cast( '0' as abap.dec(15,3))

{
  key a.Material,
  key a.Plant,
  key a.StorageLocation,

      // Material Master Fields
      a.CompanyCode,
      a.ValuationArea,
      a.ValuationClass,
      a.ProductType,
      a.ProductGroup,
      a.ExternalProductGroup,
      a.PurchasingGroup,
      a.MatDesc,
      a.BaseUoM,
      a.Currency,
      a.PriceControl,

      // Stock Quantities
      b.OpenStkQty,

      // Goods Receipt
      d.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(d.GoodsReceiptQty as abap.dec(15,3)) as GoodsReceiptQty,
      d.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      d.GoodsReceiptValue,

      // Goods Issue
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(e.GoodsIssueQty as abap.dec(15,3))   as GoodsIssueQty,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      e.GoodsIssueValue,

      // Closing Stock
      c.ClosingStkQty
}
where
       a.ProductGroup = $parameters.p_mat_Grp
  and  a.Plant        = $parameters.p_plant
