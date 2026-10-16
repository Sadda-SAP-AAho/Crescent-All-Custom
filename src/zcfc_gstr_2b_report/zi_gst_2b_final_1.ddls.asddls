@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST 2B Final_1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_GST_2B_FINAL_1

  as select distinct from ZI_GST_2B_BASIC         as a

    left outer join       ZTBL_FCTN_GSTR_2B_BASIC as b  on  b.GSTMonth = a.GSTMonth
                                                        and b.rowno    = a.rowno

    left outer join       ZI_GSTINFODASH          as c  on  c.Jeno    = b.AccountingDocument
                                                        and c.Fisyear = a.fisyear

    left outer join       ZI_GSTNEWVENREF         as c1 on  c1.Jeno    = b.AccountingDocument
                                                        and c1.Fisyear = a.fisyear

    left outer join       ZI_GST_TAX_VALUE        as d  on  b.AccountingDocument = d.AccountingDocument
                                                        and a.fisyear            = d.FiscalYear

    left outer join       ZI_GST_IGST_VALUE       as e  on  b.AccountingDocument = e.AccountingDocument
                                                        and a.fisyear            = e.FiscalYear

    left outer join       ZI_GST_CGST_VALUE       as f  on  b.AccountingDocument = f.AccountingDocument
                                                        and a.fisyear            = f.FiscalYear

    left outer join       ZI_GST_SGST_VALUE       as g  on  b.AccountingDocument = g.AccountingDocument
                                                        and a.fisyear            = g.FiscalYear

    left outer join       ZI_GST_ISD_VALUE        as h  on  b.AccountingDocument = h.AccountingDocument
                                                        and a.fisyear            = h.FiscalYear

    left outer join       ZI_GST_RCM_VALUE        as i  on  b.AccountingDocument = i.AccountingDocument
                                                        and a.fisyear            = i.FiscalYear

{
  key a.Location,
  key a.GSTMonth,
  key a.rowno,
      a.Type,
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
      b.AccountingDocument                                                                                                                                                                          as JENo,
      a.JERefNo,
      ( case when c.Twobrefno is initial then c1.Newvendrefno else c.Twobrefno end )                                                                                                                as Vendor2BRefNo,
      d.TaxValue,
      d.TaxCode,
      e.TaxValue                                                                                                                                                                                    as IGSTAmt,
      f.TaxValue                                                                                                                                                                                    as CGSTAmt,
      g.TaxValue                                                                                                                                                                                    as SGSTAmt,
      h.TaxValue                                                                                                                                                                                    as ISDAmt,
      i.TaxValue                                                                                                                                                                                    as ReverseAmt,
      ( case when a.invtyp = 'Credit Note'
             then cast( ( ( ( coalesce( a.intgrtax, 0 ) + coalesce( a.centraltax, 0 ) + coalesce( a.stateuttax, 0 ) + coalesce( a.cess, 0 ) ) * (-1) ) - coalesce( d.TaxValue, 0 ) ) as abap.dec(15,3) )
             else cast( ( ( coalesce( a.intgrtax, 0 ) + coalesce( a.centraltax, 0 ) + coalesce( a.stateuttax, 0 ) + coalesce( a.cess, 0 ) ) - coalesce( d.TaxValue, 0 ) ) as abap.dec(15,3) ) end ) as Difference
}
