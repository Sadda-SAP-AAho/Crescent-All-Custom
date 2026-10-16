@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Labour Booking-Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_LABBKNGRPT
  as select distinct from ZI_LABBKREGHEAD     as a
    inner join            ZI_LABBKREGITEM     as b on a.Id = b.Id
    left outer join       I_BusinessUserBasic as c on c.UserID = a.Creby


{
  key    ( case when a.NewDocnum is initial then 'Old Doc. No.' else 'New Doc. No.' end ) as Type,
  key    ( case when a.NewDocnum is initial then a.Docnum else a.NewDocnum end )          as Docnum,
  key    a.Id,
  key    b.Item,
         a.Rptdate,
         a.Creon,
         c.PersonFullName                                                                 as Creby,
         a.Plantcode,
         a.Plantname,
         a.Contcode,
         a.Contname,
         a.Costname,
         a.Oprcode,
         a.Oprname,
         b.Workcode,
         b.Workname,
         b.Quantity,
         b.Rate,
         b.Amount,
         b.Aprvname,
         b.Remark

}

where
  b.Workcode is not initial
