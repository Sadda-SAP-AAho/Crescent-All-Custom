@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Information Dashboard'
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_GSTINFODASH
  as select from zdt_gstinfodash
{
  key id               as Id,
  key fisyear          as Fisyear,
  key jeno             as Jeno,
      jedate           as Jedate,
      documenttype     as Documenttype,
      journalentrytype as Journalentrytype,
      documentno       as Documentno,
      vendorcode       as Vendorcode,
      vendorname       as Vendorname,
      invoicedrno      as Invoicedrno,
      invoicedrdate    as Invoicedrdate,
      gstno            as Gstno,
      state            as State,
      sumtaxablevalue  as Sumtaxablevalue,
      sumcgst          as Sumcgst,
      sumsgst          as Sumsgst,
      sumigst          as Sumigst,
      sumrcmcgst       as Sumrcmcgst,
      sumrcmsgst       as Sumrcmsgst,
      sumrcmigst       as Sumrcmigst,
      sumtotalinvvalue as Sumtotalinvvalue,
      twobrefno        as Twobrefno,
      gstremarks       as Gstremarks,
      newgstno         as Newgstno,
      gstmonth         as Gstmonth,
      extra1           as Extra1,
      extra2           as Extra2,
      lastchngedt      as Lastchngedt,
      lastchnngtm      as Lastchnngtm

}
