@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXIM Clubbing Doc Type F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CLUBBILDOCF4TP_2

  as select from ZI_EXIMCLUBHDR as a

    inner join   ZI_EXIMCLUBITM as b on b.id = a.id

{

  key a.id,
  key b.item,
      a.clubnointernal,
      a.clubnoexternal,
      a.clubcomment,
      a.documenttype,
      a.documenttypedesc,
      a.cdate,
      a.cuser,
      a.deleted,
      a.released,
      b.invoice,
      b.posnr,
      b.matnr,
      b.maktx,
      b.hsnsac,
      b.plant

}

where
  a.released = ''
