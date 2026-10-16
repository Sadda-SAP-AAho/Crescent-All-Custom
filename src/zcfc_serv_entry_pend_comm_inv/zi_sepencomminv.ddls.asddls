@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service Entry Pending against Comm Invoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SEPENCOMMINV
  as select distinct from I_BillingDocument        as a
    inner join            ZI_COMM_INV_CONT_SIZE    as b on a.BillingDocument = b.BillingDocument
    left outer join       ZI_SERVICE_ENTRY_DETAILS as c on a.BillingDocument = c.BillingDocument
    left outer join       I_Customer               as d on a.PayerParty = d.Customer
{
  key a.BillingDocument           as Commercial_Invoice,
      a.BillingDocumentDate       as Commercial_Invoice_Date,
      d.Customer                  as Customer,
      a.TransactionCurrency       as Currency,
      a.IncotermsTransferLocation as Incoterms,
      b.contsize                  as Container_Size,
      case
      when a.BillingDocumentIsCancelled = 'X'
      then 'Yes'
      else 'No'
      end                         as CommercialInvoiceCancelled
}

where
      c.status              = 'X'
  and a.BillingDocumentType = 'F2'
