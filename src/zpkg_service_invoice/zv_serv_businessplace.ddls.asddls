@AbapCatalog.sqlViewName: 'ZVBPLACE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Business place details'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_SERV_BusinessPlace as select from I_IN_BusinessPlaceTaxDetail
{
    key CompanyCode,
    key BusinessPlace,
    BusinessPlaceDescription,
    AddressID,
    IN_GSTIdentificationNumber,
    IN_IsBizPlaceGSTSpclEconomicZn,
    IN_GSTTxDdctdAtSrceRegn,
    IN_GSTBizPlaceClassfctn,
    /* Associations */
    _Address,
    _CompanyCode
}
