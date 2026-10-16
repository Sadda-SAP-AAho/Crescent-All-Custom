@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Script Generation Dashboard'
define view entity zcds_script_gen
  as select from ZR_SCROLLITEM
{
  key scrollno,
  key shipping_bill,
  key shipping_bill_date,
      port_code,
      port_codename,
      currency,
      fob_lc_v,
      rodtep_dd_v,
      appliedamount
     
}
where scrollno <> ''
