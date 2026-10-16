@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Purchase Register'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_PURCHASE_REG
  with parameters
    P_PODateFrom : zde_date,
    P_PODateTo   : zde_date
  as select from ZI_PURCHASE_REG_PR_TEXT(
                    P_PODateFrom : $parameters.P_PODateFrom,
                    P_PODateTo   : $parameters.P_PODateTo )
{

      @UI.hidden: true
  key PurchaseOrder,
      @UI.hidden: true
  key PurchaseOrderItem,
      @UI.hidden: true
  key PurchaseRequisition,
      @UI.hidden: true
  key PurchaseRequisitionItem,
      @UI.hidden: true
  key MaterialDocument,
      @UI.hidden: true
  key MaterialDocumentItem,
      @UI.hidden: true
  key MaterialDocumentYear,
      @UI.hidden: true
  key SupplierInvoice,
      @UI.hidden: true
  key SupplierInvoiceItem,
      @UI.hidden: true
  key FiscalYear,
      @UI.hidden: true
  key gatepass,
      @EndUserText.label: 'Purchase Requisition No.'
      PurchaseRequisition                                as Pr,
      @EndUserText.label: 'Purchase Requisition Item No.'
      PurchaseRequisitionItem                            as Pritm,
      @EndUserText.label: 'PR Plant'
      Prplant,
      @EndUserText.label: 'PR Plant Name'
      Prplantname,
      @EndUserText.label: 'PR Date'
      PurchaseReqnCreationDate,
      @EndUserText.label: 'PR release date'
      Prreldt,
      @EndUserText.label: 'PR Qty'
      RequestedQuantity,
      @EndUserText.label: 'PR Item Text'
      //    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PR_TEXT'

      Prtext,
      @EndUserText.label: 'PO No.'
      PurchaseOrder                                      as Po,
      @EndUserText.label: 'PO Item No.'
      PurchaseOrderItem                                  as Poitm,
      @EndUserText.label: 'Material Code'
      Material,
      @EndUserText.label: 'PO Plant'
      Plant,
      @EndUserText.label: 'PO Plant Name'
      PlantName,
      @EndUserText.label: 'Material Description'
      PurchaseOrderItemText,
      @EndUserText.label: 'PO Item Text'
      PlainLongText                                      as Potext,
      @EndUserText.label: 'Vendor Code'
      Supplier,
      @EndUserText.label: 'Vendor Name'
      SupplierFullName,
      @EndUserText.label: 'PO Date'
      PurchaseOrderDate,
      @EndUserText.label: 'PO Release date'
      Poreldate,
      @EndUserText.label: 'PO Qty'
      OrderQuantity,
      @EndUserText.label: 'UOM'
      UnitOfMeasure,
      @EndUserText.label: 'UOM Description'
      UnitOfMeasureLongName,
      @EndUserText.label: 'GRN No.'
      MaterialDocument                                   as Grn,
      @EndUserText.label: 'GRN Year'
      MaterialDocumentYear                               as Grnyr,
      @EndUserText.label: 'GRN Item'
      MaterialDocumentItem                               as Grnitm,
      @EndUserText.label: 'GRN Date'
      PostingDate,
      @EndUserText.label: 'GRN Qty'
      QuantityInEntryUnit,
      @EndUserText.label: 'GRN Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency1'
      PurOrdAmountInCompanyCodeCrcy1,
      @UI.hidden: true
      CompanyCodeCurrency1,
      @EndUserText.label: 'Gate Entry No.'
      YY1_GateEntryNumber_MMI,
      @EndUserText.label: 'Gate Entry Date'
      gateentrydate,
      @EndUserText.label: 'Gate Entry Qty'
      YY1_ChallanQuantity_MMI,
      @EndUserText.label: 'QC Status'
      cast( InspectionCodeText as abap.char(40) )        as Qcsta,
      @EndUserText.label: 'BY Hand'
      byhand,
      @EndUserText.label: 'Vehicle No.'
      YY1_VehicleNumber_MMI,
      @EndUserText.label: 'Transporter Name'
      transportername,
      @EndUserText.label: 'Drivers Name'
      drivername,
      @EndUserText.label: 'Tare Weight'
      YY1_TareWeight_MMI,
      @EndUserText.label: 'Unit of Weight'
      unitwt,
      @EndUserText.label: 'Gross Weight'
      YY1_GrossWeight_MMI,
      @EndUserText.label: 'Net weight'
      YY1_NetWeight_MMI,
      @EndUserText.label: 'Check-in-Date'
      chkindt,
      @EndUserText.label: 'Check-In-Time'
      chkintm,
      @EndUserText.label: 'Check-out-Date'
      chkoutdt,
      @EndUserText.label: 'Check-out-Time'
      chkouttm,
      @EndUserText.label: 'GL Account No.'
      GLAccount,
      @EndUserText.label: 'GL Description'
      GLAccountLongName,
      @EndUserText.label: 'WBS No.'
      cast( ProjectElement as abap.char(24) )            as wbs,
      @EndUserText.label: 'WBS Description'
      cast( ProjectElementDescription as abap.char(40) ) as wbsdesc,
      @EndUserText.label: 'Invoice Posting Number'
      SupplierInvoice                                    as supinv,
      @EndUserText.label: 'Condition Type'
      condtype,
      @EndUserText.label: 'Invoice Posting Date'
      invpostdt,
      @EndUserText.label: 'Vendor Invoice / Reference No.'
      SupplierInvoiceIDByInvcgParty,
      @EndUserText.label: 'Vendor Invoice Date'
      DocumentDate,
      @EndUserText.label: 'Tax Code'
      TaxCode,
      @EndUserText.label: 'IGST'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      igst,
      @EndUserText.label: 'CGST'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cgst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'SGST'
      sgst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'GST Amount'
      gst,
      @EndUserText.label: 'Invoice Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      PurOrdAmountInCompanyCodeCrcy,
      @UI.hidden: true
      CompanyCodeCurrency,
      @EndUserText.label: 'Payment Terms'
      PaymentTerms,
      @EndUserText.label: 'Payment Due Date'
      DueCalculationBaseDate
}
