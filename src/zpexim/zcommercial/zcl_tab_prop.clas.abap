CLASS zcl_tab_prop DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   Class-METHODS calc_len
      IMPORTING p_str      TYPE zdt_tab_prop
                no_of_col  TYPE i
      CHANGING  p_tab_prop TYPE zdt_tab_prop.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TAB_PROP IMPLEMENTATION.


  METHOD calc_len.

    DATA: lv_col1  TYPE i,
          lv_col2  TYPE i,
          lv_col3  TYPE i,
          lv_col4  TYPE i,
          lv_col5  TYPE i,
          lv_col6  TYPE i,
          lv_col7  TYPE i,
          lv_col8  TYPE i,
          lv_col9  TYPE i,
          lv_col10 TYPE i,
          lv_col11 TYPE i,
          lv_col12 TYPE i,
          lv_col13 TYPE i,
          lv_col14 TYPE i,
          lv_col15 type i,    "Added by Infocus on 08th Jan 2025
          lv_col16 type i,    "Added by Infocus on 08th Jan 2025
          lv_col17 type i,    "Added by Infocus on 08th Jan 2025
          lv_col18 type i,    "Added by Infocus on 08th Jan 2025
          lv_col19 type i.    "Added by Infocus on 08th Jan 2025


    DATA: lv_min_width          TYPE i VALUE 15,   " Minimum width in mm
          lv_max_total_width    TYPE i VALUE 200, " Maximum total width in mm
          lt_col_lengths        TYPE TABLE OF i WITH DEFAULT KEY, " Table to hold column lengths
          lv_total_length       TYPE i,
          lt_distributed_widths TYPE TABLE OF i WITH DEFAULT KEY,
          lv_remaining_width    TYPE i,
          lv_proportional_width TYPE i,
          lv_total_width        TYPE i,
          lv_adjustment_factor  TYPE f.

*    DATA : lo_cl_width TYPE REF TO zcl_col_width.

    CASE no_of_col.

      WHEN 1.

        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col1 CHANGING p_len = p_tab_prop-col1 p_col1 = lv_col1  ) .


      WHEN 2.

        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col1 CHANGING p_len = p_tab_prop-col1 p_col1 = lv_col1  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col2 CHANGING p_len = p_tab_prop-col2 p_col1 = lv_col2  ) .

        IF ( lv_col1 + lv_col2 ) > 200.
          IF lv_col1 > 100.
            IF lv_col2 < 100.
              p_tab_prop-col1 = '100mm'.
            ELSE.
              p_tab_prop-col1 = '100mm'.
              p_tab_prop-col2 = '100mm'.
            ENDIF.
          ELSEIF lv_col2 > 100.
            IF lv_col1 < 100.
              p_tab_prop-col2 = '100mm'.
            ELSE.
              p_tab_prop-col1 = '100mm'.
              p_tab_prop-col2 = '100mm'.
            ENDIF.
          ENDIF.
        ENDIF.

      WHEN OTHERS.

        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col1 CHANGING p_len = p_tab_prop-col1 p_col1 = lv_col1  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col2 CHANGING p_len = p_tab_prop-col2 p_col1 = lv_col2  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col3 CHANGING p_len = p_tab_prop-col3 p_col1 = lv_col3  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col4 CHANGING p_len = p_tab_prop-col4 p_col1 = lv_col4  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col5 CHANGING p_len = p_tab_prop-col5 p_col1 = lv_col5  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col6 CHANGING p_len = p_tab_prop-col6 p_col1 = lv_col6  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col7 CHANGING p_len = p_tab_prop-col7 p_col1 = lv_col7  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col8 CHANGING p_len = p_tab_prop-col8 p_col1 = lv_col8  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col9 CHANGING p_len = p_tab_prop-col9 p_col1 = lv_col9  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col10 CHANGING p_len = p_tab_prop-col10 p_col1 = lv_col10  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col11 CHANGING p_len = p_tab_prop-col11 p_col1 = lv_col11  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col12 CHANGING p_len = p_tab_prop-col12 p_col1 = lv_col12  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col13 CHANGING p_len = p_tab_prop-col13 p_col1 = lv_col13  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col14 CHANGING p_len = p_tab_prop-col14 p_col1 = lv_col14  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col15 CHANGING p_len = p_tab_prop-col15 p_col1 = lv_col15  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col16 CHANGING p_len = p_tab_prop-col16 p_col1 = lv_col16  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col17 CHANGING p_len = p_tab_prop-col17 p_col1 = lv_col17  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col18 CHANGING p_len = p_tab_prop-col18 p_col1 = lv_col18  ) .
        zcl_col_width=>cal_wid( EXPORTING p_col_txt = p_str-col19 CHANGING p_len = p_tab_prop-col19 p_col1 = lv_col19  ) .
        " Initialize column lengths
        IF lv_col1 <> 0.
          APPEND lv_col1 TO lt_col_lengths.
        ENDIF.

        IF lv_col2 <> 0.
          APPEND lv_col2 TO lt_col_lengths.
        ENDIF.

        IF lv_col3 <> 0.
          APPEND lv_col3 TO lt_col_lengths.
        ENDIF.

        IF lv_col4 <> 0.
          APPEND lv_col4 TO lt_col_lengths.
        ENDIF.

        IF lv_col5 <> 0.
          APPEND lv_col5 TO lt_col_lengths.
        ENDIF.

        IF lv_col6 <> 0.
          APPEND lv_col6 TO lt_col_lengths.
        ENDIF.


        IF lv_col7 <> 0.
          APPEND lv_col7 TO lt_col_lengths.
        ENDIF.

        IF lv_col9 <> 0.
          APPEND lv_col9 TO lt_col_lengths.
        ENDIF.

         IF lv_col10 <> 0.
          APPEND lv_col10 TO lt_col_lengths.
        ENDIF.

         IF lv_col11 <> 0.
          APPEND lv_col11 TO lt_col_lengths.
        ENDIF.

         IF lv_col12 <> 0.
          APPEND lv_col12 TO lt_col_lengths.
        ENDIF.

         IF lv_col13 <> 0.
          APPEND lv_col13 TO lt_col_lengths.
        ENDIF.

         IF lv_col14 <> 0.
          APPEND lv_col14 TO lt_col_lengths.
        ENDIF.


        " Step 1: Calculate the total length of all columns
        lv_total_length = lv_col1 + lv_col2 + lv_col3 + lv_col4 + lv_col5 + lv_col6 + lv_col7 + lv_col8 + lv_col9 + lv_col10 + lv_col11 + lv_col12 + lv_col13 + lv_col14
                          + lv_col15 + lv_col16 + lv_col17 + lv_col18 + lv_col19.

        " Step 2: Calculate the available width after assigning the minimum width to each column
        lv_remaining_width = lv_max_total_width - ( lv_min_width * no_of_col ).

        " Step 3: Distribute the remaining width proportionally based on string length
        LOOP AT lt_col_lengths INTO DATA(lv_col_length).
          lv_proportional_width = ( lv_col_length * lv_remaining_width ) / lv_total_length.
          lv_total_width = lv_min_width + lv_proportional_width.
          APPEND lv_total_width TO lt_distributed_widths.
        ENDLOOP.

        " Step 4: Check if total width exceeds the maximum allowed width and adjust if necessary
        DATA(lv_sum_widths) = REDUCE i( INIT sum = 0 FOR wa IN lt_distributed_widths NEXT sum = sum + wa ).
        IF lv_sum_widths > lv_max_total_width.
          lv_adjustment_factor = lv_max_total_width / lv_sum_widths.
          LOOP AT lt_distributed_widths INTO lv_total_width.
            lv_total_width = lv_total_width * lv_adjustment_factor.
            MODIFY lt_distributed_widths FROM lv_total_width.
          ENDLOOP.
        ENDIF.

*      LOOP AT lt_distributed_widths INTO lv_total_width.
 LOOP AT lt_distributed_widths INTO lv_total_width.
          IF sy-tabix = 1.
            IF lv_col1 < lv_total_width.
              p_tab_prop-col1 = |{ lv_col1 }mm|.
            ELSE.
              p_tab_prop-col1 = |{ lv_total_width }mm|.
            ENDIF.
          ELSEIF sy-tabix = 2.
            IF lv_col2 < lv_total_width.
              p_tab_prop-col2 = |{ lv_col2 }mm|.
            ELSE.
              p_tab_prop-col2 = |{ lv_total_width }mm|.
            ENDIF.
          ELSEIF sy-tabix = 3.
            IF lv_col3 < lv_total_width.
              p_tab_prop-col3 = |{ lv_col3 }mm|.
            ELSE.
              p_tab_prop-col3 = |{ lv_total_width }mm|.
            ENDIF.
          ELSEIF sy-tabix = 4.
            IF lv_col4 < lv_total_width.
              p_tab_prop-col4 = |{ lv_col4 }mm|.
            ELSE.
              p_tab_prop-col4 = |{ lv_total_width }mm|.
            ENDIF.
          ELSEIF sy-tabix = 5.
            IF lv_col5 < lv_total_width.
              p_tab_prop-col5 = |{ lv_col5 }mm|.
            ELSE.
              p_tab_prop-col5 = |{ lv_total_width }mm|.
            ENDIF.
          ELSEIF sy-tabix = 6.
            IF lv_col6 < lv_total_width.
              p_tab_prop-col6 = |{ lv_col6 }mm|.
            ELSE.
              p_tab_prop-col6 = |{ lv_total_width }mm|.
            ENDIF.
          ELSEIF sy-tabix = 7.
            IF lv_col7 < lv_total_width.
              p_tab_prop-col7 = |{ lv_col7 }mm|.
            ELSE.
              p_tab_prop-col7 = |{ lv_total_width }mm|.
            ENDIF.
          ELSEIF sy-tabix = 8.
            IF lv_col8 < lv_total_width.
              p_tab_prop-col8 = |{ lv_col8 }mm|.
            ELSE.
              p_tab_prop-col8 = |{ lv_total_width }mm|.
            ENDIF.
             ELSEIF sy-tabix = 9.
            IF lv_col9 < lv_total_width.
              p_tab_prop-col9 = |{ lv_col9 }mm|.
            ELSE.
              p_tab_prop-col9 = |{ lv_total_width }mm|.
            ENDIF.
             ELSEIF sy-tabix = 10.
            IF lv_col10 < lv_total_width.
              p_tab_prop-col10 = |{ lv_col10 }mm|.
            ELSE.
              p_tab_prop-col10 = |{ lv_total_width }mm|.
            ENDIF.
             ELSEIF sy-tabix = 11.
            IF lv_col11 < lv_total_width.
              p_tab_prop-col11 = |{ lv_col11 }mm|.
            ELSE.
              p_tab_prop-col11 = |{ lv_total_width }mm|.
            ENDIF.
             ELSEIF sy-tabix = 12.
            IF lv_col12 < lv_total_width.
              p_tab_prop-col12 = |{ lv_col12 }mm|.
            ELSE.
              p_tab_prop-col12 = |{ lv_total_width }mm|.
            ENDIF.
             ELSEIF sy-tabix = 13.
            IF lv_col13 < lv_total_width.
              p_tab_prop-col13 = |{ lv_col13 }mm|.
            ELSE.
              p_tab_prop-col13 = |{ lv_total_width }mm|.
            ENDIF.
             ELSEIF sy-tabix = 14.
            IF lv_col14 < lv_total_width.
              p_tab_prop-col14 = |{ lv_col14 }mm|.
            ELSE.
              p_tab_prop-col14 = |{ lv_total_width }mm|.
            ENDIF.
          ENDIF.
        ENDLOOP.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
