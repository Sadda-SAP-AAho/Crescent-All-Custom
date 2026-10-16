@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'CDS View for Authorization'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_APPAUTHOTP
  provider contract transactional_query
  as projection on ZR_appauthotp
{
  @EndUserText: {
    quickInfo: '16 Byte UUID in 16 Bytes (Raw Format)'
  }
  key InternalAuth,
  AppName,
  @EndUserText: {
    quickInfo: 'User Name'
  }
  UserId,
  AuthType,
  @EndUserText: {
    quickInfo: 'UTC Time Stamp in Long Form (YYYYMMDDhhmmssmmmuuun)'
  }
  CreatedAt,
  @EndUserText: {
    quickInfo: 'User Name'
  }
  CreatedBy,
  @EndUserText: {
    quickInfo: 'User Name'
  }
  LastChangedBy,
  @EndUserText: {
    quickInfo: 'UTC Time Stamp in Long Form (YYYYMMDDhhmmssmmmuuun)'
  }
  LastChangedAt,
  @EndUserText: {
    quickInfo: 'UTC Time Stamp in Long Form (YYYYMMDDhhmmssmmmuuun)'
  }
  LocalLastChangedAt
  
}
