CLASS zcl_mat_open_stock DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_stock,
             material         TYPE string,
             plant            TYPE string,
             storage_location TYPE string,
             open_stk_qty     TYPE p LENGTH 15 DECIMALS 3,
           END OF ty_stock.

    TYPES: tt_stock TYPE STANDARD TABLE OF ty_stock WITH KEY material plant storage_location.

    " Method to get opening stock (automatically previous day)
    CLASS-METHODS get_opening_stock
      IMPORTING
        VALUE(iv_date)  TYPE zde_date
      RETURNING
        VALUE(rt_stock) TYPE tt_stock.

ENDCLASS.



CLASS ZCL_MAT_OPEN_STOCK IMPLEMENTATION.


  METHOD get_opening_stock.

    " Subtract 1 day to get previous day
    DATA(lv_prev_date) = iv_date - 1.

    " Fetch opening stock from CDS view for previous day
    SELECT product,
           plant,
           storagelocation,
           openstkqty
      FROM zi_matlopstck( p_date_low = @lv_prev_date )
      INTO TABLE @rt_stock.

    " No WRITE statements allowed in Cloud ABAP
    " rt_stock will be empty if no records found

  ENDMETHOD.
ENDCLASS.
