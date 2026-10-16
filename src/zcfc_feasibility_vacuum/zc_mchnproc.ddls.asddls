@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Feasibility VAC Reg'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_MCHNPROC
  provider contract transactional_query
  as projection on ZI_MCHNPROC
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'RFQ Date'
      Rfqdate,
      @EndUserText.label: 'Material Code'
      Matcd,
      @EndUserText.label: 'Customer Code'
      Custcd,
      @EndUserText.label: 'RFQ No'
      Rfqno,
      @EndUserText.label: 'PD User'
      Pduser,
      @EndUserText.label: 'Annual Qty'
      Annualqty,
      @EndUserText.label: 'Paint'
      Paintinfo,
      @EndUserText.label: 'Process'
      Process,
      @EndUserText.label: 'Packaging'
      Packaging,
      @EndUserText.label: '2D Weight (Kg)'
      Weight_2d,
      @EndUserText.label: '3D Wt  as per 7.1(Kg)'
      Weight_3d,
      @EndUserText.label: '2D/3D Wt Tolerance%(+)'
      Ptolrnce,
      @EndUserText.label: '2D/3D Wt Tolerance%(-)'
      Ntolrnce,
      @EndUserText.label: 'Dimension Tolerance Std'
      Stdtolrdim,
      @EndUserText.label: 'GJL 150/200'
      Gjl,
      @EndUserText.label: 'Marketing User'
      Mktgusr,
      @EndUserText.label: 'Length'
      Length,
      @EndUserText.label: 'Width'
      Width,
      @EndUserText.label: 'Height'
      Height,
      @EndUserText.label: 'Line'
      Line,
      @EndUserText.label: 'Box Size D1'
      Boxsize1,
      @EndUserText.label: 'Box Size D2'
      Boxsize2,
      @EndUserText.label: 'No Of Cavities'
      Noofcav,
      @EndUserText.label: 'Yield%'
      Yldprcnt,
      @EndUserText.label: 'Core/Cavity'
      Corepercavity,
      @EndUserText.label: 'Core Cost/Cavity'
      Corecstpercav,
      @EndUserText.label: 'Insert/Cavity'
      Insertpercav,
      @EndUserText.label: 'Insert Cost'
      Insertcost,
      @EndUserText.label: 'Pipe/Cavity'
      Pipepercav,
      @EndUserText.label: 'Pipe Cost'
      Pipecost,
      @EndUserText.label: 'Hitch Plate/Cavity'
      Htchpltpercav,
      @EndUserText.label: 'Hitch Plate Cost'
      Htchpltcost,
      @EndUserText.label: 'Others Cost'
      Oteherscost,
      @EndUserText.label: 'Mould Speed'
      Mouldspd,
      @EndUserText.label: 'Machining Process'
      Mchnprcss,
      @EndUserText.label: 'Pattern Cost '
      Patterncst,
      @EndUserText.label: 'Tools Cost '
      Toolscst,
      @EndUserText.label: 'JIG Fixtures Cost'
      Jigfixcst,
      @EndUserText.label: 'Surface Area'
      Srfcarea,
      @EndUserText.label: 'No.of Pcs / Pallet'
      Nofpcsperpllt,
      @EndUserText.label: 'No of Pcs/ 20 Ft Container'
      Noofpcspercont,
      @EndUserText.label: 'Additional Accessories Cost '
      Addcst,
      @EndUserText.label: 'Drill/Facing'
      Drlfacing,
      @EndUserText.label: 'Reamrks-PD'
      Remarkspd
}
