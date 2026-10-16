@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FOREX Maturity Alert'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_FOREX_MATURITY_ALRT
  as select from ZI_FOREXTP as a

{
  key a.Id,
  key  (case
            when a.Maturitydate <  $session.system_date
                 and a.Balanceval > 0
              then 'OVERDUE'
            when a.Maturitydate between $session.system_date
                                   and dats_add_days( $session.system_date, 2, 'INITIAL' )
                 and a.Balanceval > 0
              then 'COMING_DUE'
            else 'OTHER'
          end)        as status,
  key  a.Contnoext    as cntct_no,
       a.Bankname     as bnk_nm,
       a.Waers        as curr,
       @Semantics.amount.currencyCode: 'curr'
       a.Balanceval   as bal_amt,
       a.Maturitydate as mature_dt

}
where
       a.Balanceval   > 0
  and(
       a.Maturitydate < $session.system_date
    or a.Maturitydate between $session.system_date and dats_add_days( $session.system_date, 2, 'INITIAL' )
  )
