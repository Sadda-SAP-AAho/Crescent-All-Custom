@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST 2B Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_2B_BASIC
  as select distinct from ZI_GSTR2BREG_I  as a

    inner join            ZI_GSTR2BREG_H  as b on  a.id       = b.id
                                               and b.canceled = 'NO'

    left outer join       ZI_GST_2B_TYPE  as c on  a.rowno    = c.rowno
                                               and b.comments = c.GSTMonth

    left outer join       ZI_GST_2B_MATCH as d on  a.rowno    = d.rowno
                                               and b.comments = d.GSTMonth

{

  key b.location                       as Location,
  key b.comments                       as GSTMonth,
  key b.fisyear,
  key a.rowno,
  key d.AccountingDocument,
      ( case when c.Type = ' ' or c.Type is null
             then 'N/A'

             else c.Type
        end )                          as Type,
      a.suppgstn,
      a.lglname,
      a.invno,
      a.invtyp,
      a.invdate,
      a.invval,
      a.placesupply,
      a.revcharge,
      a.rateperc,
      a.taxval,
      a.intgrtax,
      a.centraltax,
      a.stateuttax,
      a.cess,
      a.gstrperiod,
      a.gstrfildate,
      a.itcavail,
      a.reason,
      a.apptaxrate,
      d.AccountingDocumentType,
      cast( d.CDS as abap.char( 12 ) ) as CDS,
      d.AccountingDocument             as JENo,
      d.InvRefNo                       as JERefNo

}
