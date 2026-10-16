@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for lc details'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_LCDETAILS
  as select distinct from I_DeliveryDocument    as a
    left outer join       I_BillingDocumentItem as z on  z.ReferenceSDDocument         = a.DeliveryDocument
                                                     and z.ReferenceSDDocumentCategory = 'J'
                                                     and z.BillingDocumentType         = 'F8'
    left outer join       ZI_LCEXPITM           as b on a.DeliveryDocument = b.Delivery
    left outer join       ZI_LCEXPHEAD          as c on c.Id = b.Id
    left outer join       ZI_LCBNK_DLTS         as d on  d.Id       = c.Id
                                                     and d.Banktype = 'Issuing Bank'
{
  key  z.BillingDocument,
  key  c.Lc_Refnr,
  key  c.Version,
       c.Lc_Appl,
       c.Lc_Open_Dt,
       d.Banka
}
