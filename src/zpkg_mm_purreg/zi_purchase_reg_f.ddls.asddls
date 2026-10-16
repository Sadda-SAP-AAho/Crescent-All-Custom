@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_F
  with parameters
    P_PODateFrom : zde_date,
    P_PODateTo   : zde_date
  as select from ZI_PURCHASE_REG_2(
                    P_PODateFrom : $parameters.P_PODateFrom,
                    P_PODateTo   : $parameters.P_PODateTo )
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key PurchaseRequisition,
  key PurchaseRequisitionItem,
  key MaterialDocument,
  key MaterialDocumentItem,
  key MaterialDocumentYear,
  key SupplierInvoice,
  key SupplierInvoiceItem,
  key FiscalYear,
  key gatepass,
      Prplant,
      Prplantname,
      PurchaseReqnCreationDate,
      Prreldt,
      RequestedQuantity,
      Material,
      Plant,
      PlantName,
      PurchaseOrderItemText,
      PlainLongText,
      Supplier,
      SupplierFullName,
      PurchaseOrderDate,
      Poreldate,
      cast( '' as abap.char(200) ) as Prtext,
      OrderQuantity,
      UnitOfMeasure,
      UnitOfMeasureLongName,
      PostingDate,
      QuantityInEntryUnit,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency1'
      PurOrdAmountInCompanyCodeCrcy1,
      CompanyCodeCurrency1,
      YY1_GateEntryNumber_MMI,
      gateentrydate,
      YY1_ChallanQuantity_MMI,
      InspectionCodeText,
      byhand,
      YY1_VehicleNumber_MMI,
      transportername,
      drivername,
      YY1_TareWeight_MMI,
      unitwt,
      YY1_GrossWeight_MMI,
      YY1_NetWeight_MMI,
      chkindt,
      chkintm,
      chkoutdt,
      chkouttm,
      GLAccount,
      GLAccountLongName,
      ProjectElement,
      ProjectElementDescription,
      condtype,
      invpostdt,
      SupplierInvoiceIDByInvcgParty,
      DocumentDate,
      TaxCode,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      igst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cgst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sgst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ( cgst + sgst + igst )       as gst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      PurOrdAmountInCompanyCodeCrcy,
      CompanyCodeCurrency,
      PaymentTerms,
      DueCalculationBaseDate
}
