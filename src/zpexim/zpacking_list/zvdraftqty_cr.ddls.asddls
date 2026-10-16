@AbapCatalog.sqlViewName: 'ZV_QTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for qty & crate in draft packlist'
define view ZVDRAFTQTY_CR as select from ZCDS_QTYCRATE
{
   key delivery,
   key revision,
cast( concat_with_space( cast( ceil( packqty ) as abap.char(30) ), packmattyp , 1 ) as abap.char( 100 ) ) as zqtycrate
}
