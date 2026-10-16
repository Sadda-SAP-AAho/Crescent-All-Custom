@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Reason Analysis-Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_RERESNREPORT 
  provider contract transactional_query
  as projection on ZI_REJRESNREPORT
{
    @EndUserText.label: 'Shop Floor No'
    @Search.defaultSearchElement: true
    key Shpflrno,
    @UI.hidden: true
    key itemkey,
    @UI.hidden: true
    key orderkey,
    @EndUserText.label: 'Shop Floor Date'
    Shpflrdt,
    @EndUserText.label: 'Plant Code'
    Plant,
    @EndUserText.label: 'Plant Name'
    PlantName,
    @EndUserText.label: 'Department Code'
    Dept,
    @EndUserText.label: 'Department Name'
    Deptname,
    @EndUserText.label: 'Operation Code'
    Opr,
    @EndUserText.label: 'Operation Name'
    Oprname,
    @EndUserText.label: 'Contractor Code'
    Cont,
    @EndUserText.label: 'Contractor Name'
    Contname,
    @EndUserText.label: 'Material No'
    Matnr,
    @EndUserText.label: 'Description'
    Maktx,
    @EndUserText.label: 'Profit Center'
    Profit_Center,
    @EndUserText.label: 'Unit Weight'
    UnitWt,
    @UI.hidden: true
    Wtunit,
    @EndUserText.label: 'Total Cast'
    Totcast,
    @UI.hidden: true
    Meins,
    @EndUserText.label: 'Total Cast Weight'
    Total_Cast_Wt,
    @EndUserText.label: 'Total Good Cast'
    Goodcast,
    @EndUserText.label: 'Total Good Cast Weight'
    Total_Good_Cast_Wt,
    @EndUserText.label: 'Total Rejection'
    Total_RejQty,
    @EndUserText.label: 'Total Rejection Weight'
    Total_Rej_Wt,
    @EndUserText.label: 'BEND'
    TOTAL_BEND,
    @EndUserText.label: 'BLOW HOLES/GAS HOLE/HOLE PROBLEM'
    TOTAL_BLOW,
    @EndUserText.label: 'C.I. CASTINGS'
    TOTAL_CI_CAST,
    @EndUserText.label: 'CHAPLET HIGH'
    TOTAL_CHAPLET,
    @EndUserText.label: 'COLD SHUT/SHORT METAL/COLD METAL'
    TOTAL_COLDSHUT,
    @EndUserText.label: 'CORE SHIFT/CORE MIS-PLACED/KEY PROBLEM'
    TOTAL_CORESHIFT,
    @EndUserText.label: 'CORNER DEFECT'
    TOTAL_CORNERDEFCT,
    @EndUserText.label: 'CRACK'
    TOTAL_CRACK,
    @EndUserText.label: 'DEAD STOCK'
    TOTAL_DEADSTOCK,
    @EndUserText.label: 'DESIGN CHANGED'
    TOTAL_DESCHNG,
    @EndUserText.label: 'DUE TO FLATNESS PROBLEM'
    TOTAL_FLTPRBLM,
    @EndUserText.label: 'DUE TO INSERT SHIFTING'
    TOTAL_INSERTSHIFT,
    @EndUserText.label: 'EXTRA METAL/FINS'
    TOTAL_EXTRAMETAL,
    @EndUserText.label: 'FLANGE BROKEN'
    TOTAL_FLANGEBROKEN,
    @EndUserText.label: 'HARD'
    TOTAL_HARD,
    @EndUserText.label: 'INTERNAL DEFECT'
    TOTAL_INTRNLDFCT,
    @EndUserText.label: 'LESS WT.'
    TOTAL_LESSWT,
    @EndUserText.label: 'LOAD TEST FAIL'
    TOTAL_LDTSTFL,
    @EndUserText.label: 'LOCK PROBLEM'
    TOTAL_LOCKPRBLM
}
