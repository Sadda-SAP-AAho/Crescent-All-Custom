@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Commercial & Delivery Dashbord'
@Metadata.allowExtensions: true
define root view entity ZI_COM_DLV_CDS
  as select distinct from I_BillingDocumentItem as a
    inner join            I_BillingDocument     as c on  a.BillingDocument     = c.BillingDocument
                                                     and c.BillingDocumentType = 'F2'
    left outer join       zdt_deldash_hdr       as b on a.ReferenceSDDocument = b.delivery and b.canind = ''
{
  key a.BillingDocument,
      a.ReferenceSDDocument,
      c.AccountingExchangeRate                                as ExchangeRate,
      b.forwarder,
      b.cod,
      b.contno,
      b.consizen                                              as consize,
      b.shipline,
      ( case when a.BillingDocument <> '' then 1 else 0 end ) as i
}
