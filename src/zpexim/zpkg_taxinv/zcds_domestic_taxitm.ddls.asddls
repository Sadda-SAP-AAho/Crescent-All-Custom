@AbapCatalog.sqlViewName: 'ZV_DOMITM'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'domestic taxinvoice item details'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_DOMESTIC_TAXITM 
  as select from    zi_taxhdr                      as i
    left outer join I_BillingDocument              as a on a.BillingDocument = i.Billingdoc
    left outer join I_BillingDocumentItem          as b on a.BillingDocument = b.BillingDocument
    left outer join I_BillingDocumentItemPrcgElmnt as c on  c.BillingDocument     = b.BillingDocument
                                                        and c.BillingDocumentItem = b.BillingDocumentItem
                                                        and (
                                                           c.ConditionType        = 'ZPR0'
                                                           or c.ConditionType     = 'ZPR1'
                                                         )
  // left outer join I_BillingDocumentItemPrcgElmnt as z on z.BillingDocument = b.BillingDocument
  //                                                    and z.BillingDocumentItem = b.BillingDocumentItem
  //                                                    and z.ConditionType = 'ZSPC'
    left outer join I_BillingDocumentItemPrcgElmnt as d on  d.BillingDocument     = b.BillingDocument
                                                        and d.BillingDocumentItem = b.BillingDocumentItem
                                                        and (
                                                           d.ConditionType        = 'ZK07'
                                                           or d.ConditionType     = 'ZK08'
                                                           or d.ConditionType     = 'D100'
                                                         )
    left outer join I_BillingDocumentItemPrcgElmnt as e on  e.BillingDocument     = b.BillingDocument
                                                        and e.BillingDocumentItem = b.BillingDocumentItem
                                                        and (
                                                           e.ConditionType        = 'JOIG'
                                                           or e.ConditionType     = 'ZOIG'
                                                         )
    left outer join I_BillingDocumentItemPrcgElmnt as n on  n.BillingDocument     = b.BillingDocument
                                                        and n.BillingDocumentItem = b.BillingDocumentItem
                                                        and n.ConditionType       = 'JOCG'
    left outer join I_BillingDocumentItemPrcgElmnt as o on  o.BillingDocument     = b.BillingDocument
                                                        and o.BillingDocumentItem = b.BillingDocumentItem
                                                        and o.ConditionType       = 'JOSG'
    left outer join I_BillingDocumentItemPrcgElmnt as m on  m.BillingDocument     = b.BillingDocument
                                                        and m.BillingDocumentItem = b.BillingDocumentItem
                                                        and (
                                                           m.ConditionType        = 'JTC1'
                                                           or m.ConditionType     = 'JTC2'
                                                         )
  left outer join I_BillingDocumentItemPrcgElmnt as z on  z.BillingDocument     = b.BillingDocument
                                                        and z.BillingDocumentItem = b.BillingDocumentItem
                                                        and (
                                                           z.ConditionType        = 'ZNP0'
                                                          
                                                         )
  

    left outer join I_BillingDocumentItemPrcgElmnt as f on  f.BillingDocument     = b.BillingDocument
                                                        and f.BillingDocumentItem = b.BillingDocumentItem
                                                        and (
                                                           f.ConditionType        = 'ZFIP'
                                                           or f.ConditionType     = 'ZFIV'
                                                           //  or f.ConditionType = 'ZPFP' or f.ConditionType = 'ZPFV'
                                                           or f.ConditionType     = 'ZXIP'
                                                           or f.ConditionType     = 'ZXIV'
                                                         )
    left outer join I_SalesOrderItem               as h on  h.SalesOrder        = b.SalesDocument
                                                        and b.SalesDocumentItem = h.SalesOrderItem
                                                        and h.Product           = b.Product
    left outer join I_ProductPlantBasic            as k on  k.Product = b.Product
                                                        and k.Plant   = b.Plant
    left outer join I_AE_CnsmpnTaxCtrlCodeTxt      as j on  j.ConsumptionTaxCtrlCode = k.ConsumptionTaxCtrlCode
                                                        and j.Language               = 'E'
                                                        and j.CountryCode            = 'IN'

{
  key a.BillingDocument,
  key b.BillingDocumentItem,
      b.BillingDocumentItemText,
      @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
      b.ItemNetWeight,
      @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
      sum(b.ItemNetWeight)                                                                                                        as Totalnetweight,
      k.ConsumptionTaxCtrlCode,
      j.ConsumptionTaxCtrlCodeText1,
      @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
      b.BillingQuantity,
      b.BillingQuantityUnit,
      c.ConditionRateValue                                                                                                        as rate,
      a.AccountingExchangeRate,
      ( c.ConditionRateValue * a.AccountingExchangeRate )                                                                         as rateigstlut,
      c.TransactionCurrency,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      m.ConditionAmount                                                                                                           as tcs,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      d.ConditionAmount                                                                                                           as discvalue,
      e.ConditionRateValue                                                                                                        as igstrate,
      n.ConditionRateValue                                                                                                        as cgstrate,
      o.ConditionRateValue                                                                                                       as sgstrate,
      cast( cast( e.ConditionAmount as abap.dec(13,2) ) * cast( a.AccountingExchangeRate as abap.dec(13,2) )  as abap.dec(13,2) ) as igstamt,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      n.ConditionAmount                                                                                                           as cgstamt,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      o.ConditionAmount                                                                                                           as sgstamt,

      //       c.ConditionRateValue * b.BillingQuantity as Totalvalue,
      @Semantics.amount.currencyCode : 'TransactionCurrency'
      f.ConditionAmount                                                                                                           as packingfreight,
      h.MaterialByCustomer                                                                                                       as customermaterial,
      //     cast( (coalesce(c.ConditionAmount,0) + coalesce(z.ConditionAmount,0) ) as abap.dec(23,2) ) as updat
  cast( cast( z.ConditionAmount as abap.dec(13,2) ) * cast( a.AccountingExchangeRate as abap.dec(13,2) )  as abap.dec(13,2) ) as amttaxableigstlut
}

group by
  a.BillingDocument,
  b.BillingDocumentItem,
  b.ItemNetWeight,
  b.BillingDocumentItemText,
  k.ConsumptionTaxCtrlCode,
  j.ConsumptionTaxCtrlCodeText1,
  b.BillingQuantity,
  b.BillingQuantityUnit,
  c.ConditionRateValue,
  n.ConditionRateValue,
  o.ConditionRateValue,
  a.AccountingExchangeRate,
  c.TransactionCurrency,
  d.ConditionAmount,
  e.ConditionRateValue,
  e.ConditionAmount,
  z.ConditionAmount,
  n.ConditionAmount,
  o.ConditionAmount,
  f.ConditionAmount,
  h.MaterialByCustomer,
  m.ConditionAmount

