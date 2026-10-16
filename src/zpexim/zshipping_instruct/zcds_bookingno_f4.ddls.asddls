@AbapCatalog.sqlViewName: 'ZCDS_BOOK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 help for booking no'
define view ZCDS_BOOKINGNO_F4 as select distinct
from ZI_DELDASH_HDR
{
    key Bookingno
}
where Bookingno is not initial
