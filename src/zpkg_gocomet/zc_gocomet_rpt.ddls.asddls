@AbapCatalog.sqlViewName: 'ZCGOCOMET'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for GoComet Report'
@Metadata.allowExtensions: true
define view ZC_GOCOMET_RPT 
as select from ZCDS_GOCOMET_RPT
{
    @EndUserText.label: 'Mode'
    key Delmode,
    @EndUserText.label: 'Reference No'
    key Refno,
    @EndUserText.label: 'Tracking Number'
    key Trackno,
    @EndUserText.label: 'Carrier'
    Carrier,
    @EndUserText.label: 'Container Numbers'
    Carnum,
    @EndUserText.label: 'Factory Dispatch Date'
    Disdate,
    @EndUserText.label: 'Origin (POL)'
    Pol,
    @EndUserText.label: 'Destination (POD)'
    Pod,
    @UI.hidden: true
    @EndUserText.label: 'Star/Mark as Priority'
    Markcap,
    @UI.hidden: true
    @EndUserText.label: 'Client Group Code'
    Clntgrpcode,
    @UI.hidden: true
    @EndUserText.label: 'Consignee Group Code'
    Consgrpcode,
    @UI.hidden: true
    @EndUserText.label: 'Carrier Code'
    Carcode,
    @UI.hidden: true
    @EndUserText.label: 'Vessel Name'
    Vesname,
    @UI.hidden: true
    @EndUserText.label: 'Container Size'
    Consize,
    @UI.hidden: true
    @EndUserText.label: 'Container Type'
    Contype,
    @UI.hidden: true
    @EndUserText.label: 'Auto Detect Carrier?'
    autocar,
    @EndUserText.label: 'Delivery Date'
    Deldate,
    @EndUserText.label: 'Invoice No'
    Invno,
    @EndUserText.label: 'Invoice Date'
    Invdt
}
