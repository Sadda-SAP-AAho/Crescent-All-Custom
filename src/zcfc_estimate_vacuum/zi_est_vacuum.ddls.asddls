@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@EndUserText.label: 'Interface View of Estimate Vacuum Reg'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZI_EST_VACUUM
  as select distinct from zdt_estvac
{
  key   id,
  key   matcd,
        rejection,
        tolerance,
        margin,
        amtmrgn,
        cntwgt,
        fxdcst_cal,
        fxdcst_ue,
        line,
        boxsize1,
        boxsize2,
        annualqty,
        mouldspd,
        reqweight,
        noofcav,
        yield,
        addacccost,
        drillperfacing,
        srfcarea,
        chrgingcst,
        metalcst,
        elccst,
        labmldperbx,
        mldcst,
        mntcstperpc,
        fetcstperpc,
        paintprcst,
        sellexpn,
        acccavity,
        exchngrt,
        curr,
        packngcst,
        corecstcav
}
