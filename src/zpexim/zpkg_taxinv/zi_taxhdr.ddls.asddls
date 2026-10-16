@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Tax invoice Header'
define root view entity zi_taxhdr
  as select from zdt_taxhdr
{

  key id           as Id,
  key billingdoc   as Billingdoc,
      delivery     as Delivery,
      invtype      as Invtype,
      invdate      as Invdate,
      invcreatedby as Invcreatedby,
      taxigstprint as Taxigstprint,
      taxlutprint  as Taxlutprint,
      taxdomprint  as Taxdomprint,
      proinvprint  as Proinvprint,
      patinvprint  as Patinvprint,
      samcusprint  as Samcusprint,
      textfield1   as Textfield1,
      textfield2   as Textfield2,
      textfield3   as Textfield3,
      textfield4   as Textfield4,
      flag         as Flag

}
