@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Label Print'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_LABELPRINT_N
  as select distinct from ZI_PACKLIST_ITM  as a

    inner join            ZI_PACKLIST_HDR  as b on  a.Packinglist =  b.Packinglist
                                                and b.Canind      <> 'X'
                                                and a.Id          =  b.Id

    inner join            I_UnitOfMeasure  as c on a.Meins = c.UnitOfMeasure

    inner join            ZVDRAFTPL_ITM    as d on  a.Delivery = d.DeliveryDocument
                                                and b.Revision = d.Revision
                                                and a.Posnr    = d.DeliveryDocumentItem
                                                and a.Matnr    = d.Matnr
    inner join            ZI_MAXCRATEWT_N  as e on  a.Packinglist = e.Packinglist
                                                and a.Priority    = e.Priority

    inner join            ZI_PACKCRATE_N   as f on  a.Packinglist = f.Packinglist
                                                and a.Item        = f.Item
                                                and a.Matnr       = f.Matnr

    inner join            ZI_NETWT_N       as g on  a.Packinglist = g.Packinglist
                                                and a.Matnr       = g.Matnr
                                                and a.Item        = g.Item

    inner join            ZI_GROSSWT_N     as h on  a.Packinglist = h.Packinglist
                                                and a.Priority    = h.Priority
                                                and a.Matnr       = h.Matnr
                                                and a.Item        = h.Item

    left outer join       zdt_pp_matinffld as i on i.product = a.Matnr

{
  key    a.Packinglist                                          as PackingList,

  key    a.Packinglist                                          as Inv_No,

  key    a.Priority,

  key    a.Item                                                 as itemkey,

         cast( '' as abap.char( 10 ) )                          as Sl_No,

         a.Matnr                                                as Item,

         cast( f.PackCrate as abap.dec(13,0) )                  as Packing_Crate,

         c.UnitOfMeasure_E                                      as UOM,

         cast( g.NetWt as abap.dec(13,0) )                      as Net_WtPack,

         a.Wtunit                                               as Unit,

         cast( h.GrossWt as abap.dec(13,0) )                    as GrossWt_Pack,

         a.Wtunit                                               as UnitofMeasure,

         a.Packinglist                                          as Invoice_No,

         d.PurchaseOrderByCustomer                              as PO_No,

         cast( a.Packqty as abap.dec(13,0) )                    as Qty,

         a.Maktx                                                as Item_Description,

         i.packinstr                                            as Pack_Instr,

         ( case when b.Customercode = 'BRK' then i.drawno end ) as Drawing_No,

         ( case when b.Customercode = 'BRK' then i.artno end )  as Art_No

}

where
  a.Priority <> '00000'
