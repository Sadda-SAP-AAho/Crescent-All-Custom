@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status - Supplier Total per Bank Account (today)'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_bank_stat_supplier_tot
  as select from ZI_bank_stat_head as Head
{
  key Head.Bankaccountnumber   as Bankaccountnumber,
  key Head.Supplier            as Supplier,

      Head.Companycodecurrency as Currency,

      @Semantics.amount.currencyCode: 'Currency'
      sum(
        cast( Head.Amountincompanycodecurrency as abap.dec( 23, 2 ) )
        *
        case
          when cast( Head.Bankaccountnumber as abap.int8 ) = 31251000015
           and abs( cast( Head.Amountincompanycodecurrency as abap.dec( 23, 2 ) ) ) > 1000000
            then 0
          else 1
        end
      )                        as SupplierTotalAmount
}
where
       Head.Postingdate                            = $session.system_date
  and(
       cast( Head.Bankaccountnumber as abap.int8 ) = 31251000015
    or cast( Head.Bankaccountnumber as abap.int8 ) = 341233011
  )
group by
  Head.Bankaccountnumber,
  Head.Supplier,
  Head.Companycodecurrency
