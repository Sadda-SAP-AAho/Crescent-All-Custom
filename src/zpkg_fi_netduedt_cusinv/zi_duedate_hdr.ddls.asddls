@AccessControl.authorizationCheck: #CHECK
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@EndUserText.label: 'Interface View for Net Due Date Update'
define root view entity ZI_DUEDATE_HDR
  as select from zdt_duedate_hdr
  association to ZI_BASIS_F4 as _basis on $projection.Basis = _basis.value_low
{
  key id              as Id,
      ccode           as Ccode,
      customer        as Customer,
      belnr           as Belnr,
      gjahr           as Gjahr,
      buzei           as Buzei,
      invdt           as Invdt,
      zterm           as Zterm,
      pdesc           as Pdesc,
      basis           as Basis,
      basedt          as Basedt,
      noofday         as Noofday,
      duedt           as Duedt,     
      amount          as Amount,
      currency        as Currency,
      docsentcus      as Docsentcus,
      billoflad       as Billoflad,
      invoicedt       as Invoicedt,
      docsentban      as Docsentban,
      revduedt        as Revduedt,
      status          as Status,
      lastposted      as Lastposted,
      basedtsys       as Basedtsys,
      duedtsys        as Duedtsys,
      docref          as Docref,
      cal             as Cal,  
      post            as Post,  
      upd             as Upd,
      _basis.basistxt as Basistxt,

      _basis
}
