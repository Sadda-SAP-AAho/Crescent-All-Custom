@AbapCatalog.sqlViewName: 'ZSV1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For Proforma Invoice 2nd Table'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_TABLE2 
as select distinct from I_DeliveryDocument as a
            inner join I_DeliveryDocumentItem as b on a.DeliveryDocument = b.DeliveryDocument
            inner join ZV_PROFORMA_ITM as i on i.DeliveryDocument = b.DeliveryDocument
                                            and i.DeliveryDocumentItem = b.DeliveryDocumentItem
{
   key a.DeliveryDocument,
    i.Packmattyp,
    sum(i.Netwt) as snw,
    sum(i.Growt) as sgw,
    sum(i.Packqty) as spq
}
group by
   a.DeliveryDocument,
     i.Packmattyp

