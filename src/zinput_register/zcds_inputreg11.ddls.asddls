@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INPUTREG11
  as select distinct from I_SuplrInvcItemPurOrdRefAPI01 as b
    inner join            I_MaterialDocumentItem_2      as c on  c.MaterialDocument     = b.ReferenceDocument
                                                             and c.MaterialDocumentItem = b.ReferenceDocumentItem
                                                             and c.MaterialDocumentYear = b.ReferenceDocumentFiscalYear
{
  key b.SupplierInvoice as AccountingDocument,
  key b.FiscalYear,
  key c.CompanyCode
//      c.YY1_EWAYBILL_MMI,
//      c.YY1_VEHICLE_NO_MMI,
//      c.YY1_TransporterName2_MMI
}
