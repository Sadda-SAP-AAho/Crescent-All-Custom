@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZV_COSTINGPL

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from ZV_COSTINGPL_1( p_begin:$parameters.p_begin , p_end:$parameters.p_end )
{
  key CommercialInvoiceNumber,
  key CommercialInvoiceItemNumber,
  key AccountingDocNo,
  key CompanyCode,
  key FiscalYear,
      AssignmentReference,
      InvoiceType,
      BillingDocumentDate,
      Plant,
      PatternInd,
      ShipmentLocation,
      Customer,
      ShippingType,
      ResponsibleEmployee,
      CustomerReferenceNumber,
      DeliveryDocument,
      DeliveryDocumentItem,
      DeliveryDate,
      PackingListNo,
      SalesOrder,
      SalesOrderItem,
      SalesOrderDate,
      ExchangeRateSalesOrder,
      Product,
      ProductDescription,
      ProfitCenter,
      ProfitCenterLongName,
      NetDueDate,
      CreditDays,
      GLAccount,
      GLAccountName,
      RefOrder,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      case when InvoiceType <> 'CN' then BillingQuantity else BillingQuantity * -1 end                            as BillingQuantity,
      BillingQuantityUnit,
      TransactionCurrency,
      AccountingExchangeRate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when InvoiceType <> 'CN' then ValueinDC else ValueinDC * -1 end                                        as ValueinDC,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when InvoiceType <> 'CN'  then Discount else Discount * -1 end                                         as Discount,
      case when InvoiceType <> 'CN'  then ValueinCC else ValueinCC * -1 end                                       as ValueinCC,
      case when InvoiceType <> 'CN'  then DiscountinCC else DiscountinCC * -1 end                                 as DiscountinCC,
      WeightUnit,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      cast( case when InvoiceType <> 'CN' then
      case when InvoiceType = 'DN' then 1 else MaterialNetWeight end
      else MaterialNetWeight * -1 end  as abap.dec(15,3) )                                                        as MaterialNetWeight,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      cast( case when InvoiceType <> 'CN'  then
      case when InvoiceType = 'DN' then 1 else ItemNetWeight end
      else ItemNetWeight * -1 end   as abap.dec(15,3) )                                                           as ItemNetWeight,

      cast( case when InvoiceType <> 'CN'  then
      case when InvoiceType = 'DN' then 1 else TotalNetWeight end
      else TotalNetWeight * -1 end  as abap.dec(15,3) )                                                           as TotalNetWeight,


      Currency,
      MetalCostBM,
      @Semantics.amount.currencyCode: 'Currency'
      cast( case
      when InvoiceType = 'CN' then StandardPrice * -1
      when InvoiceType = 'DN' then 0
      else StandardPrice end as abap.dec(15,2) )                                                                  as StandardPrice,
      case when InvoiceType <> 'CN'  then FumigationCharges else FumigationCharges * -1 end                       as FumigationCharges,
      case when InvoiceType <> 'CN'  then ContainerFreight else ContainerFreight * -1 end                         as ContainerFreight,
      case when InvoiceType <> 'CN'  then ExcelloDocumentPortCharges else ExcelloDocumentPortCharges * -1 end     as ExcelloDocumentPortCharges,
      case when InvoiceType <> 'CN'  then THCCharges else THCCharges * -1 end                                     as THCCharges,
      case when InvoiceType <> 'CN'  then RadiationChecking else RadiationChecking * -1 end                       as RadiationChecking,
      case when InvoiceType <> 'CN'  then InspectionCharges else InspectionCharges * -1 end                       as InspectionCharges,
      case when InvoiceType <> 'CN'  then FreightUSD else FreightUSD * -1 end                                     as FreightUSD,
      case when InvoiceType <> 'CN'  then ECGCPREMIUMRATE else ECGCPREMIUMRATE * -1 end                           as ECGCPREMIUMRATE,
      case when InvoiceType <> 'CN'  then ShortRelisationCharges else ShortRelisationCharges * -1 end             as ShortRelisationCharges,
      case when InvoiceType <> 'CN'  then CreditPeriodCharges else CreditPeriodCharges * -1 end                   as CreditPeriodCharges,
      case when InvoiceType <> 'CN'  then BankAdvCharges else BankAdvCharges * -1 end                             as BankAdvCharges,
      case when InvoiceType <> 'CN'  then CommissionCharges else CommissionCharges * -1 end                       as CommissionCharges,
      case when InvoiceType <> 'CN'  then ClaimagainstDamagedMaterials else ClaimagainstDamagedMaterials * -1 end as ClaimagainstDamagedMaterials,
      case when InvoiceType <> 'CN'  then VariancePerKg else VariancePerKg * -1 end                               as VariancePerKg,
      case when InvoiceType <> 'CN'  then FreightreceivedAmount else FreightreceivedAmount * -1 end               as FreightreceivedAmount,
      case when InvoiceType <> 'CN'  then PatternSale else PatternSale * -1 end                                   as PatternSale,

      cast( coalesce( ValueinCC, 0 ) + coalesce( DiscountinCC, 0 ) as abap.dec(23,2) )                            as ValueDiff
}
