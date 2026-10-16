@Metadata.allowExtensions: true
@EndUserText.label: 'CONSUMPTION VIEW FOR Input Registration'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_INPUTREG
  provider contract transactional_query
  as projection on ZCDS_INPUTREG7
{
        @UI.hidden: true
  key   SourceLedger,
        @EndUserText.label: 'Company Code'
        @Search.defaultSearchElement: true
  key   CompanyCode,

        @EndUserText.label: 'Year'
  key   FiscalYear,
        @EndUserText.label: 'Accounting Document Number'
  key   AccountingDocument,
        @EndUserText.label: 'Line Item'
  key   LedgerGLLineItem,
        @UI.hidden: true
  key   Ledger,
        @EndUserText.label: 'Business Place'
        BusinessArea,
        @EndUserText.label: 'Company Name'
        CompanyCodeName,
        @EndUserText.label: 'State'
        State,
        @EndUserText.label: 'Profit Center'
        ProfitCenter,
        @EndUserText.label: 'Segment for Segmental Reporting'
        Segment,
        @EndUserText.label: 'Plant'
        Plant,
        @EndUserText.label: 'GSTIN'
        GSTIN,
        @EndUserText.label: 'Month'
        Month1,



        @EndUserText.label: 'Invoice/DebitNote/CreditNote/Billo Date'
        DocumentDate,

        @EndUserText.label: 'Transaction Count'
        TransactionCount,
        @EndUserText.label: 'Currency'
        TransactionCurrency,
        @EndUserText.label: 'Gl Account'
        GLAccount,
        @EndUserText.label: 'Gl Account Name'
        GLAccountName,
        @EndUserText.label: 'Invoice/Debit Note/ Credit Note'
        AccountingDocumentType,
        @EndUserText.label: 'Taxability'
        Taxability,
        @EndUserText.label: 'Supply Type'
        SupplyType,
        @EndUserText.label: 'Supplier Code'
        Supplier,
        @EndUserText.label: 'Nature Of Supply'
        Natureofsupply,
        @EndUserText.label: 'GSTIN of supplier'
        TaxNumber3,
        @EndUserText.label: 'Supplier State'
        RegionName,
        @EndUserText.label: 'Name of the Supplier'
        SupplierFullName,
        @EndUserText.label: 'Invoice/Debit Note/ Credit Note / Bill o'
        documentitemtext,


        @EndUserText.label: 'Accounting Document Date'
        PostingDate,




        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        @EndUserText.label: 'Invoice/DebitNote/CreditNote/BilloAmount'
        AmountInTransactionCurrency,
        @EndUserText.label: 'Supply attract reverse charge'
        Supplyattractreverseharges,
        @EndUserText.label: 'POS'
        Pos,

        @EndUserText.label: 'Item Code'
        Itemcode,
        @EndUserText.label: 'Category'
        Category,
        @EndUserText.label: 'HSN/SAC'
        ConsumptionTaxCtrlCode,
        @EndUserText.label: 'HSN/SAC Description'
        ConsumptionTaxCtrlCodeText1,
        //        @EndUserText.label: 'Product/Service Description'
        //        ProductDescription,
        @UI.hidden: true
        BaseUnit,
        @EndUserText.label: 'UQC'
        ReferenceQuantityUnit,
        @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
        @EndUserText.label: 'Quantity'
        Quantity,
        @EndUserText.label:  'Sale price(Before discount)'
        SalepriceBeforediscount,
        @EndUserText.label: 'Discount'
        Discount,
        @EndUserText.label: 'Net sale price (after discount)'
        Netsalepriceafterdiscount,
        @EndUserText.label: 'VAT'
        Vat,
        @EndUserText.label: 'Central Excise'
        CentralExcise,
        @EndUserText.label: 'State Excise'
        StateExcise,
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        @EndUserText.label: 'Taxable Amount'

        Taxableamount,

        @EndUserText.label: 'Total GST Rate'
        Totalgstrate,

        @EndUserText.label: 'IGST (Rate)'
        IGSTRate,

        @EndUserText.label: 'IGST (Amt)'
        IGSTValue,

        @EndUserText.label: 'CGST (Rate)'
        CGSTRate,

        @EndUserText.label: 'CGST (Amt)'
        CGSTValue,

        @EndUserText.label: 'SGST (Rate)'
        SGSTRate,

        @EndUserText.label: 'SGST (Amt)'
        SGSTValue,

        @EndUserText.label: 'Cess (Rate)'
        Cess,

        @EndUserText.label: 'Cess (Amt)'
        CessValue,

        @EndUserText.label: 'Eligibility of ITC'
        EligibilityofITC,

        @EndUserText.label: 'ITC IGST (Amt)'
        ITCIGSTAmt,

        @EndUserText.label: 'ITC CGST (Amt)'
        ITCCGSTAmt,

        @EndUserText.label: 'ITC SGST (Amt)'
        ITCSGSTAmt,

        @EndUserText.label: 'ITC Cess (Amt)'
        ITCCessAmt,

        @EndUserText.label: 'Nature of expense'
        Natureofexpense,
        @EndUserText.label: 'Ship From(State)'
        ShipFromState,
        @EndUserText.label: 'Ship To(State)'
        ShipToState,
        @EndUserText.label: 'Way bill No'
        WaybillNo,
        @EndUserText.label: 'Transporter name'
        Transportername,
        @EndUserText.label: 'Lorry Receipt number'
        LorryReceiptnumber,
        @EndUserText.label: 'Lorry Receipt date'
        LorryReceiptdate,
        @EndUserText.label: 'Credit/Debit Note(Original  Invoice No.)'
        CDNoteOriginalInvoiceNo,
        @EndUserText.label: 'Credit/Debit Note(Original  Invoice Date'
        CDOriginalInvoiceDate,
        @EndUserText.label: 'Reason for issuing Debit/ Credit Note'
        ReasonforissuingDCNote,
        @EndUserText.label: 'Assessable value before BCD'
        AssessablevaluebeforeBCD,
        @EndUserText.label: 'Basic Custom Duty'
        BasicCustomDuty,
        @EndUserText.label: 'Port Code'
        PortCode,
        @EndUserText.label: 'Is Advance Adjustment'
        IsAdvanceAdjustment,
        @EndUserText.label: 'Advance adjustment (Invoice No.)'
        AdvanceadjustmentInvoiceNo,
        @EndUserText.label: 'Advance adjustment (Invoice Date)'
        AdvanceadjustmentInvoiceDate,
        @EndUserText.label: 'Is Amendment'
        IsAmendment,
        @EndUserText.label: 'Amendment(Original Year)'
        AmendmentOriginalYear,
        @EndUserText.label: 'Amendment(Original Month)'
        AmendmentOriginalMonth,
        @EndUserText.label: 'Amendment(Original GSTIN of supplier)'
        AmendmentOriginalGSTINsupplier,
        @EndUserText.label: 'Amendment(Original Document No.)'
        AmendmentOriginalDocumentNo,
        @EndUserText.label: 'Amendment(Original Document Date)'
        AmendmentOriginalDocumentDate,
        @EndUserText.label: 'Is ISD'
        IsISD,
        @EndUserText.label: 'ISD (Location Details)'
        ISDLocationDetails,
        @EndUserText.label: 'Tax Code'
        TaxCode,
         @EndUserText.label: 'Vehicle Number'
        vehicle

}
