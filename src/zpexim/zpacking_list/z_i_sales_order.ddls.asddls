@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity Z_I_Sales_order   as select from I_SalesDocument as SalesDocument
  //Associations

  //--[ GENERATED:012:E6ExH29r7kY4iE3VJ}6T4m
  association [0..*] to I_BusinessAreaText          as _BusinessAreaText           on  $projection.BusinessArea = _BusinessAreaText.BusinessArea
  association [0..*] to I_BusinessAreaText          as _CostCenterBusinessAreaText on  $projection.CostCenterBusinessArea = _CostCenterBusinessAreaText.BusinessArea
  association [0..*] to I_CreditControlAreaText     as _CreditControlAreaText      on  $projection.CreditControlArea = _CreditControlAreaText.CreditControlArea
  // ]--GENERATED
  association [0..*] to I_SalesOrderItem            as _Item                       on  $projection.SalesOrder = _Item.SalesOrder
  association [0..1] to I_SalesOrderType            as _SalesOrderType             on  $projection.SalesOrderType = _SalesOrderType.SalesOrderType
  association [1..*] to I_SalesOrderPartner         as _Partner                    on  $projection.SalesOrder = _Partner.SalesOrder
  association [0..*] to I_SalesOrderPricingElement  as _PricingElement             on  $projection.SalesOrder = _PricingElement.SalesOrder

  association [0..1] to I_SalesOrderBillingPlan     as _BillingPlan                on  $projection.SalesOrder  = _BillingPlan.SalesOrder
                                                                                   and $projection.BillingPlan = _BillingPlan.BillingPlan

  association [0..1] to I_SalesOrderApprovalReason  as _SalesOrderApprovalReason   on  $projection.SalesOrderApprovalReason = _SalesOrderApprovalReason.SalesOrderApprovalReason

  association [0..*] to I_SalesOrderPrecdgProcFlow  as _PrecedingProcFlowDoc       on  _PrecedingProcFlowDoc.SalesOrder = $projection.SalesOrder

  association [0..*] to I_SalesOrderSubsqntProcFlow as _SubsequentProcFlowDoc      on  _SubsequentProcFlowDoc.SalesOrder = $projection.SalesOrder

  //Extensibility
  association [0..1] to E_SalesDocumentBasic        as _Extension                  on  SalesDocument.SalesDocument = _Extension.SalesDocument

{
      //Key
  key cast(SalesDocument as abap.char(10))        as SalesOrder,

      //Category
      @ObjectModel.foreignKey.association: '_SalesOrderType'
      cast( SalesDocumentType as abap.char(10)) as SalesOrderType,
      SalesDocumentProcessingType                                   as SalesOrderProcessingType,

      //Admin
      CreatedByUser,
      LastChangedByUser,
//      @Semantics.systemDate.createdAt: true
      CreationDate,
//      @Semantics.systemTime.createdAt: true
      CreationTime,
//      @Semantics.systemDate.lastChangedAt: true
      LastChangeDate,
//      @Semantics.systemDateTime.lastChangedAt: true
      LastChangeDateTime,
      SenderBusinessSystemName,
      ExternalDocumentID,
      ExternalDocLastChangeDateTime,

      // Organization
      @ObjectModel.foreignKey.association: '_SalesOrganization'
      SalesOrganization,
      @ObjectModel.foreignKey.association: '_DistributionChannel'
      DistributionChannel,
      @ObjectModel.foreignKey.association: '_OrganizationDivision'
      OrganizationDivision,
      @ObjectModel.foreignKey.association: '_SalesGroup'
      SalesGroup,
      @ObjectModel.foreignKey.association: '_SalesOffice'
      SalesOffice,

      //Sales
      //--[ GENERATED:012:E6ExH29r7kY4iE3VJ}6T4m
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_Customer_VH',
                     element: 'Customer' }
        }]
      // ]--GENERATED
      @ObjectModel.foreignKey.association: '_SoldToParty'
      SoldToParty,
      @ObjectModel.foreignKey.association: '_CustomerGroup'
      CustomerGroup,
      @ObjectModel.foreignKey.association: '_AdditionalCustomerGroup1'
      AdditionalCustomerGroup1,
      @ObjectModel.foreignKey.association: '_AdditionalCustomerGroup2'
      AdditionalCustomerGroup2,
      @ObjectModel.foreignKey.association: '_AdditionalCustomerGroup3'
      AdditionalCustomerGroup3,
      @ObjectModel.foreignKey.association: '_AdditionalCustomerGroup4'
      AdditionalCustomerGroup4,
      @ObjectModel.foreignKey.association: '_AdditionalCustomerGroup5'
      AdditionalCustomerGroup5,
      SlsDocIsRlvtForProofOfDeliv,
      //--[ GENERATED:012:E6ExH29r7kY4iE3VJ}6T4m
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_CreditControlAreaStdVH',
                     element: 'CreditControlArea' }
        }]
      @ObjectModel.text.association: '_CreditControlAreaText'
      // ]--GENERATED
      @ObjectModel.foreignKey.association: '_CreditControlArea'
      CreditControlArea,
      CustomerRebateAgreement,
      SalesDocumentDate                                             as SalesOrderDate,
      ServicesRenderedDate,
      @ObjectModel.foreignKey.association: '_SDDocumentReason'
      SDDocumentReason,
      PurchaseOrderByCustomer,
      PurchaseOrderByShipToParty,
      SDDocumentCollectiveNumber,
      @ObjectModel.foreignKey.association: '_CustomerPurchaseOrderType'
      CustomerPurchaseOrderType,
      CustomerPurchaseOrderDate,
      CustomerPurchaseOrderSuplmnt,
      @ObjectModel.foreignKey.association: '_SalesDistrict'
      SalesDistrict,
//      @Semantics.currencyCode: true
//      @ObjectModel.foreignKey.association: '_StatisticsCurrency'
//      StatisticsCurrency,
      ProductCatalog,
      NextCreditCheckDate,
      LastCustomerContactDate,

      //Pricing
      @DefaultAggregation: #SUM
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      TotalNetAmount,
//      @Semantics.currencyCode: true
//      @ObjectModel.foreignKey.association: '_TransactionCurrency'
//      TransactionCurrency,
      PricingDate,
      PriceDetnExchangeRate,
      RetailPromotion,
      SalesDocumentCondition                                        as SalesOrderCondition,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_SDPricingProcedure'
      SDPricingProcedure,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CustomerPriceGroup'
      CustomerPriceGroup,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_PriceListType'
      PriceListType,

      BillingPlan,

      CustomerTaxClassification1,
      CustomerTaxClassification2,
      CustomerTaxClassification3,
      CustomerTaxClassification4,
      CustomerTaxClassification5,
      CustomerTaxClassification6,
      CustomerTaxClassification7,
      CustomerTaxClassification8,
      CustomerTaxClassification9,

      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_TaxDepartureCountry'
      TaxDepartureCountry,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_VATRegistrationCountry'
      VATRegistrationCountry,

      //Shipping
      RequestedDeliveryDate,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_DeliveryDateTypeRule'
      DeliveryDateTypeRule,
      @ObjectModel.foreignKey.association: '_ShippingType'
      ShippingType,
      @ObjectModel.foreignKey.association: '_ShippingCondition'
      ShippingCondition,
      ReceivingPoint,
      @ObjectModel.foreignKey.association: '_IncotermsClassification'
      IncotermsClassification,
      IncotermsTransferLocation,
      IncotermsLocation1,
      IncotermsLocation2,
      @ObjectModel.foreignKey.association: '_IncotermsVersion'
      IncotermsVersion,
      CompleteDeliveryIsDefined,
      OrderCombinationIsAllowed,
      @ObjectModel.foreignKey.association: '_DeliveryBlockReason'
      DeliveryBlockReason,

      //Fashion
      FashionCancelDate,

      //Approval Management
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_SalesOrderApprovalReason'
      SalesDocApprovalReason                                        as SalesOrderApprovalReason,

      //Billing
      BillingDocumentDate,
      //--[ GENERATED:012:E6ExH29r7kY4iE3VJ}6T4m
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_CompanyCodeStdVH',
                     element: 'CompanyCode' }
        }]
      // ]--GENERATED
      @ObjectModel.foreignKey.association: '_BillingCompanyCode'
      BillingCompanyCode,
      @ObjectModel.foreignKey.association: '_HeaderBillingBlockReason'
      HeaderBillingBlockReason,

      //Payment
      @ObjectModel.foreignKey.association: '_CustomerPaymentTerms'
      CustomerPaymentTerms,
      PaymentMethod,
      FixedValueDate,

      //Accounting
      FiscalYear,
      FiscalPeriod,
      ExchangeRateDate,
      @ObjectModel.foreignKey.association: '_ExchangeRateType'
      ExchangeRateType,
      AccountingExchangeRate,
      //--[ GENERATED:012:E6ExH29r7kY4iE3VJ}6T4m
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_BusinessAreaStdVH',
                     element: 'BusinessArea' }
        }]
      @ObjectModel.text.association: '_BusinessAreaText'
      // ]--GENERATED
      @ObjectModel.foreignKey.association: '_BusinessArea'
      BusinessArea,
      @ObjectModel.foreignKey.association: '_CustomerAccountAssgmtGroup'
      CustomerAccountAssignmentGroup,
      //--[ GENERATED:012:E6ExH29r7kY4iE3VJ}6T4m
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_BusinessAreaStdVH',
                     element: 'BusinessArea' }
        }]
      @ObjectModel.text.association: '_CostCenterBusinessAreaText'
      // ]--GENERATED
      @ObjectModel.foreignKey.association: '_CostCenterBusinessArea'
      CostCenterBusinessArea,
      CostCenter,
      //--[ GENERATED:012:E6ExH29r7kY4iE3VJ}6T4m
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_ControllingAreaStdVH',
                     element: 'ControllingArea' }
        }]
      // ]--GENERATED
      @ObjectModel.foreignKey.association: '_ControllingArea'
      ControllingArea,
      OrderID,
      //--[ GENERATED:012:E6ExH29r7kY4iE3VJ}6T4m
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_ControllingObjectStdVH',
                     element: 'ControllingObject' }
        }]
      // ]--GENERATED
      @ObjectModel.foreignKey.association: '_ControllingObject'
      ControllingObject,
      AssignmentReference,
      PaymentPlan,
      ContractAccount,
      AdditionalValueDays,

      //Credit Block
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_CustomerCreditAccount'
      CustomerCreditAccount,

      //Reference
      ReferenceSDDocument,
      @ObjectModel.foreignKey.association: '_ReferenceSDDocumentCategory'
      ReferenceSDDocumentCategory,
      CorrespncExternalReference,
      CorrespncExtRefByShipToParty,
      @Analytics.internalName: #LOCAL
      AccountingDocExternalReference,

//      @Analytics.internalName: #LOCAL
//      @Consumption.valueHelpDefinition: [
//       { entity:  { name:    'I_BusinessSolutionOrderStdVH',
//                    element: 'BusinessSolutionOrder' }
//       }]
//      @ObjectModel.foreignKey.association: '_SolutionOrder'
      BusinessSolutionOrder,

      SlsContrAutoAssgmtIDForSlsOrd,

      //Status
      @ObjectModel.foreignKey.association: '_OverallSDProcessStatus'
      OverallSDProcessStatus,
      @ObjectModel.foreignKey.association: '_OverallPurchaseConfStatus'
      OverallPurchaseConfStatus,
      @ObjectModel.foreignKey.association: '_OverallSDDocumentRejectionSts'
      OverallSDDocumentRejectionSts,
      @ObjectModel.foreignKey.association: '_TotalBlockStatus'
      TotalBlockStatus,
      @ObjectModel.foreignKey.association: '_OverallDelivConfStatus'
      OverallDelivConfStatus,
      @ObjectModel.foreignKey.association: '_OverallTotalDeliveryStatus'
      OverallTotalDeliveryStatus,
      @ObjectModel.foreignKey.association: '_OverallDeliveryStatus'
      OverallDeliveryStatus,
      @ObjectModel.foreignKey.association: '_OverallDeliveryBlockStatus'
      OverallDeliveryBlockStatus,
      @ObjectModel.foreignKey.association: '_OverallOrdReltdBillgStatus'
      OverallOrdReltdBillgStatus,
      @ObjectModel.foreignKey.association: '_OverallBillingBlockStatus'
      OverallBillingBlockStatus,
      @ObjectModel.foreignKey.association: '_OverallTotalSDDocRefStatus'
      OverallTotalSDDocRefStatus,
      @ObjectModel.foreignKey.association: '_OverallSDDocReferenceStatus'
      OverallSDDocReferenceStatus,
      @ObjectModel.foreignKey.association: '_TotalCreditCheckStatus'
      TotalCreditCheckStatus,
      @ObjectModel.foreignKey.association: '_MaxDocValueCreditCheckStatus'
      MaxDocValueCreditCheckStatus,
      @ObjectModel.foreignKey.association: '_PaymentTermCreditCheckStatus'
      PaymentTermCreditCheckStatus,
      @ObjectModel.foreignKey.association: '_FinDocCreditCheckStatus'
      FinDocCreditCheckStatus,
      @ObjectModel.foreignKey.association: '_ExprtInsurCreditCheckStatus'
      ExprtInsurCreditCheckStatus,
      @ObjectModel.foreignKey.association: '_PaytAuthsnCreditCheckSts'
      PaytAuthsnCreditCheckSts,
      @ObjectModel.foreignKey.association: '_CentralCreditCheckStatus'
      CentralCreditCheckStatus,
      @ObjectModel.foreignKey.association: '_CentralCreditChkTechErrSts'
      CentralCreditChkTechErrSts,
      @ObjectModel.foreignKey.association: '_HdrGeneralIncompletionStatus'
      HdrGeneralIncompletionStatus,
      @ObjectModel.foreignKey.association: '_OverallPricingIncompletionSts'
      OverallPricingIncompletionSts,
      @ObjectModel.foreignKey.association: '_HeaderDelivIncompletionStatus'
      HeaderDelivIncompletionStatus,
      @ObjectModel.foreignKey.association: '_HeaderBillgIncompletionStatus'
      HeaderBillgIncompletionStatus,
      @ObjectModel.foreignKey.association: '_OvrlItmGeneralIncompletionSts'
      OvrlItmGeneralIncompletionSts,
      @ObjectModel.foreignKey.association: '_OvrlItmBillingIncompletionSts'
      OvrlItmBillingIncompletionSts,
      @ObjectModel.foreignKey.association: '_OvrlItmDelivIncompletionSts'
      OvrlItmDelivIncompletionSts,
      @Analytics.internalName: #LOCAL
//      @ObjectModel.foreignKey.association: '_OverallChmlCmplncStatus'
//      OverallChmlCmplncStatus,
//      @Analytics.internalName: #LOCAL
//      @ObjectModel.foreignKey.association: '_OverallDangerousGoodsStatus'
//      OverallDangerousGoodsStatus,
//      @Analytics.internalName: #LOCAL
//      @ObjectModel.foreignKey.association: '_OvrlSftyDataSheetSts'
//      OverallSafetyDataSheetStatus,
      @ObjectModel.foreignKey.association: '_SalesDocApprovalStatus'
      SalesDocApprovalStatus,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_OvrlTradeCmplncEmbargoStatus'
      OverallTrdCmplncEmbargoSts,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_OvTrdCmplncSnctndListChkSts'
      OvrlTrdCmplncSnctndListChkSts,
      @Analytics.internalName: #LOCAL
      @ObjectModel.foreignKey.association: '_OvrlTrdCmplncLegalCtrlChkSts'
      OvrlTrdCmplncLegalCtrlChkSts,
//      @ObjectModel.foreignKey.association: '_DownPaymentStatus'
//      ContractDownPaymentStatus                                     as SalesOrderDownPaymentStatus,
//      @ObjectModel.foreignKey.association: '_OmniChnlSalesPromotionStatus'
//      OmniChnlSalesPromotionStatus,
//      AlternativePricingDate,
//      IsEUTriangularDeal,

      //Associations
//      @ObjectModel.association.type: [#TO_COMPOSITION_CHILD]
//      _Item,
//      @ObjectModel.association.type: [#TO_COMPOSITION_CHILD]
//      _Partner,
////      _StandardPartner,
//      @ObjectModel.association.type: [#TO_COMPOSITION_CHILD]
//      _PricingElement,
      _BillingPlan,
      _SDPricingProcedure,
      _CustomerPriceGroup,
      _PriceListType,
      _SalesOrderType,
      _CreatedByUser,
      _LastChangedByUser,
      _SalesOrganization,
      _DistributionChannel,
      _OrganizationDivision,
      _SalesGroup,
      _SalesOffice,
      _SoldToParty,
      _CustomerGroup,
      _AdditionalCustomerGroup1,
      _AdditionalCustomerGroup2,
      _AdditionalCustomerGroup3,
      _AdditionalCustomerGroup4,
      _AdditionalCustomerGroup5,
      _CreditControlArea,
      _SDDocumentReason,
      _CustomerPurchaseOrderType,
      _SalesDistrict,
//      _TransactionCurrency,
//      _StatisticsCurrency,
      _ShippingType,
      _ShippingCondition,
      _IncotermsClassification,
      _IncotermsVersion,
      _DeliveryBlockReason,
      _DeliveryDateTypeRule,
      _BillingCompanyCode,
      _HeaderBillingBlockReason,
      _SalesOrderApprovalReason,
      _CustomerPaymentTerms,
      _ExchangeRateType,
      _BusinessArea,
      _CustomerAccountAssgmtGroup,
      _CostCenterBusinessArea,
      _CostCenter,
      _ControllingArea,
      _ControllingObject,
      _CustomerCreditAccount,
      _ReferenceSDDocumentCategory,
      _SolutionOrder,
      //Status
      _OverallSDProcessStatus,
      _OverallPurchaseConfStatus,
      _OverallSDDocumentRejectionSts,
      _TotalBlockStatus,
      _OverallDelivConfStatus,
      _OverallTotalDeliveryStatus,
      _OverallDeliveryStatus,
      _OverallDeliveryBlockStatus,
      _OverallOrdReltdBillgStatus,
      _OverallBillingBlockStatus,
      _OverallTotalSDDocRefStatus,
      _OverallSDDocReferenceStatus,
      _TotalCreditCheckStatus,
      _MaxDocValueCreditCheckStatus,
      _PaymentTermCreditCheckStatus,
      _FinDocCreditCheckStatus,
      _ExprtInsurCreditCheckStatus,
      _PaytAuthsnCreditCheckSts,
      _CentralCreditCheckStatus,
      _CentralCreditChkTechErrSts,
      _HdrGeneralIncompletionStatus,
      _OverallPricingIncompletionSts,
      _HeaderDelivIncompletionStatus,
      _HeaderBillgIncompletionStatus,
      _OvrlItmGeneralIncompletionSts,
      _OvrlItmBillingIncompletionSts,
      _OvrlItmDelivIncompletionSts,
//      _OverallChmlCmplncStatus,
//      _OverallDangerousGoodsStatus,
//      _OvrlSftyDataSheetSts,
      _SalesDocApprovalStatus,
      _OvrlTradeCmplncEmbargoStatus,
      _OvTrdCmplncSnctndListChkSts,
      _OvrlTrdCmplncLegalCtrlChkSts,
//      _OmniChnlSalesPromotionStatus,
//      _DownPaymentStatus,
//      _EngagementProjectItem,
      //--[ GENERATED:012:E6ExH29r7kY4iE3VJ}6T4m
      @Consumption.hidden: true
      _BusinessAreaText,
      @Consumption.hidden: true
      _CostCenterBusinessAreaText,
      @Consumption.hidden: true
      _CreditControlAreaText,
      // ]--GENERATED
      _TaxDepartureCountry,
      _VATRegistrationCountry,
      _PrecedingProcFlowDoc,
      _SubsequentProcFlowDoc
}
where
  SalesDocument.SDDocumentCategory = 'C';

