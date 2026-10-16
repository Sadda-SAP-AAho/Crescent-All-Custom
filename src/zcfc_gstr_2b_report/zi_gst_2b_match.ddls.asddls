@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST 2B Match'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_2B_MATCH
  as select distinct from ZI_GST_2B_ALL_1_2_3_4_5_6
{
  key rowno,
  key GSTMonth,
  key FiscalYear,
  key AccountingDocument,
      AccountingDocumentType,
      cast( CDS as abap.char( 12 ) ) as CDS,
      //      SupplierInvoice,
      BPTaxNumber,
      Supplier,
      SupplierName,
      InvRefNo,
      Type
}
