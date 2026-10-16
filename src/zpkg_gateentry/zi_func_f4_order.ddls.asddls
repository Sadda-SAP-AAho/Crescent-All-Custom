@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Table Function for Order F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FUNC_F4_Order
  as select from I_SchedgagrmthdrApi01
{
  SchedulingAgreement,
  CompanyCode,
  PurchasingDocumentCategory,
  PurchasingDocumentType,
  PurchasingDocumentTypeName,
  CreatedByUser,
  CreationDate,
  Language,
  PurchasingOrganization,
  PurchasingGroup,
  DocumentCurrency,
  IncotermsClassification,
  IncotermsTransferLocation,
  PaymentTerms,
  CashDiscount1Days,
  CashDiscount2Days,
  CashDiscount1Percent,
  CashDiscount2Percent,
  NetPaymentDays,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  TargetAmount,
  ExchangeRate,
  ExchangeRateIsFixed,
  IncotermsLocation1,
  IncotermsLocation2,
  IncotermsVersion,
  PurchasingDocumentOrderDate,
  ScheduleAgreementHasReleaseDoc,
  Supplier,
  SupplierAddressID,
  ValidityStartDate,
  ValidityEndDate,
  PurchasingDocumentOrigin,
  PurchasingDocumentDeletionCode,
  QuotationSubmissionDate,
  SupplierQuotationExternalID,
  SupplierRespSalesPersonName,
  SupplierPhoneNumber,
  InvoicingParty,
  SupplyingSupplier,
  CompanyVATRegistration,
  VATRegistrationCountry,
  LastChangeDateTime
};
