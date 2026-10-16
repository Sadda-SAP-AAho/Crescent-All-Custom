@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtor~Interface'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_DEBTOR
  as select distinct from I_OperationalAcctgDocItem     as a
    left outer join       I_BillingDocumentItem         as b on b.BillingDocument = a.OriginalReferenceDocument
    left outer join       I_BillingDocument             as m on m.BillingDocument = a.OriginalReferenceDocument
    left outer join       I_BillingDocumentItemBasic    as c on c.ReferenceSDDocument = b.ReferenceSDDocument
    left outer join       I_BillingDocument             as d on d.BillingDocument = c.BillingDocument
    left outer join       ZI_COMM_HED                   as e on e.Commid = a.OriginalReferenceDocument
    left outer join       I_Customer                    as f on f.Customer = d.PayerParty
    left outer join       I_CustomerAccountAssgmtGroupT as o on  o.CustomerAccountAssignmentGroup = f.CustomerAccountGroup
                                                             and o.Language                       = $session.system_language
    left outer join       I_RegionText                  as p on  p.Country  = f.Country
                                                             and p.Region   = f.Region
                                                             and p.Language = $session.system_language
    left outer join       ZI_DELDASH_HDR                as g on g.Delivery = b.ReferenceSDDocument
    left outer join       ZR_ShippingBillItemTP         as h on h.Invoice = d.BillingDocument
    left outer join       ZR_ShippingBillTP             as i on i.InternalShipbill = h.InternalShipbill
    left outer join       ZR_ShippingBillTP             as j on j.ShippingBill = i.ShippingBill
    left outer join       I_BillingDocumentItem         as k on k.BillingDocument = d.BillingDocument
    left outer join       ZI_DELDASH_HDR                as l on l.Delivery = k.ReferenceSDDocument
    left outer join       I_CustomerPaymentTermsText    as n on  n.CustomerPaymentTerms = m.CustomerPaymentTerms
                                                             and n.Language             = $session.system_language

{
  key         a.AccountingDocument,
  key         a.OriginalReferenceDocument                                as InvoiceNumber,
  key         a.DocumentDate                                             as InvoiceDate,
  key         d.BillingDocument                                          as TaxInvoice,
  key         a.CompanyCode,


  key         e.Planingweek,
  key         e.Planingmonth,
  key         d.PayerParty                                               as CustomerNumber,
  key         f.CustomerName,
  key         a.TransactionCurrency                                      as DocumentCurrency,
  key         g.Salesnoteref,
              //
  key         cast( a.AbsoluteAmountInTransacCrcy as abap.dec( 21, 2 ) ) as TotalAmount,
  key         cast( a.AbsoluteAmountInCoCodeCrcy as abap.dec( 21, 2 ) )  as InvoiceValue,
              b.ReferenceSDDocument,
              c.BillingDocument,
              e.Ladingno                                                 as BLNo,
              e.Ladingdt                                                 as BLDate,
              i.ShippingBill                                             as ShippingBillNo,
              j.ShippingBillDate,
              j.invoicehed                                               as FOB_Value,
              l.Empretdt                                                 as ExpContRecdDt,
              e.Bankrefno                                                as BankRefNo,
              e.Docpresentbnkdt                                          as DocsSubtToBnkDt,
              e.Paymentprocess,
              m.IncotermsClassification,
              e.Billcloseflag                                            as BillClosed,
              n.CustomerPaymentTermsName                                 as PaymentTerm,
              e.Docsentcustdt                                            as DocSendCust,
              g.Etadt                                                    as TentETADt,
              g.Etddt                                                    as ActETADt,
              o.CustomerAccountAssgmtGrpName                             as CustomerGrpName,
              p.RegionName                                               as StateName,
              f.TaxNumber3                                               as GSTNo,
              e.Ebrcno,
              e.Drftblrcvdt                                              as BLRecdDt




}
where
  (
       a.AccountingDocumentType      =  'DR'
    or a.AccountingDocumentType      =  'RV'
  )
  and(
       b.ReferenceSDDocumentCategory =  'J'
  )
  and(
       c.BillingDocumentType         =  'F8'
  )
  and  d.AccountingTransferStatus    <> 'E'
  and  k.ReferenceSDDocumentCategory =  'J'
