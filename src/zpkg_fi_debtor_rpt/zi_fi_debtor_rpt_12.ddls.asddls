@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_FI_DEBTOR_RPT_12

  as select distinct from ZI_FI_DEBTOR_RPT as a

    inner join            ZI_NOSTRO_hed    as b on  b.Invoiceno  = a.AccountingDocument
                                                and b.fiscalyear = a.FiscalYear

    left outer join       ZI_NOSTRO_ITM2   as c on  c.Id                     = b.Id
                                                and c.Accountingdocumentitem = a.AccountingDocumentItem

{
  key a.AccountingDocument,
  key a.AccountingDocumentItem,
  key a.FiscalYear,
      max( c.Inwardrecordstatus ) as Inwardrecordstatus
}

group by
  a.AccountingDocument,
  a.AccountingDocumentItem,
  a.FiscalYear
