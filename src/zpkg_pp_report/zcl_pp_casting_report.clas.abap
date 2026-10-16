CLASS zcl_pp_casting_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_rate FOR TABLE FUNCTION ztf_pp_casting_report.

    class-METHODS sort_data for table function ztf_pp_casting_report_sort.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_CASTING_REPORT IMPLEMENTATION.


  METHOD get_rate BY DATABASE
                  FUNCTION FOR HDB
                  LANGUAGE SQLSCRIPT
                  OPTIONS READ-ONLY
                  USING Z_I_PP_CASTING_RPT.

    lt_data =  select DISTINCT mandt, activitytype, costratefixedamount,
                               ValidityStartFiscalPeriod, validityendfiscalperiod,
                               validitystartfiscalyear, validityendfiscalyear, validitystartdate, validityenddate,
                               costcenter
                FROM Z_I_PP_CASTING_RPT ;

      RETURN  select *
       from :lt_data
     ORDER BY activitytype asc;



  ENDMETHOD.


  METHOD SORT_DATA BY DATABASE
                  FUNCTION FOR HDB
                  LANGUAGE SQLSCRIPT
                  OPTIONS READ-ONLY
                  USING zcds_pp_casting_sorted.

                  lt_sort_data = select DISTINCT *
                  from zcds_pp_casting_sorted;

               RETURN  select *
       from :lt_sort_data
     ORDER BY matnr, shpflrno, ManufacturingOrder, ManufacturingOrderOperation_2, materialdocument, MaterialDocumentYear, GoodsMovementType  asc;

  ENDMETHOD.
ENDCLASS.
