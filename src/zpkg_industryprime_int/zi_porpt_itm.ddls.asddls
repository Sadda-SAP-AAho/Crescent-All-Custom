@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for PO Report Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZI_PORPT_ITM
  as select from zdt_po_item
  association to parent ZI_PORPT_HDR as _head on $projection.Uuid = _head.Uuid
{
  key zdt_po_item.uuid                                      as Uuid,
  key zdt_po_item.itemuuid                                  as Itemuuid,
      zdt_po_item.vendor                                    as Vendor,
      zdt_po_item.purchaser                                 as Purchaser,
      zdt_po_item.docnum                                    as Docnum,
      zdt_po_item.docitem                                   as Docitem,
      zdt_po_item.itemcode                                  as Itemcode,
      zdt_po_item.description                               as Description,
      zdt_po_item.qty                                       as Qty,
      zdt_po_item.price                                     as Price,
      zdt_po_item.discount                                  as Discount,
      zdt_po_item.taxcode                                   as Taxcode,
      zdt_po_item.quotreference                             as Quotreference,
      zdt_po_item.quotdate                                  as Quotdate,
      zdt_po_item.deldate                                   as Deldate,
      zdt_po_item.zterm                                     as Zterm,
      zdt_po_item.inco1                                     as Inco1,
      zdt_po_item.incoloc                                   as Incoloc,
      zdt_po_item.validity                                  as Validity,
      zdt_po_item.pnftype                                   as Pnftype,
      zdt_po_item.pnf                                       as Pnf,
      zdt_po_item.quoteremark                               as Quoteremark,
      zdt_po_item.genremark                                 as Genremark,
      zdt_po_item.currency                                  as Currency,
      zdt_po_item.transcosttype                             as Transcosttype,
      zdt_po_item.transport                                 as Transport,
      zdt_po_item.othersamt                                 as Othersamt,
      //      zdt_po_item.createdon     as Createdon,
      cast(concat(concat(concat(substring(createdon,7,2),'/'),
              concat(substring(createdon,5,2),'/' ) ),
              substring(createdon,1,4)) as abap.char(10) )  as Createdon,
      //      zdt_po_item.createdat     as Createdat,
      cast(concat(concat(concat(substring(createdat,1,2),':'),
               concat(substring(createdat,3,2),':' ) ),
               substring(createdat,5,2)) as abap.char(10) ) as Createdat,
      _head // Make association public
}
