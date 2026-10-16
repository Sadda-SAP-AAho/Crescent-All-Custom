@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_1

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from    I_BillingDocument                                                        as a

    inner join      I_BillingDocumentItem                                                    as b  on a.BillingDocument = b.BillingDocument

    inner join      I_SalesDocumentItem                                                      as d  on  d.SalesDocument     = b.SalesDocument
                                                                                                   and d.SalesDocumentItem = b.SalesDocumentItem

    inner join      I_SalesDocument                                                          as h  on h.SalesDocument = b.SalesDocument

    left outer join ZV_COSTINGPL_30                                                          as p  on  p.Product       = b.Product
                                                                                                   and p.ValuationArea = b.Plant

    left outer join I_DeliveryDocumentItem                                                   as c  on  c.DeliveryDocument     = b.ReferenceSDDocument
                                                                                                   and c.DeliveryDocumentItem = b.ReferenceSDDocumentItem

    left outer join I_DeliveryDocument                                                       as i  on i.DeliveryDocument = b.ReferenceSDDocument

    left outer join ztmg_salesgrp                                                            as e  on  b.SalesGroup            = e.salesgroup
                                                                                                   and e.configdeprecationcode is initial

    left outer join I_ProductPlantBasic                                                      as f  on  b.Product = f.Product
                                                                                                   and b.Plant   = f.Plant

    left outer join ZI_DELDASH_HDR                                                           as g  on  b.ReferenceSDDocument =  g.Delivery
                                                                                                   and g.Canind              <> 'X'

    left outer join ZV_SALESREGPACKLIST                                                      as j  on  b.ReferenceSDDocument     = j.Delivery
                                                                                                   and b.ReferenceSDDocumentItem = j.Posnr

    left outer join ZV_COSTINGPL_15                                                          as k  on  k.BillingDocument     = b.BillingDocument
                                                                                                   and k.BillingDocumentItem = b.BillingDocumentItem

    left outer join ZV_COSTINGPL_3                                                           as l  on l.AssignmentReference = a.BillingDocument

    left outer join ZV_COSTINGPL_4                                                           as m  on m.BillingDocument = a.BillingDocument

    left outer join ZV_COSTINGPL_5                                                           as n  on  n.BillingDocument     = a.BillingDocument
                                                                                                   and n.BillingDocumentItem = b.BillingDocumentItem

    left outer join ZV_COSTINGPL_11( p_begin: $parameters.p_begin, p_end: $parameters.p_end) as o  on  o.BillingDocument     = a.BillingDocument
                                                                                                   and o.BillingDocumentItem = b.BillingDocumentItem

    left outer join ZV_COSTINGPL_31                                                          as zz on zz.Product = b.Product

    left outer join ZV_COSTINGPL_27                                                          as z1 on  z1.AccountingDocument    = a.AccountingDocument
                                                                                                   and z1.FiscalYear            = a.FiscalYear
                                                                                                   and z1.CompanyCode           = a.CompanyCode
                                                                                                   and z1.ReferenceDocument     = b.BillingDocument
                                                                                                   and z1.ReferenceDocumentItem = b.BillingDocumentItem

    left outer join I_ProfitCenterText                                                       as z2 on  z2.ProfitCenter      = b.ProfitCenter
                                                                                                   and z2.Language          = $session.system_language
                                                                                                   and z2.ValidityEndDate   >= $session.system_date
                                                                                                   and z2.ValidityStartDate <= $session.user_date

    left outer join ZV_COSTINGPL_21( p_begin: $parameters.p_begin, p_end: $parameters.p_end) as z4 on  z4.BillingDocument     = b.BillingDocument
                                                                                                   and z4.BillingDocumentItem = b.BillingDocumentItem

    left outer join ZV_COSTINGPL_24                                                          as z5 on  z5.SalesOrder     = b.SalesDocument
                                                                                                   and z5.SalesOrderItem = b.SalesDocumentItem

    left outer join ZV_COSTINGPL_28                                                          as z6 on  z6.BillingDocument     = b.BillingDocument
                                                                                                   and z6.BillingDocumentItem = b.BillingDocumentItem

    left outer join I_SalesContractItem                                                      as z7 on  z7.SalesContract     = b.SalesDocument
                                                                                                   and z7.SalesContractItem = b.SalesDocumentItem

    left outer join ZV_COSTINGPL_34                                                          as z8 on z8.SalesContract = d.ReferenceSDDocument

    left outer join ZV_COSTINGPL_37                                                          as z9 on  z9.CustomerReturn     = b.BillingDocument
                                                                                                   and z9.CustomerReturnItem = b.BillingDocumentItem

{

  key cast( b.BillingDocument as abap.char(32) )                                                                as CommercialInvoiceNumber,
  key b.BillingDocumentItem                                                                                     as CommercialInvoiceItemNumber,
  key a.AccountingDocument                                                                                      as AccountingDocNo,
  key a.CompanyCode,
  key a.FiscalYear,
      cast( '' as abap.char(18) )                                                                               as AssignmentReference,
      a.CancelledBillingDocument,
      case
           when a.BillingDocumentType = 'G2'
           then cast('CN' as abap.char(10))
           when a.BillingDocumentType = 'L2'
           then cast('DN' as abap.char(10))
           when a.BillingDocumentType = 'CBRE'
           then cast('CN' as abap.char(10))
           when b.SDDocumentReason = 'Z01'
           then cast('Service' as abap.char(10))
           when b.SDDocumentReason = 'Z02'
           then cast('Service' as abap.char(10))
           when b.SDDocumentReason = 'Z03'
           then cast('Service' as abap.char(10))
           when a.DistributionChannel = 'EX'
           then cast('Export' as abap.char(10))
           when a.DistributionChannel = 'ME'
           then cast('Merchant' as abap.char(10))
           when a.DistributionChannel = 'DO'
           then cast('Domestic' as abap.char(10))
           else 'N/A'
           end                                                                                                  as InvoiceType,

      a.BillingDocumentDate,
      b.Plant,
      case when b.Division = 'PT' or b.ProductGroup = 'Z001' or b.SDDocumentReason = 'Z01' then 'X' else '' end as PatternInd,

      case b.Plant
      when '1100'
      then  cast('SALAP' as abap.char(10))
      when '1200'
      then  cast('KULGACHIA' as abap.char(10))
      when '1300'
      then  cast('BAGNAN' as abap.char(10))
      when '1400'
      then  cast('BARODA' as abap.char(10))
      when '1000'
      then  cast('KOLKATA HO' as abap.char(10))
      else 'N/A'
      end                                                                                                       as ShipmentLocation,

      a.SoldToParty                                                                                             as Customer,
      g.Shiptype                                                                                                as ShippingType,
      e.salesperson                                                                                             as ResponsibleEmployee,
      d.PurchaseOrderByCustomer                                                                                 as CustomerReferenceNumber,
      c.DeliveryDocument,
      c.DeliveryDocumentItem,
      i.ActualGoodsMovementDate                                                                                 as DeliveryDate,
      j.Delivery                                                                                                as PackingListNo,
      d.SalesDocument                                                                                           as SalesOrder,
      d.SalesDocumentItem                                                                                       as SalesOrderItem,
      h.SalesDocumentDate                                                                                       as SalesOrderDate,
      h.PriceDetnExchangeRate                                                                                   as ExchangeRateSalesOrder,
      b.Product,
      b.BillingDocumentItemText                                                                                 as ProductDescription,
      b.ProfitCenter,
      z2.ProfitCenterLongName,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      b.BillingQuantity,
      b.BillingQuantityUnit,
      a.TransactionCurrency,
      'INR'                                                                                                     as CompanyCodeCurrency,
      a.AccountingExchangeRate,
      o.NetDueDate,
      cast( o.CreditDays as abap.int4 )                                                                         as CreditDays,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      k.InvoiceAmount                                                                                           as ValueinDC,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      k.DiscAmount                                                                                              as Discount,
      //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( k.InvoiceAmount * a.AccountingExchangeRate   as abap.dec(25,2) )                                    as ValueinCC,
      //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( k.DiscAmount * a.AccountingExchangeRate   as abap.dec(25,2) )                                       as DiscountinCC,
      zz.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      zz.NetWeight                                                                                              as MaterialNetWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      cast( case when b.ItemNetWeight <> 0 then b.ItemNetWeight
           when zz.NetWeight > 0 then zz.NetWeight
           else 1 end as abap.quan( 13,3 ) )                                                                    as ItemNetWeight,
      m.TotalNetWeight,
      p.Currency,
      @Semantics.amount.currencyCode: 'Currency'
      p.StandardPrice,

      z1.GLAccount,
      z1.GLAccountName,

      case when z9.CustomerReturn is not initial then z9.CustomerReturn else b.SalesDocument end                as RefOrder,

      case when z8.ZRAW is not null and z8.ZRAW is not initial then z8.ZRAW else z5.ZRAW  end                   as MetalCostBM,

      cast( l.FumigationCharges * n.WeightRatio as abap.dec(31,2) )                                             as FumigationCharges,

      cast( l.ContainerFreight * n.WeightRatio as abap.dec(31,2) )                                              as ContainerFreight,

      cast( l.ExcelloDocumentPortCharges * n.WeightRatio as abap.dec(31,2) )                                    as ExcelloDocumentPortCharges,

      cast( l.THCCharges * n.WeightRatio as abap.dec(31,2) )                                                    as THCCharges,

      cast( l.RadiationChecking * n.WeightRatio as abap.dec(31,2) )                                             as RadiationChecking,

      cast( l.InspectionCharges * n.WeightRatio as abap.dec(31,2) )                                             as InspectionCharges,

      cast( l.FreightUSD * n.WeightRatio as abap.dec(31,2) )                                                    as FreightUSD,

      cast( l.ECGCPREMIUMRATE * n.WeightRatio as abap.dec(31,2) )                                               as ECGCPREMIUMRATE,

      cast( l.ShortRelisationCharges * n.WeightRatio as abap.dec(31,2) )                                        as ShortRelisationCharges,

      cast( o.CreditInterest as abap.dec(31,2) )                                                                as CreditPeriodCharges,

      cast( l.BankAdvCharges * n.WeightRatio as abap.dec(31,2) )                                                as BankAdvCharges,

      cast( l.CommissionCharges * n.WeightRatio as abap.dec(31,2) )                                             as CommissionCharges,

      cast( l.ClaimagainstDamagedMaterials * n.WeightRatio as abap.dec(31,2) )                                  as ClaimagainstDamagedMaterials,

      //cast( z4.VarianceperKg as abap.dec(31,2) )                                                                as VariancePerKg,

      cast( case when zz.NetWeight <> 0 then division( p.StandardPrice, zz.NetWeight, 0 ) - z4.VarianceperKg
       else 0 end  as abap.dec(31,2) )                                                                          as VariancePerKg,

      cast( z6.FreightRAmount as abap.dec(31,2) )                                                               as FreightreceivedAmount,

      cast( l.PatternSale * n.WeightRatio as abap.dec(31,2) )                                                   as PatternSale

}

where
        a.AccountingDocument         is not initial

  and   a.BillingDocumentIsCancelled = ''

  and   a.CancelledBillingDocument   = ''

  and(
        a.BillingDocumentDate        >= $parameters.p_begin
    and a.BillingDocumentDate        <= $parameters.p_end
  )


union select from I_OperationalAcctgDocItem as a

  inner join      I_JournalEntry            as c  on  c.AccountingDocument = a.AccountingDocument
                                                  and c.FiscalYear         = a.FiscalYear
                                                  and c.CompanyCode        = a.CompanyCode

  inner join      zdt_cost_glpl             as e  on  e.gl     = a.GLAccount
                                                  and e.gltype = 17

  inner join      I_GLAccountText           as z1 on  z1.Language  = $session.system_language
                                                  and z1.GLAccount = e.gl

  left outer join ZV_COSTINGPL_33           as f  on  f.AccountingDocument = a.AccountingDocument
                                                  and f.FiscalYear         = a.FiscalYear
                                                  and f.CompanyCode        = a.CompanyCode

  left outer join ZI_FI_DEBTOR_RPT_27       as b  on b.Customer = f.Customer

  left outer join ZV_COSTINGPL_26           as z3 on  z3.AccountingDocument = a.AccountingDocument
                                                  and z3.FiscalYear         = a.FiscalYear
                                                  and z3.CompanyCode        = a.CompanyCode

  left outer join I_ProfitCenterText        as z2 on  z2.ProfitCenter      = z3.ProfitCenter
                                                  and z2.Language          = $session.system_language
                                                  and z2.ValidityEndDate   >= $session.system_date
                                                  and z2.ValidityStartDate <= $session.user_date


{

  key cast( c.DocumentReferenceID as abap.char(32) )                                       as CommercialInvoiceNumber,
  key cast( '' as abap.numc(6) )                                                           as CommercialInvoiceItemNumber,
  key a.AccountingDocument                                                                 as AccountingDocNo,
  key a.CompanyCode,
  key a.FiscalYear,

      a.AssignmentReference                                                                as AssignmentReference,
      ''                                                                                   as CancelledBillingDocument,
      'Service'                                                                            as InvoiceType,

      a.PostingDate                                                                        as BillingDocumentDate,
      case
      when z3.ProfitCenter = '0000001100' or z3.ProfitCenter = '0000001101' or z3.ProfitCenter = '0000001102'
      or z3.ProfitCenter = '0000001103' or z3.ProfitCenter = '0000001104' then '1100'
      when z3.ProfitCenter = '0000001200' or z3.ProfitCenter = '0000001201' or z3.ProfitCenter = '0000001202'
      or z3.ProfitCenter = '0000001203' or z3.ProfitCenter = '0000001204'  then '1200'
      when z3.ProfitCenter = '0000001300' or z3.ProfitCenter = '0000001301' or z3.ProfitCenter = '0000001302'
      or z3.ProfitCenter = '0000001303' or z3.ProfitCenter = '0000001304'  then '1300'
      when z3.ProfitCenter = '0000001400' or z3.ProfitCenter = '0000001401' or z3.ProfitCenter = '0000001402'
      or z3.ProfitCenter = '0000001403' or z3.ProfitCenter = '0000001403'  then '1400' end as Plant,
      ''                                                                                   as PatternInd,
      'N/A'                                                                                as ShipmentLocation,

      f.Customer                                                                           as Customer,
      ''                                                                                   as ShippingType,
      b.salesperson                                                                        as ResponsibleEmployee,
      c.AlternativeReferenceDocument                                                       as CustomerReferenceNumber,
      ''                                                                                   as DeliveryDocument,
      cast( '' as abap.numc(6) )                                                           as DeliveryDocumentItem,
      ''                                                                                   as DeliveryDate,
      ''                                                                                   as PackingListNo,
      ''                                                                                   as SalesOrder,
      cast( '' as abap.numc(6) )                                                           as SalesOrderItem,
      ''                                                                                   as SalesOrderDate,
      cast( 0 as abap.dec(9,5) )                                                           as ExchangeRateSalesOrder,
      ''                                                                                   as Product,
      a.DocumentItemText                                                                   as ProductDescription,
      z3.ProfitCenter,
      z2.ProfitCenterLongName,
      cast( 0 as abap.quan( 13,3 ) )                                                       as BillingQuantity,
      cast( '' as abap.unit( 3 ) )                                                         as BillingQuantityUnit,
      a.TransactionCurrency,
      'INR'                                                                                as CompanyCodeCurrency,
      c.ExchangeRate                                                                       as AccountingExchangeRate,
      a.NetDueDate                                                                         as NetDueDate,
      cast( 0 as abap.int4 )                                                               as CreditDays,
      cast( a.AmountInTransactionCurrency * -1 as abap.dec(15,2) )                         as ValueinDC,
      cast( 0 as abap.dec(15,2) )                                                          as Discount,
      cast( a.AmountInCompanyCodeCurrency * -1 as abap.dec(25,2) )                         as ValueinCC,
      cast( 0    as abap.dec(25,2) )                                                       as DiscountinCC,
      cast( '' as abap.unit( 3 ) )                                                         as WeightUnit,
      cast( 0 as abap.quan( 13,3 ) )                                                       as MaterialNetWeight,
      cast( 0 as abap.quan( 13,3 ) )                                                       as ItemNetWeight,
      cast( 0 as abap.quan( 13,3 ) )                                                       as TotalNetWeight,
      cast( '' as abap.cuky( 5 ) )                                                         as Currency,
      cast( 0 as abap.dec( 15,2 ) )                                                        as StandardPrice,

      e.gl                                                                                 as GLAccount,
      z1.GLAccountName,

      cast( '' as vbeln_va )                                                               as RefOrder,

      cast( 0  as abap.dec( 21,2 ) )                                                       as MetalCostBM,

      cast( 0 as abap.dec(31,2) )                                                          as FumigationCharges,

      cast( 0 as abap.dec(31,2) )                                                          as ContainerFreight,

      cast( 0 as abap.dec(31,2) )                                                          as ExcelloDocumentPortCharges,

      cast( 0 as abap.dec(31,2) )                                                          as THCCharges,

      cast( 0 as abap.dec(31,2) )                                                          as RadiationChecking,

      cast( 0 as abap.dec(31,2) )                                                          as InspectionCharges,

      cast( 0 as abap.dec(31,2) )                                                          as FreightUSD,

      cast( 0 as abap.dec(31,2) )                                                          as ECGCPREMIUMRATE,

      cast( 0 as abap.dec(31,2) )                                                          as ShortRelisationCharges,

      cast( 0 as abap.dec(31,2) )                                                          as CreditPeriodCharges,

      cast( 0 as abap.dec(31,2) )                                                          as BankAdvCharges,

      cast( 0 as abap.dec(31,2) )                                                          as CommissionCharges,

      cast( 0 as abap.dec(31,2) )                                                          as ClaimagainstDamagedMaterials,

      cast( 0 as abap.dec(31,2) )                                                          as VariancePerKg,

      cast( 0 as abap.dec(31,2) )                                                          as FreightreceivedAmount,

      cast( 0 as abap.dec(31,2) )                                                          as PatternSale

}

where
  (
        c.PostingDate            >= $parameters.p_begin
    and c.PostingDate            <= $parameters.p_end
  )

  and   a.AccountingDocumentType != 'RV'
