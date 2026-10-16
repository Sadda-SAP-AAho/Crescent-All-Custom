@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'draft packing list item level fields'
//@AbapCatalog.sqlViewName: 'Z_DRAFTPLITM'
//@AbapCatalog.compiler.compareFilter: true
//@UI:{presentationVariant: [{ sortOrder: [ //{ by: 'DeliveryDocument' , direction: #DESC  },
//                                         { by: 'Priority' , direction: #ASC }
//                                         //{ by: 'Packqty' , direction: #DESC }
//                                         ] } ] }

//@AbapCatalog.preserveKey: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZVDRAFTPL_ITM
  as select distinct from ZI_PACKLIST_HDR           as a
    left outer join       I_DeliveryDocument        as b on a.Delivery = b.DeliveryDocument
    left outer join       ZI_PACKLIST_ITM           as d on a.Id = d.Id
    left outer join       I_UnitOfMeasure           as s on s.UnitOfMeasure = d.Meins
    left outer join       I_DeliveryDocumentItem    as c on  c.DeliveryDocument     = d.Delivery
                                                         and c.DeliveryDocumentItem = d.Posnr
    left outer join       I_ProductPlantBasic       as e on  d.Matnr = e.Product
                                                         and e.Plant = d.Plant
    left outer join       I_AE_CnsmpnTaxCtrlCodeTxt as f on  e.ConsumptionTaxCtrlCode = f.ConsumptionTaxCtrlCode
                                                         and f.CountryCode            = 'IN'
                                                         and f.Language               = 'E'
    left outer join       I_SalesOrderItem          as z on  z.SalesOrder     = c.ReferenceSDDocument
                                                         and z.SalesOrderItem = c.ReferenceSDDocumentItem

{
  key  c.DeliveryDocument,
  key  a.Revision,
  key  c.DeliveryDocumentItem,
       ceil( cast( d.Packqty as abap.dec( 16,2 ) ) ) as Packqty,
       d.Packmattyp,
       d.Priority,
       d.Wtunit,
       f.ConsumptionTaxCtrlCode,
       f.ConsumptionTaxCtrlCodeText1,
       @Semantics.quantity.unitOfMeasure: 'Wtunit'
       d.Eachnetwt,
       ceil( cast( d.Qty as abap.dec( 16,2 ) ) )     as Qty,
       d.Matnr,
       d.Meins,
       s.UnitOfMeasure_E                             as UOM,
       @Semantics.quantity.unitOfMeasure: 'Wtunit'
       d.Netwt,
       @Semantics.quantity.unitOfMeasure: 'Wtunit'
       d.Growt,
       @Semantics.quantity.unitOfMeasure: 'Wtunit'
       d.Eachgrowt,
       //        @Semantics.quantity.unitOfMeasure: 'Meins'
       //        sum( d.Packqty ) as sumpkgs
       z.PurchaseOrderByCustomer,
       d.Maktx                                       as MaterialByCustomer

}
where
  a.Canind <> 'X'
group by
  c.DeliveryDocument,
  a.Revision,
  c.DeliveryDocumentItem,
  d.Packqty,
  d.Packmattyp,
  d.Priority,
  d.Wtunit,
  f.ConsumptionTaxCtrlCode,
  f.ConsumptionTaxCtrlCodeText1,
  d.Eachnetwt,
  d.Qty,
  d.Matnr,
  d.Meins,
  s.UnitOfMeasure_E,

  d.Netwt,
  d.Growt,
  d.Eachgrowt,
  z.PurchaseOrderByCustomer,
  d.Maktx
