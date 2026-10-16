@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Export Register'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_EXPORTREG_1

  as select distinct from I_BillingDocument     as a

    left outer join       I_BillingDocumentItem as b on b.BillingDocument = a.BillingDocument
{

  key a.BillingDocument,
  key b.ReferenceSDDocument,
      b.Plant,
      a.PayerParty,
      b.SalesGroup,
      a.BillingDocumentDate,
      a.TransactionCurrency,
      a.AccountingExchangeRate,
      a.IncotermsClassification,
      a.CustomerPaymentTerms,
      a.BillingDocumentType,
      a.AccountingTransferStatus,
      a.DocumentReferenceID,
      case
      when a.BillingDocumentIsCancelled = 'X'
      then 'Yes'
      else 'No'
      end as CommercialInvoiceCancelled
}

where
  (
       a.BillingDocumentType      = 'F8'
    or a.BillingDocumentType      = 'F2'
  )

  and  a.CancelledBillingDocument is initial
