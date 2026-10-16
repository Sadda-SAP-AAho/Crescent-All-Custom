@AbapCatalog.sqlViewName: 'ZPL_VAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for pl values'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_PLVALUES
  as select from ZCDS_PACKLIST_NO_SORTED as a
    inner join   I_DeliveryDocumentItem  as d on  d.ReferenceSDDocument     = a.ReferenceSDDocument
                                              and d.ReferenceSDDocumentItem = a.ReferenceSDDocumentItem
    inner join   ZI_PACKLIST_ITM         as c on  d.DeliveryDocument     = c.Delivery
                                              and d.DeliveryDocumentItem = c.Posnr
//    inner join   ZI_PACKLIST_HDR         as b on a.packinglist = b.Packinglist
    inner join   ZI_PACKLIST_HDR         as b on c.Id = b.Id

{

  key a.ReferenceSDDocument,
  key a.ReferenceSDDocumentItem,
      a.packinglist,
      c.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      sum(c.Qty) as qtysum

}
where
  b.Canind <> 'X'
group by
  a.ReferenceSDDocument,
  a.ReferenceSDDocumentItem,
  a.packinglist,
  c.Meins
