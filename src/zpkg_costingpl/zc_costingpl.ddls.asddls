@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_COSTINGPL

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from ZV_COSTINGPL_25( p_begin: $parameters.p_begin, p_end: $parameters.p_end )
{

      @EndUserText.label: 'AR Invoice Number'
  key CommercialInvoiceNumber,
      @EndUserText.label: 'AR Invoice Item Number'
  key CommercialInvoiceItemNumber,
      @EndUserText.label: 'Accounting Doc. No.'
  key AccountingDocNo,
      @EndUserText.label: 'Company Code'
  key CompanyCode,
      @EndUserText.label: 'Fiscal Year'
  key FiscalYear,
      @EndUserText.label: 'Assignment Reference'
      AssignmentReference,
      @EndUserText.label: 'Invoice Type'
      InvoiceType,
      @EndUserText.label: 'Invoice Date'
      BillingDocumentDate,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Pattern Indicator'
      PatternInd,
      @EndUserText.label: 'Shipment Location'
      ShipmentLocation,
      @EndUserText.label: 'Customer'
      Customer,
      @EndUserText.label: 'Shipping Type'
      ShippingType,
      @EndUserText.label: 'Responsible Employee'
      ResponsibleEmployee,
      @EndUserText.label: 'Customer Reference Number'
      CustomerReferenceNumber,
      @EndUserText.label: 'Delivery Document'
      DeliveryDocument,
      @EndUserText.label: 'Delivery Document Item'
      DeliveryDocumentItem,
      @EndUserText.label: 'Delivery Date'
      DeliveryDate,
      @EndUserText.label: 'Packing List Number'
      PackingListNo,
      @EndUserText.label: 'Sales Order'
      SalesOrder,
      @EndUserText.label: 'Sales Order Item'
      SalesOrderItem,
      @EndUserText.label: 'Sales Order Date'
      SalesOrderDate,
      @EndUserText.label: 'SO Exchange Rate'
      ExchangeRateSalesOrder,
      @EndUserText.label: 'Product'
      Product,
      @EndUserText.label: 'Product Description'
      ProductDescription,
      @EndUserText.label: 'Profit Center'
      ProfitCenter,
      @EndUserText.label: 'Profit Center Desc.'
      ProfitCenterLongName,
      @EndUserText.label: 'Net Due Date'
      NetDueDate,
      @EndUserText.label: 'Credit Days'
      CreditDays,
      @EndUserText.label: 'GL Account'
      GLAccount,
      @EndUserText.label: 'GL Account Name'
      GLAccountName,
      @EndUserText.label: 'Reference/Return Order'
      RefOrder,
      @EndUserText.label: 'Invoice Quantity'
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantity,
      @EndUserText.label: 'UoM'
      BillingQuantityUnit,
      @EndUserText.label: 'Currency'
      TransactionCurrency,
      @EndUserText.label: 'Exchange Rate'
      AccountingExchangeRate,
      @EndUserText.label: 'Value(DC)'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ValueinDC,
      @EndUserText.label: 'Discount'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Discount,
      @EndUserText.label: 'Value(INR)'
      ValueinCC,
      @EndUserText.label: 'Discount(INR)'
      DiscountinCC,
      @EndUserText.label: 'Weight UoM'
      WeightUnit,
      @EndUserText.label: 'Material Net Weight'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      MaterialNetWeight,
      @EndUserText.label: 'Item Net Weight'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      ItemNetWeight,
      @EndUserText.label: 'Total Net Weight'
      TotalNetWeight,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Metal Cost BM'
      MetalCostBM,
      @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label: 'BOM Price'
      StandardPrice,
      @EndUserText.label: 'Fumigation Charges'
      FumigationCharges,
      @EndUserText.label: 'Container Freight'
      ContainerFreight,
      @EndUserText.label: 'Excello Doc Charges'
      ExcelloDocumentPortCharges,
      @EndUserText.label: 'TH Charges'
      THCCharges,
      @EndUserText.label: 'Radiation Checking'
      RadiationChecking,
      @EndUserText.label: 'Inspection Charges'
      InspectionCharges,
      @EndUserText.label: 'Freight Charges'
      FreightUSD,
      @EndUserText.label: 'ECG Premium Rate'
      ECGCPREMIUMRATE,
      @EndUserText.label: 'Short Realisation Charges'
      ShortRelisationCharges,
      @EndUserText.label: 'Credit Period Charges'
      CreditPeriodCharges,
      @EndUserText.label: 'Bank Adv Charges'
      BankAdvCharges,
      @EndUserText.label: 'Commission Charges'
      CommissionCharges,
      @EndUserText.label: 'Claim agsinst Damaged Materials'
      ClaimagainstDamagedMaterials,
      @EndUserText.label: 'Variance per Kg'
      VariancePerKg,
      @EndUserText.label: 'Freight Received Amount'
      FreightreceivedAmount,
      @EndUserText.label: 'Pattern Sale'
      PatternSale,
      @EndUserText.label: 'Std Cost of FG'
      TotalCost,
      @EndUserText.label: 'Total Selling Expense'
      TotalSellingExp,
      @EndUserText.label: 'Total Selling Expense per KG'
      case when ItemNetWeight <> 0 then
      coalesce( division( TotalSellingExp, cast( ItemNetWeight as abap.dec(15,3) ), 2 ), 0)
      else 0 end as SellingExpperKg,
      @EndUserText.label: 'Actual Cost per KG'
      case when ItemNetWeight <> 0 then
      case when InvoiceType <> 'CN' then TotalCost + cast( coalesce( division( TotalSellingExp, cast( ItemNetWeight as abap.dec(23,2) ), 2 ), 0 ) as abap.dec(31,2) )
      else ( TotalCost + cast( coalesce( division( TotalSellingExp, cast( ItemNetWeight as abap.dec(23,2) ), 2 ), 0 ) as abap.dec(31,2) ) ) * -1 end
      else
      case when InvoiceType <> 'CN' then TotalCost
      else TotalCost * -1 end
      end        as ActualCostperkg,
      @EndUserText.label: 'Order Value as per Order'
      ordervalueasperorder,
      @EndUserText.label: ' Sales Order Value/Kg '
      SalesOrderValueKg,
      @EndUserText.label: 'Realisation/Kg'
      case when ItemNetWeight <> 0 then
      case
      when InvoiceType <> 'CN' then ( ( TotalCost + coalesce( cast( division( TotalSellingExp, cast( ItemNetWeight as abap.dec(23,2) ), 2 ) as abap.dec(31,2) ), 0 ) ) - SalesOrderValueKg ) * -1
      else ( ( ( TotalCost + coalesce( cast( division( TotalSellingExp, cast( ItemNetWeight as abap.dec(23,2) ), 2 ) as abap.dec(31,2) ), 0 ) ) * -1 ) - SalesOrderValueKg ) * -1
      end
      else
      case when InvoiceType <> 'CN' then ( TotalCost - SalesOrderValueKg ) * -1
      else ( ( TotalCost * -1 ) - SalesOrderValueKg ) * -1 end
      end        as RealisationKg 
}
