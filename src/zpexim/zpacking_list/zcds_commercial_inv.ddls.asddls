@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Invoice F4 Help'
define view entity zcds_commercial_inv
  as select distinct from I_BillingDocumentItem as a
    inner join            ZI_PACKLIST_HDR       as c on c.Delivery = a.ReferenceSDDocument
    inner join            ZI_PACKLIST_ITM       as b on b.Id = c.Id and b.Delivery = a.ReferenceSDDocument                               
{
  key a.BillingDocument,
      b.Delivery,
      b.Posnr,
      b.Plant,
      b.Matnr,
      b.Maktx,
      b.Meins,
      b.Qty,
      b.Packqty,
      b.Priority,
      b.Packmat,
      b.Packmatnwt,
      b.Matnetwt,
      b.Eachnetwt,
      b.Eachgrowt,
      b.Netwt,
      b.Growt,
      b.Wtunit,
      b.Packmattyp,
      b.Mateachpkg

}
where
      a.ReferenceSDDocumentCategory = 'J'
  and a.BillingDocumentType         = 'F2'
  and c.Canind <> 'X'
