@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of Material Serial Number'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MATSERIALNO
  provider contract transactional_query
  as projection on ZI_MATSERIALNO
{
      @EndUserText.label: 'Material No'
      @Search.defaultSearchElement: true
  key Material,
      @EndUserText.label: 'Serial No'
  key SerialNumber,
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Storage Location'
  key StorageLocation,
      @EndUserText.label: 'Creation Date'
      CreationDate,
      @EndUserText.label: 'Created by'
      CreatedBy
}
