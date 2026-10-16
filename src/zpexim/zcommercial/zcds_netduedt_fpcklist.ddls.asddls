@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS for Final Packing List'

@Metadata.ignorePropagatedAnnotations: true

define root view entity ZCDS_NETDUEDT_FPCKLIST
  as select distinct from I_BillingDocument         as a

    inner join            I_OperationalAcctgDocItem as b
      on  a.CompanyCode      = b.CompanyCode
      and a.BillingDocument  = b.OriginalReferenceDocument
      and b.PaymentTerms    <> ''

    inner join            zdt_pterm                 as c
      on a.CustomerPaymentTerms = c.zterm

    inner join            zdt_comm_hed              as d
      on a.BillingDocument = d.commid

{
  key a.BillingDocument,
  key a.CustomerPaymentTerms,
  key c.basis,
  key c.noofday,

      case when c.basis = '1'
              then(case  when dats_is_valid(d.docsentcustdt) = 1
                   then dats_add_days(d.docsentcustdt, cast(c.noofday as abap.int4), 'INITIAL')
                   else '00000000' end)
           when c.basis = '2'
             then(case  when dats_is_valid(d.ladingdt) = 1
                   then dats_add_days(d.ladingdt, cast(c.noofday as abap.int4), 'INITIAL')
                   else '00000000' end)
           when c.basis = '3'
             then b.NetDueDate
           when c.basis = '4'
             then(case  when dats_is_valid(d.docpresentbnkdt) = 1
                   then dats_add_days(d.docsentcustdt, cast(c.noofday as abap.int4), 'INITIAL')
                   else '00000000' end)
           else 'INITIAL'
        end                   as netduedate
}
