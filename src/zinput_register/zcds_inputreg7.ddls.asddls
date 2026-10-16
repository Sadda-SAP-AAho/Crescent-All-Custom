@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZCDS_INPUTREG7
  as select distinct from ZCDS_INPUTREG3
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,
      BusinessArea,
      CompanyCodeName,
      ProfitCenter,
      Segment,
      Plant,
      DocumentDate,
      Month1,
      TransactionCurrency,
      GLAccount,
      GLAccountName,
      AccountingDocumentType,
      State,
      GSTIN,
      TransactionCount,
      Supplier,
      SupplierFullName,
      TaxNumber3,
      RegionName,
      ProductDescription,
      ConsumptionTaxCtrlCode,
      ConsumptionTaxCtrlCodeText1,
      BaseUnit,
      @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
      Quantity,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      AmountInTransactionCurrency,
      documentitemtext,
      PostingDate,
      Pos,
      ReferenceQuantityUnit,
      CGSTRate,
      SGSTRate,
      IGSTRate,
      Cess,
      Taxablevalue,
      Totalgstrate,
      CGSTValue,
      SGSTValue,
      IGSTValue,
      CessValue,
      Natureofsupply,
      Taxability,
      Supplyattractreverseharges,
      Itemcode,
      Category,
      SalepriceBeforediscount,
      Discount,
      Netsalepriceafterdiscount,
      Vat,
      CentralExcise,
      StateExcise,
      Natureofexpense,
      ShipFromState,
      ShipToState,
      WaybillNo,
      Transportername,
      LorryReceiptnumber,
      LorryReceiptdate,
      CDNoteOriginalInvoiceNo,
      
      CDOriginalInvoiceDate,
      ReasonforissuingDCNote,
      AssessablevaluebeforeBCD,
      BasicCustomDuty,
      PortCode,
      IsAdvanceAdjustment,
      AdvanceadjustmentInvoiceNo,
      AdvanceadjustmentInvoiceDate,
      IsAmendment,
      AmendmentOriginalYear,
      AmendmentOriginalMonth,
      AmendmentOriginalGSTINsupplier,
      AmendmentOriginalDocumentNo,
      AmendmentOriginalDocumentDate,
      IsISD,
      ISDLocationDetails,
      EligibilityofITC,
      case when EligibilityofITC = 'NO'
      then 0
      else
      CGSTValue end  as ITCCGSTAmt,
      case when EligibilityofITC = 'NO'
      then 0
      else
      SGSTValue end  as ITCSGSTAmt,
      case when EligibilityofITC = 'NO'
      then 0
      else
      IGSTValue end  as ITCIGSTAmt,
      case when EligibilityofITC = 'NO'
       then 0
       else
       CessValue end as ITCCessAmt,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      Taxableamount,
      SupplyType,
      TaxCode,
      vehicle
}
