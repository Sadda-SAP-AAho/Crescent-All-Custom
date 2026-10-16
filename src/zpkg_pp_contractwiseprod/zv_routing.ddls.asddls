@AbapCatalog.sqlViewName: 'ZV_ROU'
@EndUserText.label: 'fetching data from ZTBL_FUNC_ROUTING'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZV_ROUTING as 
select distinct from ZTBL_FUNC_ROUTING
                 
{
    key ProductionRoutingGroup,
    key ProductionRouting,
    key WorkCenterInternalID,
    key WorkCenterTypeCode,
    StandardWorkQuantity1,
    StandardWorkQuantity2
}
