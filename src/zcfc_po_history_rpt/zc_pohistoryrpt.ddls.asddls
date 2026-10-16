@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO History-Report'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_POHISTORYRPT
  provider contract transactional_query
  as projection on ZI_POHISTORYRPT
{
       @EndUserText.label: 'PO No'
       @Search.defaultSearchElement: true
  key  PurchaseOrder,

       @EndUserText.label: 'PO Type'
  key  POType,

       @EndUserText.label: 'Matl Code'
  key  Material,

       @EndUserText.label: 'Matl Group'
  key  matgrp,

       @EndUserText.label: 'Ref Doc'
       @Search.defaultSearchElement: true
  key  ReferenceDocument,

       @EndUserText.label: 'PO History Category'
       @Search.defaultSearchElement: true
  key  PurchasingHistoryCategory,

       @EndUserText.label: 'Matl Sl No'
  key  PurchaseOrderItem,

       @UI.hidden: true
  key  AccountAssignmentNumber,

       @UI.hidden: true
  key  PurchasingHistoryDocumentYear,

       @EndUserText.label: 'Matl Doc No'
       @Search.defaultSearchElement: true
  key  PurchasingHistoryDocument,

       @UI.hidden: true
  key  PurchasingHistoryDocumentItem,

       @UI.hidden: true
  key  PurchasingHistoryDocumentType,

       @EndUserText.label: 'Journal Entry No'
       AccountingDocument,

       @EndUserText.label: 'Our Referance'
       OurRef,
       
       @EndUserText.label: 'PO Item Text'
       POItemText,

       @EndUserText.label: 'Plant'
       Plant,

       @UI.hidden: true
       PurchaseOrderQuantityUnit,

       @EndUserText.label: 'Quantity'
       @Semantics.quantity.unitOfMeasure:'PurchaseOrderQuantityUnit'
       Quantity,

       @EndUserText.label: 'Posting Dt'
       PostingDate,

       @EndUserText.label: 'Doc Dt'
       DocumentDate,

       @EndUserText.label: 'Entry Dt'
       AccountingDocumentCreationDate,

       @EndUserText.label: 'Movement Type'
       GoodsMovementType,

       @UI.hidden: true
       Currency,

       @EndUserText.label: 'Doc Amount'
       @Semantics.amount.currencyCode: 'Currency'
       PurchaseOrderAmount,

       @UI.hidden: true
       DocumentCurrency,

       @UI.hidden: true
       CompanyCodeCurrency,

       @EndUserText.label: 'Amt in Local currency'
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       PurOrdAmountInCompanyCodeCrcy,

       @EndUserText.label: 'Dr/Cr'
       DebitCreditCode,

       @EndUserText.label: 'Inv Amt in DocCurrency'
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       Invamtpocurr,

       @EndUserText.label: 'Document Type'
       Document_Type
}
