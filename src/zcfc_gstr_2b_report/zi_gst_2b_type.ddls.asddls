@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST 2B Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_2B_TYPE
  as select distinct from ZI_GSTR2BREG_I  as a
    inner join            ZI_GSTR2BREG_H  as b on a.id = b.id
    left outer join       ZI_GST_2B_MATCH as c on  a.rowno    = c.rowno
                                               and b.comments = c.GSTMonth
{

  key b.comments                                        as GSTMonth,
  key a.rowno,
      ( case when ( a.lglname = 'THE HONGKONG AND SHANGHAI BANKING CORPN. LTD.'
                 or a.lglname = 'DBS Bank India Limited'
                 or a.lglname = 'CITIBANK N.A'
                 or a.lglname = 'ICICI BANK LTD'
                 or a.lglname = 'ICICI BANK LIMITED' )
             then 'BANK'

             when cast( c.Type as abap.char(15) ) = 'THIRD PARTY'
             then 'THIRD PARTY'

             else cast( c.Type as abap.char(15) ) end ) as Type

}
