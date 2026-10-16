@AbapCatalog.sqlViewName: 'ZV_QTY1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Quantity & Crate in Domestic Draft Packlist'
define view ZV_DOMDPL_QTY as select from ZCDS_QTYCRATE
{
   key delivery,
   key revision,
cast( concat_with_space( cast( ceil( packqty ) as abap.char(30) ), packmattyp , 1 ) as abap.char( 100 ) ) as zqtycrate
}
