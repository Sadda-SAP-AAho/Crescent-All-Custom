@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Export Register'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZV_EXPORTREG_2

  as select from    ZV_EXPORTREG_1             as a

    left outer join I_Customer                 as c on c.Customer = a.PayerParty

    left outer join ztmg_salesgrp              as d on d.salesgroup = a.SalesGroup

    left outer join ZV_EXPORTREG_1             as e on  e.ReferenceSDDocument = a.ReferenceSDDocument
                                                    and e.BillingDocumentType = 'F2'

    left outer join I_BillingDocument          as f on f.BillingDocument = e.BillingDocument

    left outer join zcds_valuecal1             as h on h.BillingDocument = e.BillingDocument

    left outer join zcds_valuecal1             as r on r.BillingDocument = a.BillingDocument

    left outer join ZI_DELDASH_HDR             as i on  i.Delivery =  a.ReferenceSDDocument
                                                    and i.Canind   <> 'X'

    left outer join I_CustomerPaymentTermsText as k on  k.CustomerPaymentTerms = a.CustomerPaymentTerms
                                                    and k.Language             = $session.system_language

    left outer join ZI_COMM_HED                as l on l.Commid = e.BillingDocument

    left outer join I_BusinessPartner          as m on m.BusinessPartner = i.Chaname

    left outer join ZV_EXPORTREG_3             as n on n.Delivery = a.ReferenceSDDocument

    left outer join ZCDS_shippingbill1         as o on o.Invoice = a.BillingDocument

    left outer join zcds_lc2                   as p on p.Delivery = a.ReferenceSDDocument

    left outer join zcds_weight1               as q on q.delivery = a.ReferenceSDDocument

    left outer join ZCDS_NETDUEDT_FPCKLIST     as s on s.BillingDocument = e.BillingDocument

    left outer join I_BusinessPartnerBank      as t on c.Customer = t.BusinessPartner


{
  key a.BillingDocument                                                                                                                                               as GSTInvoiceNumber,
  key e.BillingDocument                                                                                                                                               as CommercialInvNo,
      a.Plant                                                                                                                                                         as Location,
      a.ReferenceSDDocument                                                                                                                                           as OutBoundDelivery,
      a.BillingDocumentDate                                                                                                                                           as GSTInvoiceDate,
      a.PayerParty                                                                                                                                                    as BPCode,
      c.CustomerName                                                                                                                                                  as BPName,
      d.salesperson,
      f.BillingDocumentDate                                                                                                                                           as CommercialInvDate,
      i.Salesnoteref,
      a.TransactionCurrency                                                                                                                                           as Currency,
      a.AccountingExchangeRate                                                                                                                                        as ExchangeRate,
      h.Value                                                                                                                                                         as ValueInDC,
      h.Value * a.AccountingExchangeRate                                                                                                                              as ValueInLC,
      r.Value                                                                                                                                                         as ValueTaxInvInDC,
      r.Value * a.AccountingExchangeRate                                                                                                                              as ValueTaxInvInLC,
      h.Discount                                                                                                                                                      as DiscountInDC,
      h.Discount * a.AccountingExchangeRate                                                                                                                           as DiscountInLC,
      r.Freight                                                                                                                                                       as FreightInDC,
      r.Freight * a.AccountingExchangeRate                                                                                                                            as FreightInLC,
      o.InvoiceValueLcC,
      @Semantics.amount.currencyCode: 'InvoiceValueLcC'
      o.InvoiceValueLcV                                                                                                                                               as Invoice,
      a.IncotermsClassification,
      k.CustomerPaymentTermsName                                                                                                                                      as PaymentTerms,
      i.Pol                                                                                                                                                           as PortOfLoading,
      i.Pod                                                                                                                                                           as PortofDischarge,
      i.Porttrans                                                                                                                                                     as PortOfTrans,
      i.Findes,
      i.Cod                                                                                                                                                           as CountryofDestination,
      i.forwardernam                                                                                                                                                  as forwarder,
      i.Shipline,
      i.Bookingno,
      i.Contno,
      i.Consizen,
      i.Carsealno                                                                                                                                                     as CarrierSealNo,
      q.netwt,
      q.growt,
      l.Vesselcode                                                                                                                                                    as Vesselname,
      i.Docrelchadt,
      m.BusinessPartnerName                                                                                                                                           as CHAName,
      i.Conpckletdt                                                                                                                                                   as ContPickUpLetterDt,
      i.Conpckvaldt                                                                                                                                                   as ContaonerPickUpValDt,
      i.Concutoffdt,
      i.Conliftdt,
      //i.Confacindt,
      n.Confacindt,
      ( case when i.Contdisfact is initial then n.Vehicleoutdate
             else i.Contdisfact end)                                                                                                                               as Vehicleoutdate,
      o.ShippingBill,
      o.ShippingBillDate,
      i.Detrecchadt,
      i.Sisentdt                                                                                                                                                      as SISentDate,
      i.Carordappdt,
      i.Cartordrecdt                                                                                                                                                  as CartingOrderRecdDate,
      //      i.Sisentdt                                                                                                                                                      as CartingOrderRecdDate,
      i.Latordrecrem,
      i.Condockindt,
      i.Latcondocrem,
      i.Shpbilldt,
      l.Drftblrcvdt,
      l.Correctblsendon,
      l.Ladingno                                                                                                                                                      as BLNo,
      l.Ladingdt                                                                                                                                                      as BLDt,
      l.Isfsenddt,
      l.Docsentcustdt,
      l.Docpresentbnkdt,
      l.Awbno,
      p.Lc_Appl                                                                                                                                                       as LC_Number,
      p.Lc_Req_Date,
      i.Descgoods,
      i.Vessaildt,
      i.Etadt,
      i.Atadt                                                                                                                                                         as Etddt,
      i.Empretdt,
      l.Blrcvdt,
      p.Lc_Open_Dt,
      i.Freightremarks,
      e.CommercialInvoiceCancelled,
      case l.Draftblcnfdt
      when '00000000' then ''
      else concat( concat(concat( substring( l.Draftblcnfdt, 7, 2 ), '.' ), concat( substring( l.Draftblcnfdt, 5, 2 ), '.' )), substring( l.Draftblcnfdt, 1, 4 )) end as Draftblcnfdt,
      case s.netduedate
      when '00000000' then ''
      else concat( concat(concat( substring( s.netduedate, 7, 2 ), '.' ), concat( substring( s.netduedate, 5, 2 ), '.' )), substring( s.netduedate, 1, 4 )) end       as netduedate,
      t.BankName,
      a.DocumentReferenceID,
      i.Contpickfrm as ContainerPickUpFrom
}

where
      a.BillingDocumentType      =  'F8'

  and a.AccountingTransferStatus <> 'E'

  and d.configdeprecationcode    <> 'E'

  and i.Canind                   <> 'X'
