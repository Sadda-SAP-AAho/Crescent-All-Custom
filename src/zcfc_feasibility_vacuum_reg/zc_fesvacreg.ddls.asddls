@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View of Feasibility VAC Reg'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_FESVACREG
  provider contract transactional_query
  as projection on ZI_FESVACREG
{

      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Format No.'
      Formatno,
      @EndUserText.label: 'Rev No./ Date'
      Revnodate,
      @EndUserText.label: 'Issue No./Date'
      Issuenodate,
      @EndUserText.label: 'Prepared Dt.'
      Prepdate,
      @EndUserText.label: 'RFQ No'
      Rfqno,
      @EndUserText.label: 'RFQ Date'
      Rfqdate,
      @EndUserText.label: 'Drawing No'
      Matcd,
      @EndUserText.label: 'Customer Code-Existing'
      Custcd,
      @EndUserText.label: 'Customer Code-New'
      Custcd2,
      @EndUserText.label: 'Customer Name'
      Custname,
      @EndUserText.label: 'Marketing User'
      Mktgusr,
      @EndUserText.label: 'Annual Qty'
      Annualqty,
      @EndUserText.label: 'Paint'
      Paintinfo,
      @EndUserText.label: 'Process'
      Process,
      @EndUserText.label: 'Packaging'
      Packaging,
      @EndUserText.label: 'Child Part'
      Childpart,
      @EndUserText.label: 'Special Requirement(UT/NDT/ETC.)'
      Spclrqmnt,
      @EndUserText.label: '2D Weight (Kg)'
      Weight_2d,
      @EndUserText.label: '3D Wt  as per 7.1(Kg)'
      Weight_3d,
      @EndUserText.label: '2D/3D Wt Tolerance(+)'
      Ptolrnce,
      @EndUserText.label: '2D/3D Wt Tolerance(-)'
      Ntolrnce,
      @EndUserText.label: 'Tolerance Parameter'
      Tolrncepm,
      @EndUserText.label: 'CT Tolerance Std'
      Stdtolrdim,
      @EndUserText.label: 'Material/Grade'
      Gjl,
      @EndUserText.label: 'Remarks-Marketing'
      Remarksmkt,
      @EndUserText.label: 'PD User'
      Pduser,
      @EndUserText.label: 'Costing Date'
      costdate,
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
      @EndUserText.label: '2D Weight'
      Pd2d,
      @EndUserText.label: '3D Weight'
      Pd3d,
      @EndUserText.label: 'Remarks for Density'
      Remarkdensity,
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
      @EndUserText.label: 'Child Part(Cost)'
      Chldprtcst,
      @EndUserText.label: 'Special Requirement(Cost)'
      Spclrqcst,
      @EndUserText.label: 'Machining Cost'
      Drlfacing,
      @EndUserText.label: 'Pallets Weight'
      Palletwt,
      @EndUserText.label: 'Reamrks-PD'
      Remarkspd,
      @UI.hidden: true
      editflag --,
      //      Attachment,
      //      Mimetype,
      //      Filename
}
