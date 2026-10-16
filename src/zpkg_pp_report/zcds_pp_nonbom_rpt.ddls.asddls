@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Non BOM Standard VS Actual Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PP_NONBOM_RPT
  as select from    I_MaterialDocumentItem_2 as a
    inner join      I_ProductText            as b on  b.Product  = a.Material
                                                  and b.Language = 'E'
    inner join      zdt_cc_type              as f on f.kostl = a.CostCenter
    left outer join zdt_pp_matinffld         as c on c.product = a.Material
    inner join      I_CostCenterText         as d on  d.CostCenter      = a.CostCenter
                                                  and d.ControllingArea = a.ControllingArea
                                                  and d.ValidityEndDate = '99991231'
    left outer join I_GLAccountTextRawData   as e on  e.GLAccount = a.GLAccount
                                                  and e.Language  = 'E'
    inner join      zdt_cc_dept              as g on g.kostl = a.CostCenter
    left outer join I_Product                as h on a.Material = h.Product
    left outer join I_ProductGroupText_2     as i on  h.ProductGroup = i.ProductGroup
                                                  and i.Language     = 'E'
{
  key a.MaterialDocument,
  key a.MaterialDocumentYear,
  key a.PostingDate,
  key a.Material,
  key a.Plant,
  key case when c.consbase = 'CASTING' then 'CASTING'
           when c.consbase = 'LM' then 'MELTING' else '' end                                 as consbase,
      //key ltrim( a.CostCenter, '0' )                             as CostCenter,
  key g.dept                                                                                 as CostCenter,
  key a.GLAccount,
  key f.cctype,
      b.ProductName,
      h.ProductGroup                                                                         as MaterialGroup,
      i.ProductGroupName                                                                     as MaterialGroupName,
      //      d.CostCenterDescription,
      e.GLAccountLongName,
      c.qtyperbox,
      c.typeofmould,
      case when f.cctype = 'CI'   then c.constci
           when f.cctype = 'DI'   then c.constdi
           when f.cctype = 'BAG1' then c.constbag1
           when f.cctype = 'BAG2' then c.constbag2
           when f.cctype = 'BARD' then c.constbaroda
           when f.cctype = 'VKUL' then c.constvackul
           else cast( 0 as abap.dec(13, 3) ) end                                             as conqty,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( case when a.GoodsMovementType =  '201' then a.QuantityInBaseUnit
                when a.GoodsMovementType =  '202' then -1 * a.QuantityInBaseUnit end )       as actissue,
      @Semantics.amount.currencyCode: 'currency'
      sum( case when a.GoodsMovementType =  '201' then a.TotalGoodsMvtAmtInCCCrcy
                when a.GoodsMovementType =  '202' then -1 * a.TotalGoodsMvtAmtInCCCrcy end ) as actissval,
      a.CompanyCodeCurrency                                                                  as currency
}
where
  (
       a.GoodsMovementType =  '201'
    or a.GoodsMovementType =  '202'
  )
  // and  a.GoodsMovementIsCancelled <> 'X'
  and  a.CostCenter        is not initial
  and(
       a.Plant             =  '1100'
    or a.Plant             =  '1200'
    or a.Plant             =  '1300'
    or a.Plant             =  '1400'
  )
  //  and(
  //       c.consbase          = 'LM'
  //    or c.consbase          = 'CASTING'
  //  )

  and  a.GLAccount         <> '0047200010'
  and  a.GLAccount         <> '0047200050'
  and  a.GLAccount         <> '0047200060'
  and  a.GLAccount         <> '0047200070'
  and  a.GLAccount         <> '0047200080'
  and  a.GLAccount         <> '0047200090'
  and  a.GLAccount         <> '0047300040'
  and  a.GLAccount         <> '0047600250'
  and  a.GLAccount         <> '0048100040'
  and  a.GLAccount         <> '0048400030'
  and  a.GLAccount         <> '0048400040'
  and  a.GLAccount         is not initial

group by
  a.MaterialDocument,
  a.MaterialDocumentYear,
  a.PostingDate,
  a.Material,
  a.Plant,
  c.consbase,
  //  a.CostCenter,
  g.dept,
  a.GLAccount,
  f.cctype,
  b.ProductName,
  h.ProductGroup,
  i.ProductGroupName,
  //  d.CostCenterDescription,
  e.GLAccountLongName,
  c.qtyperbox,
  c.typeofmould,
  a.MaterialBaseUnit,
  f.cctype,
  c.constci,
  c.constdi,
  c.constbag1,
  c.constbag2,
  c.constbaroda,
  c.constvackul,
  a.CompanyCodeCurrency
