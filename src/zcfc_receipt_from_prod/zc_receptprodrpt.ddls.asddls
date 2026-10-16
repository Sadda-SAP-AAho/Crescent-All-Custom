@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Receipt from Production Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_RECEPTPRODRPT
  provider contract transactional_query
  as projection on ZI_RECEPTPRODRPT
{
    @EndUserText.label: 'Receipt from Production No'
    @Search.defaultSearchElement: true
    key RcptfrmPrdNo,
    @UI.hidden: true
    key Item_Sl_No,
    @UI.hidden: true
    key Refid,
    @EndUserText.label: 'Receipt from Production Date'
    RcptfrmPrdDt,
    @EndUserText.label: 'Creation Date'
    CreationDate,
    @EndUserText.label: 'Operation Code'
    Opr_Code,
    @EndUserText.label: 'Operation Name'
    Opr_Name,
    @EndUserText.label: 'Depertment Code'
    Dept_Code,
    @EndUserText.label: 'Depertment Name'
    Dept_Name,
    @EndUserText.label: 'Contractor Code'
    Cont_Code,
    @EndUserText.label: 'Contractor Name'
    Cont_Name,
    @EndUserText.label: 'Plant Code'
    Plant_Code,
    @EndUserText.label: 'Plant Name'
    Plant_Name,
    @EndUserText.label: 'Material No'
    Mat_Code,
    @EndUserText.label: 'Description'
    Mat_Name,
    @EndUserText.label: 'Profit Center'
    Profit_Center,
    @EndUserText.label: 'Type of Mould'
    typeofmould,
    @UI.hidden: true
    WeightUnit,
    @EndUserText.label: 'Standard Weight'
    Std_Wt,
    @EndUserText.label: 'Actual Weight'
    Act_Wt,
    @EndUserText.label: 'Qty/Box'
    Qty_Box,
    @UI.hidden: true
    Meins,
    @EndUserText.label: 'Box Production'
    Box_Prod,
    @EndUserText.label: 'Total Cast Qty'
    Total_Cast_Qty,
    @EndUserText.label: 'Good Cast Qty'
    Good_Cast_Qty,
    @EndUserText.label: 'Rejection Qty'
    Rej_Qty,
    @EndUserText.label: 'Total Cast Weight'
    Total_Cast_Wt,
    @EndUserText.label: 'Good Cast Weight'
    Good_Cast_Wt,
    @EndUserText.label: 'Actual Good Cast Weight'
    Act_Good_Cast_Wt,
    @EndUserText.label: 'Rejection Weight'
    Rej_Wt,
    @EndUserText.label: 'Gross Weight'
    GrossWeight,
    @EndUserText.label: 'Bunch Weight'
    Bunch_Wt,
    @EndUserText.label: 'Shop Floor No'
    Shop_floor_No,
    @EndUserText.label: 'Shop Floor Date'
    Shop_floor_Dt
}
