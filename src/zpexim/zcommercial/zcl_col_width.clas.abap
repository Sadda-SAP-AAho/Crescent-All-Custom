CLASS zcl_col_width DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS cal_wid
      IMPORTING p_col_txt TYPE char100
      CHANGING  p_len     TYPE char100
                p_col1    TYPE i .


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_COL_WIDTH IMPLEMENTATION.


  METHOD cal_wid.

    DATA: lv_col1 TYPE i.

    IF p_col_txt IS NOT INITIAL.
      lv_col1 = strlen( p_col_txt ).
      IF lv_col1 <= 4.
        p_len = '10mm'.
        p_col1 = 10.
      ELSEIF lv_col1 <= 8.
        p_len = '20mm'.
        p_col1 = 20.
      ELSEIF lv_col1 <= 12.
        p_len = '30mm'.
        p_col1 = 30.
      ELSEIF lv_col1 <= 16.
        p_len = '40mm'.
        p_col1 = 40.
      ELSEIF lv_col1 <= 20.
        p_len = '50mm'.
        p_col1 = 50.
      ELSEIF lv_col1 <= 24.
        p_len = '60mm'.
        p_col1 = 60.
      ELSEIF lv_col1 <= 28.
        p_len = '70mm'.
        p_col1 = 70.
      ELSEIF lv_col1 <= 32.
        p_len = '80mm'.
        p_col1 = 80.
      ELSEIF lv_col1 <= 36.
        p_len = '90mm'.
        p_col1 = 90.
      ELSEIF lv_col1 <= 40.
        p_len = '100mm'.
        p_col1 = 100.
      ELSEIF lv_col1 <= 44.
        p_len = '110mm'.
        p_col1 = 110.
      ELSEIF lv_col1 <= 48.
        p_len = '120mm'.
        p_col1 = 120.
      ELSEIF lv_col1 <= 52.
        p_len = '130mm'.
        p_col1 = 130.
      ELSEIF lv_col1 <= 56.
        p_len = '140mm'.
        p_col1 = 140.
      ELSEIF lv_col1 <= 60.
        p_len = '150mm'.
        p_col1 = 150.
      ELSEIF lv_col1 <= 64.
        p_len = '160mm'.
        p_col1 = 160.
      ELSEIF lv_col1 <= 68.
        p_len = '170mm'.
        p_col1 = 170.
      ELSEIF lv_col1 <= 72.
        p_len = '180mm'.
        p_col1 = 180.
      ELSEIF lv_col1 <= 76.
        p_len = '190mm'.
        p_col1 = 190.
      ELSEIF lv_col1 <= 78.
        p_len = '200mm'.
        p_col1 = 200.
      ELSEIF lv_col1 <= 80.
        p_len = '200mm'.
        p_col1 = 200.

      ELSEIF lv_col1 > 80.
        p_len = '210mm'.
        p_col1 = 210.
      ENDIF.
    ELSE.
      p_len = '0mm'.
      p_col1 = 0.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
