@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for BG Header'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_IMBG_HED
  as select from zdt_imbg_hed
{
  key id               as Id,
      companycode      as Companycode,
      imbgrefno        as Imbgrefno,
      version          as Version,
      bgappnam         as Bgappnam,
      bgstat           as Bgstat,
      city             as City,
      country          as Country,
      bgcharacter      as Bgcharacter,
      hbkid            as Hbkid,
      hktid            as Hktid,
      bankl            as Bankl,
      banknam          as Banknam,
      //      bgbenfname       as Bgbenfname,
      bankaddr         as Bankaddr,
      bankbrnch        as Bankbrnch,
      zifsccode        as Zifsccode,
      swift            as Swift,
      bankvendor       as Bankvendor,
      bankvendorname   as Bankvendorname,
      bgreqdt          as Bgreqdt,
      bgeffdt          as Bgeffdt,
      bgexpdt          as Bgexpdt,
      bgclaimexpdt     as Bgclaimexpdt,
      bgtenure         as Bgtenure,
      bgtype           as Bgtype,
      bgexchangerate   as Bgexchangerate,
      bgcatag          as Bgcatag,
      bgcurrency       as Bgcurrency,
      bgcurrencyfc     as Bgcurrencyfc,
      @Semantics.amount.currencyCode: 'Bgcurrencyfc'
      bgamt            as Bgamt,
      @Semantics.amount.currencyCode: 'Bgcurrency'
      bglcamt          as Bglcamt,
      @Semantics.amount.currencyCode: 'Bgcurrency'
      bcopenchrgs      as Bcopenchrgs,
      bgbenefcode      as Bgbenefcode,
      bgbenefname      as Bgbenefname,
      bgaddress        as Bgaddress,
      bgcountry        as Bgcountry,
      bgcity           as Bgcity,
      bgstate          as Bgstate,
      bgpostalcode     as Bgpostalcode,
      bgpurpose        as Bgpurpose,
      @Semantics.amount.currencyCode: 'Bgcurrency'
      banklimit        as Banklimit,
      @Semantics.amount.currencyCode: 'Bgcurrency'
      netbglimit       as Netbglimit,
      @Semantics.amount.currencyCode: 'Bgcurrency'
      bgcleanlimit     as Bgcleanlimit,
      bgcleanassign    as Bgcleanassign,
      bgbankfd         as Bgbankfd,
      bgfdtagprovision as Bgfdtagprovision,
      accdocno         as Accdocno,
      accdocyr         as Accdocyr,
      accpost          as Accpost,
      amendment        as Amendment,
      setout           as Setout
}
