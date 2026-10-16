@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Contractor'
@Metadata.ignorePropagatedAnnotations: true
//@UI: { presentationVariant: [{ sortOrder: [{ by: 'Shpflrno', direction:  #DESC }] }] }
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SHPFLRNO_F4 
as select distinct from zdt_conf_hdr as a
{
   @EndUserText.label: 'Shop Floor Number'
   key a.shpflrno as shpflrno,
   @EndUserText.label: 'Department'
   key a.dept     as Dept,
   @EndUserText.label: 'Department Name'
   key a.deptname     as Deptname,
    @EndUserText.label: 'Contractor'
   key a.cont         as Cont,
    @EndUserText.label: 'Contractor Name'
   key a.contname     as Contname,
    @EndUserText.label: 'Shop Floor Date'
   key a.shpflrdt     as Shpflrdt
}
where a.shpflrdt is not initial
group by shpflrno, dept, deptname, cont, contname, shpflrdt
