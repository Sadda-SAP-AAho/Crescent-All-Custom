@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HSN code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PRODHSN
  as select distinct from I_SuplrInvcItemPurOrdRefAPI01 as b
    inner join            I_MaterialDocumentItem_2      as c on  c.MaterialDocument     = b.ReferenceDocument
                                                             and c.MaterialDocumentItem = b.ReferenceDocumentItem
                                                             and c.MaterialDocumentYear = b.ReferenceDocumentFiscalYear
{
  key b.SupplierInvoice                                         as AccountingDocument,
  key b.FiscalYear,
  key c.CompanyCode,
      cast( sum( c.QuantityInEntryUnit ) as abap.dec( 13, 3 ) ) as QuantityInEntryUnit
}
group by
  b.SupplierInvoice,
  b.FiscalYear,
  c.CompanyCode
