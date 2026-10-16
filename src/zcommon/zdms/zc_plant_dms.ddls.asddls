@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant DMS CDS'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity  ZC_PLANT_DMS as select from I_Plant as A

left outer join ZI_GROUPED_DOC as b on  A.Plant    = b.RefObjectKey
                                        and b.RefObjectType = 'PLNT'

//left outer join ZR_USER_ITEM000 as _user on A.PlantCode = _user.Plant 
{
 key A.Plant   as Plant,
  A.PlantName as PlantName,
  A.PlantSupplier    as GSTINNumber,
//  A.StateName  as StateName,
//  A.StateCode1 as StateCode,
//  A.Address1,
  b.DocCount as DocumentCount
//  A.CreatedBy

}
//where _user.Userid = $session.user

