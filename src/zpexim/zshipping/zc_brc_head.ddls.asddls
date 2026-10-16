@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view: BRC header details'
@Metadata.allowExtensions: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZC_BRC_HEAD 
provider contract transactional_query
as projection on ZI_BRC_HEAD
{
    key Id,
    Internalno,
    Filestatus,
    Criticalitystatus,
//    Hideexcel,
    Status,
    Attachment,
    Mimetype,
    Filename,
    Comments,
    Post,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    Valid,
    Upd,
    _item : redirected to composition child ZC_BRC
}
