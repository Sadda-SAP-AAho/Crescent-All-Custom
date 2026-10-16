CLASS zcl_last_pgi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_last_pgi.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LAST_PGI IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                     FOR HDB
                     LANGUAGE SQLSCRIPT
                     OPTIONS READ-ONLY
                     USING Z_I_LAST_PGI.

  lt_item_3 =
      SELECT *
      FROM Z_I_LAST_PGI;

*Latest PGI Date
  lt_max_date =
      SELECT
          mandt,
          salesorder,
          salesorderitem,
          MAX( pgidate ) AS pgidate
      FROM :lt_item_3
      GROUP BY
          mandt,
          salesorder,
          salesorderitem;

*Highest PGI No on Latest PGI Date
  lt_item =
      SELECT
          a.mandt,
          a.salesorder,
          a.salesorderitem,
          MAX( a.pgino ) AS pgino,
          a.pgidate
      FROM :lt_item_3 AS a
      INNER JOIN :lt_max_date AS b
         ON a.mandt          = b.mandt
        AND a.salesorder     = b.salesorder
        AND a.salesorderitem = b.salesorderitem
        AND a.pgidate        = b.pgidate
      GROUP BY
          a.mandt,
          a.salesorder,
          a.salesorderitem,
          a.pgidate;

  RETURN
      SELECT *
      FROM :lt_item
      ORDER BY
          salesorder,
          salesorderitem;

ENDMETHOD.
ENDCLASS.
