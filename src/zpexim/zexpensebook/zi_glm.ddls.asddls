@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for GL Code Maintenance'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
define root view entity ZI_GLM as select from zdt_expexpbook
{
    key exptyp as Exptyp,
    key descr as Descr,
    key psc as Psc,
    key gla as Gla,
    key glc1 as Glc1,
    key glc2 as Glc2
}
