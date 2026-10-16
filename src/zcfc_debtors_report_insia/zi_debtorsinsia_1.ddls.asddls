@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report - Insia(Basic)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DEBTORSINSIA_1
  as select distinct from ZI_FI_DEBTOR_RPT_21 as a
    left outer join       I_JournalEntry      as b on  b.AccountingDocument        = a.AccountingDocument
                                                   and b.FiscalYear                = a.FiscalYear
                                                   and b.CompanyCode               = a.CompanyCode
                                                   and b.OriginalReferenceDocument = a.arinv

{
  key a.CompanyCode,
  key a.FiscalYear,
  key a.AccountingDocument                                     as Accounting_Document,
  key a.AccountingDocumentItem,
  key a.AccountingDocumentType                                 as Document_Type,
  key a.AccountingDocumentTypeName                             as Document_Type_Name,
  key a.arinv                                                  as ARInvoice_No,
      a.taxinv                                                 as DelInvoice_No,
      a.taxinvref                                              as DelInvoice_No_Ref,
      a.DocumentDate                                           as ARInvoice_Date,
      b.AccountingDocumentCreationDate                         as Create_Date,
      b.LastChangeDate                                         as Update_Date,
      a.DocumentReferenceID                                    as Document_Reference,
      a.Customer                                               as Customer_Code,
      a.CustomerName                                           as Customer_Name,
      a.salesperson                                            as Sales_Person,
      a.TransactionCurrency                                    as Currency,
      a.AbsoluteAmountInTransacCrcy                            as FC_Total,
      a.AbsoluteExchangeRate                                   as Exchange_Rate,
      a.paidamt                                                as Paid_Amount_INR,
      ( a.FCbalamt * a.AbsoluteExchangeRate )                  as Balance_Amount_INR,
      a.FCPaid                                                 as Paid_Amount_FC,
      ( case when a.inwardamt >= a.FCPaid then ( a.AbsoluteAmountInTransacCrcy - a.inwardamt )
             when a.inwardamt < a.FCPaid then ( a.AbsoluteAmountInTransacCrcy - a.FCPaid )
             else a.FCbalamt end )                             as Balance_Amount_FC,
      a.NetDueDate                                             as Due_Date,
      dats_days_between( $session.system_date , a.NetDueDate ) as Oversue_Days,
      a.inwardamt                                              as Inward_Value_Recd_FC,
      a.inrecdt                                                as Inward_Recd_Dt

}
