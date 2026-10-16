@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI REGISTER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_FIREGISTERVF
  as select from ZV_FIREGISTERV1
{
  key GSTInvoiceNo,
  key FiscalYear,
  key CompanyCode,
  key AccountingDocumentItem,
      AccountingDocumentType,
      PostingDate,
      CommercialInvoiceNo,
      TransactionCurrency,
      AbsoluteExchangeRate,
      PaymentTerms,
      Customer,
      GLAccount,
      GLAccountName,
      IN_HSNOrSACCode,
      DocumentItemText,
      AssignmentReference,
      BPName,
      GSTInNo,
      PANNo, //Added by SP on 16.06.25
      StateName,
      case when AccountingDocumentType = 'DG' then cast( ( -1 * AmountinDC ) as abap.dec( 23, 2 ) )
           else cast( AmountinDC as abap.dec( 23, 2 ) ) end as AmountinDC,
      case when AccountingDocumentType = 'DG' then cast( ( -1 * AmountinLC ) as abap.dec( 23, 2 ) )
           else cast( AmountinLC as abap.dec( 23, 2 ) ) end as AmountinLC,
      case when AccountingDocumentType = 'DG' then cast( ( -1 * IGST ) as abap.dec( 23, 2 ) )
           else cast( IGST as abap.dec( 23, 2 ) ) end       as IGST,
      case when AccountingDocumentType = 'DG' then cast( ( -1 * SGST ) as abap.dec( 23, 2 ) )
           else cast( SGST as abap.dec( 23, 2 ) ) end       as SGST,
      case when AccountingDocumentType = 'DG' then cast( ( -1 * CGST ) as abap.dec( 23, 2 ) )
           else cast( CGST as abap.dec( 23, 2 ) ) end       as CGST,
      ElectronicDocUUID,
      IN_ElectronicDocInvcRefNmbr,
      IN_EDocEInvcEWbillNmbr
}
