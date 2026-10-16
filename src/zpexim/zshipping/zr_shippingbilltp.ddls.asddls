@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forShippingBill'
define root view entity ZR_ShippingBillTP
  as select from    zex_shipbill_hdr as a
    left outer join I_JournalEntry   as b on  b.AccountingDocument = a.accountdocno
                                          and b.FiscalYear         = a.accountdocyr
  composition [0..*] of ZR_ShippingBillItemTP as _ShippingBillItem
  composition [0..*] of ZR_ShippingBillILICTP as _ShippingBillItemLIC
  //  composition [0..*] of ZI_BRC                as _ShippingBillItemBRC
{
  key a.internal_shipbill     as InternalShipbill,
      a.shipping_bill         as ShippingBill,
      a.shipping_bill_date    as ShippingBillDate,
      a.scroll_no             as ScrollNo,
      a.scroll_date           as ScrollDate,
      a.custom_handling_agent as CustomHandlingAgent,
      a.port_code             as PortCode,
      a.posting_date          as PostingDate,
      a.bill_of_lading        as BillOfLading,
      a.bill_of_lading_date   as BillOfLadingDate,
      a.leo_date              as LeoDate,
      @Semantics.amount.currencyCode: 'Fob_Lc_C'
      a.fob_lc_v              as Fob_Lc_V,
      a.fob_lc_c              as Fob_Lc_C,
      @Semantics.amount.currencyCode: 'Fob_Fc_C'
      a.fob_fc_v              as Fob_Fc_V,
      @Semantics.amount.currencyCode: 'Fob_Fc_C'
      a.usageamount           as UsageAmount,
      a.fob_fc_c              as Fob_Fc_C,
      a.exchangerate          as Exchangerate,
      a.total_duty_drawback   as TotalDutyDrawback,
      @Semantics.amount.currencyCode: 'TotalDutyDrawbackC'
      a.total_duty_drawback_v as TotalDutyDrawbackV,
      a.total_duty_drawback_c as TotalDutyDrawbackC,
      a.total_rodtep          as Rodtep,
      @Semantics.amount.currencyCode: 'RodtepC'
      a.total_rodtep_v        as RodtepV,
      a.total_rodtep_c        as RodtepC,
      a.country_bl            as CountryBl,
      a.state_of_origin       as StateOfOrigin,
      a.destination_country   as DestinationCountry,
      a.tpost                 as Tpost,
      a.accountdocno          as Accountdocno,
      a.accountdocyr          as Accountdocyr,
      a.accpostref            as Accpostref,
      a.tpostdbk              as Tpostdbk,
      a.accdocnodbk           as Accdocnodbk,
      a.accdocyrdbk           as Accdocyrdbk,
      a.accpostrefdbk         as Accpostrefdbk,
      @Semantics.systemDateTime.createdAt: true
      a.created_at            as CreatedAt,
      @Semantics.user.createdBy: true
      a.created_by            as CreatedBy,
      @Semantics.user.lastChangedBy: true
      a.last_changed_by       as LastChangedBy,
      a.last_changed_at       as LastChangedAt,
      a.local_last_changed_at as LocalLastChangedAt,
      a.closestatus           as Closestatus,
      a.closestatus           as statuscancel,
      a.invoicehed            as invoicehed,
      a.postingdatenew        as PostingDateNew,
      b.IsReversed            as IsReversed,
      a.brcno                 as BRCNo,
      a.brcdate               as BRCDate,
      a.brcvalue              as BRCValue,
      _ShippingBillItem,
      _ShippingBillItemLIC
      //      _ShippingBillItemBRC
}
