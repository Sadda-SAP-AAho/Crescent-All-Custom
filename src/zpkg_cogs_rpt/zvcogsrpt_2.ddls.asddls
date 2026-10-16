@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COGS Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVCOGSRPT_2

  with parameters
    p_begin : datum,
    p_end   : datum

  as select from    ZVCOGSRPT_1             as a

    inner join      ZVCOGSRPT_8             as b on  b.MaterialDocument     = a.MaterialDocument
                                                 and b.MaterialDocumentItem = a.MaterialDocumentItem
                                                 and b.PostingDate          = a.PostingDate

    inner join      I_Product               as d on d.Product = b.Material

    inner join      I_ProductText           as h on  h.Product  = b.Material
                                                 and h.Language = $session.system_language

    inner join      I_ProductValuationBasic as i on  i.Product       = d.Product
                                                 and i.ValuationArea = b.Plant

    left outer join ZVCOGSRPT_5             as c on  c.ReferenceSDDocument     = b.DeliveryDocument
                                                 and c.ReferenceSDDocumentItem = b.DeliveryDocumentItem

    left outer join I_ProductCostEstimate   as e on  e.Product                       =  b.Material
                                                 and e.CostEstimateValidityStartDate <= b.PostingDate
                                                 and e.CostEstimateValidityEndDate   >= b.PostingDate
                                                 and e.Plant                         =  b.Plant
                                                 and e.CostEstimateStatus            =  'FR'

    left outer join I_CalendarDate          as g on g.CalendarDate = b.PostingDate

    left outer join ZVCOGSRPT_6             as f on  f.CostEstimate = e.CostEstimate
                                                 and f.CostingDate  = g.FirstDayOfMonthDate

{

  key    a.AccountingDocument,
  key    a.FiscalYear,
  key    a.CompanyCode,
  key    a.AccountingDocumentItem,
  key    a.MaterialDocument                                           as PGINo,
  key    b.MaterialDocumentItem                                       as PGIItem,
  key    b.PostingDate                                                as PGIDate,
         c.SoldToParty,
         a.OriginalReferenceDocument,
         a.GLAccount,
         a.GLAccountName,
         a.ProfitCenter,
         a.ProfitCenterName,
         a.CompanyCodeCurrency,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         a.AmountInCompanyCodeCurrency,
         b.DeliveryDocument,
         b.DeliveryDocumentItem,
         c.GSTInvoiceNumber,
         c.CommercialInvoiceNumber,
         d.Product,
         h.ProductName,
         b.Plant,
         cast( b.QuantityInBaseUnit as abap.dec( 15,3 ) )             as QuantityInBaseUnit,
         b.MaterialBaseUnit,
         d.WeightUnit,
         @Semantics.quantity.unitOfMeasure: 'WeightUnit'
         d.NetWeight,
         @Semantics.quantity.unitOfMeasure: 'WeightUnit'
         b.QuantityInBaseUnit * cast( d.NetWeight as abap.dec(15,2) ) as TotalWeight,
         e.CostEstimate,
         e.ValuationQuantityUnit,
         cast( e.CostingLotSize as abap.dec( 12,3 ) )                 as CostingLotSize,
         f.CostingDate,
         f.Currency,
         case when e.CostEstimate is not initial then
         case when i.PriceDeterminationControl = 'V' then cast( a.AmountInCompanyCodeCurrency as abap.dec(15,2) ) else f.DirectMaterial end
         else cast( a.AmountInCompanyCodeCurrency as abap.dec(15,2) )
         end                                                          as DirectMaterial,
         f.Credits,
         f.PackingPattern,
         f.StoresSpares,
         f.MaterialOverhead,
         f.MouldingExpense,
         f.FetlingExpense,
         f.ElectricityExpense,
         f.FabricationExpense,
         f.StoresCost,
         f.MachiningCharges,
         f.MeltingCost,
         f.FerroAlloyTreatment,
         f.PatternCost,
         f.MachineCost,
         f.PaintFinishExp

}

where
  (
        b.GoodsMovementType = '601'
    or  b.GoodsMovementType = '602'
    or  b.GoodsMovementType = '657'
    or  b.GoodsMovementType = '658'
  )

  and(
        a.PostingDate       >= $parameters.p_begin
    and a.PostingDate       <= $parameters.p_end
  )
