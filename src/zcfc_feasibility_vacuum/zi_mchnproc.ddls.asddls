@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View of Feasibility Vacuum Reg'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L

define root view entity ZI_MCHNPROC
  as select from zdt_fesvacuum as a
{
  key a.id             as Id,
      a.rfqdate        as Rfqdate,
      a.matcd          as Matcd,
      a.custcd         as Custcd,
      a.rfqno          as Rfqno,
      a.pduser         as Pduser,
      a.annualqty      as Annualqty,
      a.paintinfo      as Paintinfo,
      a.process        as Process,
      a.packaging      as Packaging,
      a.weight_2d      as Weight_2d,
      a.weight_3d      as Weight_3d,
      a.ptolrnce       as Ptolrnce,
      a.ntolrnce       as Ntolrnce,
      a.stdtolrdim     as Stdtolrdim,
      a.gjl            as Gjl,
      a.mktgusr        as Mktgusr,
      a.length         as Length,
      a.width          as Width,
      a.height         as Height,
      a.line           as Line,
      a.boxsize1       as Boxsize1,
      a.boxsize2       as Boxsize2,
      a.noofcav        as Noofcav,
      a.yldprcnt       as Yldprcnt,
      a.corepercavity  as Corepercavity,
      a.corecstpercav  as Corecstpercav,
      a.insertpercav   as Insertpercav,
      a.insertcost     as Insertcost,
      a.pipepercav     as Pipepercav,
      a.pipecost       as Pipecost,
      a.htchpltpercav  as Htchpltpercav,
      a.htchpltcost    as Htchpltcost,
      a.oteherscost    as Oteherscost,
      a.mouldspd       as Mouldspd,
      a.mchnprcss      as Mchnprcss,
      a.patterncst     as Patterncst,
      a.toolscst       as Toolscst,
      a.jigfixcst      as Jigfixcst,
      a.srfcarea       as Srfcarea,
      a.nofpcsperpllt  as Nofpcsperpllt,
      a.noofpcspercont as Noofpcspercont,
      a.addcst         as Addcst,
      a.drlfacing      as Drlfacing,
      a.remarkspd      as Remarkspd
}
