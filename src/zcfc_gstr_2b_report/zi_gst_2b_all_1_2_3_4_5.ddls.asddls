@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST 2B ALL & Part Match-1,2,3,4,5'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_2B_ALL_1_2_3_4_5
  as select distinct from ZI_GST_2B_ALL_1_2_3_4
{
  key GSTMonth,
  key rowno,
  key FiscalYear,
  key AccountingDocument,
      AccountingDocumentType,
      CDS,
//      SupplierInvoice,
      BPTaxNumber,
      Supplier,
      SupplierName,
      InvRefNo,
      Type
}

union

select distinct from ZI_GST_2B_PART_MATCH_5 as p
  left outer join    ZI_GST_2B_ALL_1_2_3_4  as a on  a.rowno    = p.rowno
                                                 and a.GSTMonth = p.GSTMonth
{
  key p.GSTMonth,
  key p.rowno,
  key p.FiscalYear,
  key p.AccountingDocument,
      p.AccountingDocumentType,
      p.CDS,
//      p.SupplierInvoice,
      p.BPTaxNumber,
      p.Supplier,
      p.SupplierName,
      p.InvRefNo,
      p.Type
}
where
  a.rowno is null
