@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Requisition Item Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASE_REG_PR_TEXT
  with parameters
    P_PODateFrom : zde_date,
    P_PODateTo   : zde_date
  as select from    ZI_PURCHASE_REG_F(
                       P_PODateFrom : $parameters.P_PODateFrom,
                       P_PODateTo   : $parameters.P_PODateTo ) as _head
    left outer join I_PurchaseRequisitionItemAPI01             as _Text on  _head.PurchaseRequisition     = _Text.PurchaseRequisition
                                                                        and _head.PurchaseRequisitionItem = _Text.PurchaseRequisitionItem
{
  key _head.PurchaseOrder,
  key _head.PurchaseOrderItem,
  key _head.PurchaseRequisition,
  key _head.PurchaseRequisitionItem,
  key _head.MaterialDocument,
  key _head.MaterialDocumentItem,
  key _head.MaterialDocumentYear,
  key _head.SupplierInvoice,
  key _head.SupplierInvoiceItem,
  key _head.FiscalYear,
  key _head.gatepass,
      _head.Prplant,
      _head.Prplantname,
      _head.PurchaseReqnCreationDate,
      _head.Prreldt,
      _head.RequestedQuantity,
      _head.Material,
      _head.Plant,
      _head.PlantName,
      _head.PurchaseOrderItemText,
      _head.PlainLongText,
      _head.Supplier,
      _head.SupplierFullName,
      _head.PurchaseOrderDate,
      _head.Poreldate,
      _head.OrderQuantity,
      _head.UnitOfMeasure,
      _head.UnitOfMeasureLongName,
      _head.PostingDate,
      _head.QuantityInEntryUnit,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency1'
      _head.PurOrdAmountInCompanyCodeCrcy1,
      _head.CompanyCodeCurrency1,
      _head.YY1_GateEntryNumber_MMI,
      _head.gateentrydate,
      _head.YY1_ChallanQuantity_MMI,
      _head.InspectionCodeText,
      _head.byhand,
      _head.YY1_VehicleNumber_MMI,
      _head.transportername,
      _head.drivername,
      _head.YY1_TareWeight_MMI,
      _head.unitwt,
      _head.YY1_GrossWeight_MMI,
      _head.YY1_NetWeight_MMI,
      _head.chkindt,
      _head.chkintm,
      _head.chkoutdt,
      _head.chkouttm,
      _head.GLAccount,
      _head.GLAccountLongName,
      _head.ProjectElement,
      _head.ProjectElementDescription,
      _head.condtype,
      _head.invpostdt,
      _head.SupplierInvoiceIDByInvcgParty,
      _head.DocumentDate,
      _head.TaxCode,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _head.igst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _head.cgst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _head.sgst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ( _head.cgst + _head.sgst + _head.igst ) as gst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _head.PurOrdAmountInCompanyCodeCrcy,
      _head.CompanyCodeCurrency,
      _head.PaymentTerms,
      _head.DueCalculationBaseDate,
      _Text.PurchaseRequisitionItemText        as Prtext
}
