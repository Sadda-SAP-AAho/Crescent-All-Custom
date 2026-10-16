@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Billingdocumentitem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_i_billingdocumentitem as select from I_BillingDocumentItem
{

  key BillingDocument,

  key BillingDocumentItem,

      SalesDocumentItemCategory,

      SalesDocumentItemType,

      ReturnItemProcessingType,

      CreatedByUser,

      CreationDate,

      CreationTime,

      ReferenceLogicalSystem,

      OrganizationDivision,

      Division,

      SalesOffice,

      Material,

      Product,
      OriginallyRequestedMaterial,

      InternationalArticleNumber,

      PricingReferenceMaterial,

      Batch,

      ProductHierarchyNode,

      MaterialGroup,

      ProductGroup,

      AdditionalMaterialGroup1,

      AdditionalMaterialGroup2,

      AdditionalMaterialGroup3,


      AdditionalMaterialGroup4,


      AdditionalMaterialGroup5,

      ProductConfiguration,


      MaterialCommissionGroup,

   
      Plant,


      StorageLocation,

      ReplacementPartType,
      MaterialGroupHierarchy1,
      MaterialGroupHierarchy2,

      PlantRegion,

      PlantCounty,
      PlantCity,

      TransitPlant,

      ValueChainCategory,

      // ValueChainInstanceUUID,
      BOMExplosion,
      MaterialDeterminationType,

      SoldProduct,

      BillingDocumentItemText,

      ServicesRenderedDate,
     @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantity,

      BillingQuantityUnit,
     @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantityInBaseUnit,

      BaseUnit,
     @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      MRPRequiredQuantityInBaseUnit,

      BillingToBaseQuantityDnmntr,
      BillingToBaseQuantityNmrtr,
     @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      ItemGrossWeight,
     @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      ItemNetWeight,


//      @Semantics.unitOfMeasure: true
      ItemWeightUnit,

      @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
      ItemVolume,


//      @Semantics.unitOfMeasure: true
      ItemVolumeUnit,

      BillToPartyCountry,


      BillToPartyRegion,


      BillingPlanRule,

      BillingPlan,
      BillingPlanItem,


      DownPaymentProcessingVariant,

      // Pricing
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      NetAmount,



      TransactionCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      GrossAmount,

      PricingDate,
      PriceDetnExchangeRate,

     @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
//      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      PricingScaleQuantityInBaseUnit,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      CostAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Subtotal1Amount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Subtotal2Amount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Subtotal3Amount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Subtotal4Amount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Subtotal5Amount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Subtotal6Amount,


      StatisticalValueControl,

      CashDiscountIsDeductible,
      CustomerConditionGroup1,
      CustomerConditionGroup2,
      CustomerConditionGroup3,
      CustomerConditionGroup4,
      CustomerConditionGroup5,
      ManualPriceChangeType,


      MaterialPricingGroup,

      StatisticsExchangeRate,


      MainItemPricingRefMaterial,


      MainItemMaterialPricingGroup,


      TimeSheetOvertimeCategory,


      PricingRelevance,

      DepartureCountry,

      TaxJurisdiction,
      ProductTaxClassification1,
      ProductTaxClassification2,
      ProductTaxClassification3,
      ProductTaxClassification4,
      ProductTaxClassification5,
      ProductTaxClassification6,
      ProductTaxClassification7,
      ProductTaxClassification8,
      ProductTaxClassification9,
      ZeroVATRsn,
      TaxCode,
      TaxRateValidityStartDate,


      CountryOfOrigin,

      RegionOfOrigin,

      CommodityCode,

      // Payment
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      EligibleAmountForCashDiscount,


      BusinessArea,


      ProfitCenter,

      OrderID,

     
      WBSElement,


      WBSElementInternalID,


      ProviderContract,


      ProviderContractItem,


      BillingPerformancePeriodStrDte,

      BillingPeriodOfPerfStartDate,


      BillingPerformancePeriodEndDte,

      BillingPeriodOfPerfEndDate,


      ControllingArea,

//      @API.element: { releaseState: #DECOMMISSIONED, successor: 'ProfitabilitySegment_2' }
//      cast(case when ProfitabilitySegment_2 > '9999999999' then '9999999999' else lpad(ProfitabilitySegment_2, 10, '0') end as rkeobjnr_numc)
//                                                                                                                        as ProfitabilitySegment,

      ProfitabilitySegment_2,


      CostCenter,

      OriginSDDocument,
      OriginSDDocumentItem,
      PriceDetnExchangeRateDate,


      MatlAccountAssignmentGroup,

      // Reference
      ReferenceSDDocument,
      ReferenceSDDocumentItem,


      ReferenceSDDocumentCategory,

 
      SalesDocument,


      SalesDocumentItem,

   
      SalesSDDocumentCategory,


      HigherLevelItem,


      HigherLvlItmOfBatSpltItm,

      BillingDocumentItemInPartSgmt,
      ExternalReferenceDocument,

      ExternalReferenceDocumentItem,

      BillingDocExtReferenceDocItem,


      PrelimBillingDocument,


      PrelimBillingDocumentItem,


      SalesGroup,


      AdditionalCustomerGroup1,


      AdditionalCustomerGroup2,


      AdditionalCustomerGroup3,


      AdditionalCustomerGroup4,

      AdditionalCustomerGroup5,


      SDDocumentReason,


      RetailPromotion,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      RebateBasisAmount,

      VolumeRebateGroup,
      ItemIsRelevantForCredit,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      CreditRelatedPrice,


      SalesDeal,

      SalesPromotion,


      SalesOrderSalesDistrict,

  
      SalesOrderCustomerGroup,

   
      SalesOrderCustomerPriceGroup,


      SalesOrderPriceListType,


      SalesOrderSalesOrganization,


      SalesOrderDistributionChannel,

      SalesDocIsCreatedFromReference,

 
      ShippingPoint,

  
      ServiceDocumentType,

      ServiceDocument,
      ServiceDocumentItem,

      // Solution Order
      BusinessSolutionOrder,
      BusinessSolutionOrderItem,

      // Other fields
      HigherLevelItemUsage,
      BillingDocumentIsTemporary,

      SDDocumentCategory,

      BillingDocumentType,

      SalesOrganization,


      DistributionChannel,


      CustomerPriceGroup,

  
      CustomerGroup,


      Country,


      Region,

      CityCode,

      SalesDistrict,

      OverallSDProcessStatus,

      OverallBillingStatus,


      SoldToParty,


      PayerParty,

      BillingDocumentDate,


      CompanyCode,


      County,

      CustomerRebateAgreement,


      BillingDocumentCategory,

      PricingDocument,


      CancelledBillingDocument,


      ShipToParty,


      BillToParty,


      SalesEmployee,

      ResponsibleEmployee
      
      }
