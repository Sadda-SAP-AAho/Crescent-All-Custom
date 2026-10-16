@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Export Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_EXPORT
  as select from    I_BillingDocument          as a
    left outer join I_BillingDocumentItem      as b on b.BillingDocument = a.BillingDocument
    left outer join I_Customer                 as c on c.Customer = a.PayerParty
    left outer join ztmg_salesgrp              as d on d.salesgroup = b.SalesGroup
    left outer join I_BillingDocumentItemBasic as e on  e.ReferenceSDDocument     = b.ReferenceSDDocument
                                                    and e.ReferenceSDDocumentItem = b.ReferenceSDDocumentItem
    left outer join I_BillingDocument          as f on f.BillingDocument = e.BillingDocument
  //left outer join ZI_COMM_HED                as g on g.Commid = e.BillingDocument
    left outer join zcds_valuecal1             as h on h.BillingDocument = e.BillingDocument
    left outer join ZI_DELDASH_HDR             as i on i.Delivery = b.ReferenceSDDocument
    left outer join I_CustomerPaymentTermsText as k on  k.CustomerPaymentTerms = a.CustomerPaymentTerms
                                                    and k.Language             = $session.system_language
    left outer join ZI_COMM_HED                as l on l.Commid = e.BillingDocument
    left outer join I_BusinessPartner          as m on m.BusinessPartner = i.Chaname
    left outer join ZI_GATEENTRY               as n on n.Vbeln = b.ReferenceSDDocument
    left outer join ZCDS_shippingbill1         as o on o.Invoice = b.BillingDocument
    left outer join zcds_lc2                   as p on p.Delivery = b.ReferenceSDDocument
    left outer join zcds_weight1               as q on q.delivery = b.ReferenceSDDocument


{
  key b.BillingDocument                     as GSTInvoiceNumber,
  key b.BillingDocumentItem,
      b.Plant                               as Location,
      b.ReferenceSDDocument                 as OutBoundDelivery,
      a.BillingDocumentDate                 as GSTInvoiceDate,
      a.PayerParty                          as BPCode,
      c.CustomerName                        as BPName,
      d.salesperson,
      e.BillingDocument                     as CommercialInvNo,
      f.BillingDocumentDate                 as CommercialInvDate,
      i.Salesnoteref,
      b.TransactionCurrency                 as Currency,
      a.AccountingExchangeRate              as ExchangeRate,
      h.Value                               as ValueInDC,
      h.Value * a.AccountingExchangeRate    as ValueInLC,
      h.Discount                            as DiscountInDC,
      h.Discount * a.AccountingExchangeRate as DiscountInLC,
      h.Freight                             as FreightInDC,
      h.Freight * a.AccountingExchangeRate  as FreightInLC,
      o.InvoiceValueLcC,
      @Semantics.amount.currencyCode: 'InvoiceValueLcC'
      o.InvoiceValueLcV                     as Invoice,
      a.IncotermsClassification,
      k.CustomerPaymentTermsName            as PaymentTerms,
      i.Pol                                 as PortOfLoading,
      i.Pod                                 as PortofDischarge,
      i.Porttrans                           as PortOfTrans,
      i.Findes,
      i.Cod                                 as CountryofDestination,
      i.forwardernam                        as forwarder,
      i.Shipline,
      i.Bookingno,
      i.Contno,
      i.Consizen,
      i.Finalseal                           as CarrierSealNo,
      q.netwt,
      q.growt,
      l.Vesselname,
      i.Docrelchadt,
      m.BusinessPartnerName                 as CHAName,
      i.Conpckletdt                         as ContPickUpLetterDt,
      i.Conpckvaldt                         as ContaonerPickUpValDt,
      i.Concutoffdt,
      i.Conliftdt,
      i.Confacindt,
      n.Vehicleoutdate,
      o.ShippingBill,
      o.ShippingBillDate,
      i.Detrecchadt,
      i.Sisentdt                            as SISentDate,
      i.Carordappdt,
      i.Sisentdt                            as CartingOrderRecdDate,
      i.Latordrecrem,
      i.Condockindt,
      i.Latcondocrem,
      i.Shpbilldt,
      l.Drftblrcvdt,
      l.Correctblsendon,
      l.Ladingno                            as BLNo,
      l.Ladingdt                            as BLDt,
      l.Isfsenddt,
      l.Docsentcustdt,
      l.Docpresentbnkdt,
      l.Awbno,
      p.Lc_Appl                             as LC_Number,
      p.Lc_Req_Date,
      i.Descgoods,
      i.Vessaildt,
      i.Etadt,
      i.Etddt,
      i.Empretdt,
      i.Freightremarks


}
where
  (
          b.ReferenceSDDocumentCategory =  'J'
    and   a.BillingDocumentType         =  'F8'
    and   a.AccountingTransferStatus    <> 'E'
    and   d.configdeprecationcode       <> 'E'
    and(
          e.BillingDocumentType         <> 'F8'
      and e.BillingDocumentType         <> 'F5'
      and e.BillingDocumentType         <> 'S1'
      and e.BillingDocumentType         <> 'S2'
    )
    and   e.CancelledBillingDocument    <> 'X'

    and   i.Canind                      <> 'X'
  )
