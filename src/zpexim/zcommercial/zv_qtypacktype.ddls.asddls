@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for concating packqty & mattype'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.sqlViewName: 'ZV_QTYMATTYPE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
define view ZV_QTYPACKTYPE as select from ZCDS_QTYFINALCOMM
{
   key comm_inv,
cast( concat_with_space( cast( ceil( packqty ) as abap.char(30) ), packmattyp , 1 ) as abap.char( 100 ) ) as zqtycratemattype
}
