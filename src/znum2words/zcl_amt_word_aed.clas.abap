CLASS zcl_amt_word_aed DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    "--------------------------------------------------------------------
    " Main entry point
    " iv_num      : Amount as string e.g. '1234.56'
    " rv_words    : Integer part in words  e.g. 'One Thousand Two Hundred...'
    " rv_dec_words: Decimal part in words  e.g. 'Fifty Six'
    "--------------------------------------------------------------------
    CLASS-METHODS znumword
      IMPORTING
        VALUE(iv_num)       TYPE string OPTIONAL
      CHANGING
        VALUE(rv_dec_words) TYPE string OPTIONAL
      RETURNING
        VALUE(rv_words)     TYPE string.

  PRIVATE SECTION.
    "--------------------------------------------------------------------
    " Cached word table — loaded ONCE, reused across all recursive calls
    "--------------------------------------------------------------------
    CLASS-DATA gt_numword TYPE STANDARD TABLE OF zdt_numword
                          WITH NON-UNIQUE KEY num.
    CLASS-DATA gv_loaded  TYPE abap_bool VALUE abap_false.

    "--------------------------------------------------------------------
    " Internal recursive helper (works on pure integer input)
    "--------------------------------------------------------------------
    CLASS-METHODS number_to_words
      IMPORTING
        VALUE(iv_int)   TYPE i
      RETURNING
        VALUE(rv_words) TYPE string.

ENDCLASS.



CLASS ZCL_AMT_WORD_AED IMPLEMENTATION.


  METHOD number_to_words.
    "--------------------------------------------------------------------
    " AED uses the International number system:
    "   Hundred  =            100
    "   Thousand =          1,000
    "   Million  =      1,000,000
    "   Billion  =  1,000,000,000
    "--------------------------------------------------------------------

    TYPES: BEGIN OF ty_denom,
             num   TYPE i,
             word  TYPE string,   " used when remainder = 0
             wordx TYPE string,   " used when remainder > 0 (adds 'and')
           END OF ty_denom.

    DATA(ls_hundred)  = VALUE ty_denom( num = 100
                                        word  = 'Hundred'
                                        wordx = 'Hundred and' ).
    DATA(ls_thousand) = VALUE ty_denom( num = 1000
                                        word  = 'Thousand'
                                        wordx = 'Thousand' ).
    DATA(ls_million)  = VALUE ty_denom( num = 1000000
                                        word  = 'Million'
                                        wordx = 'Million' ).
    DATA(ls_billion)  = VALUE ty_denom( num = 1000000000
                                        word  = 'Billion'
                                        wordx = 'Billion' ).

    DATA: ls_denom TYPE ty_denom.
    DATA: ls_row   TYPE zdt_numword.
    DATA: lv_floor TYPE i,
          lv_mod   TYPE i.

    "--------------------------------------------------------------------
    " 0–20: Direct lookup from word table
    "--------------------------------------------------------------------
    IF iv_int <= 20.
      READ TABLE gt_numword INTO ls_row WITH KEY num = iv_int.
      IF sy-subrc = 0.
        rv_words = ls_row-word.
      ENDIF.
      RETURN.
    ENDIF.

    "--------------------------------------------------------------------
    " 21–99: Tens word + units word
    "--------------------------------------------------------------------
    IF iv_int < 100.
      lv_mod   = iv_int MOD 10.
      lv_floor = ( iv_int DIV 10 ) * 10.    " e.g. 47 → floor=40, mod=7

      READ TABLE gt_numword INTO ls_row WITH KEY num = lv_floor.
      DATA(lv_tens) = COND string( WHEN sy-subrc = 0 THEN ls_row-word ELSE '' ).

      IF lv_mod = 0.
        rv_words = lv_tens.
      ELSE.
        READ TABLE gt_numword INTO ls_row WITH KEY num = lv_mod.
        DATA(lv_units) = COND string( WHEN sy-subrc = 0 THEN ls_row-word ELSE '' ).
        rv_words = |{ lv_tens } { lv_units }|.
      ENDIF.
      CONDENSE rv_words.
      RETURN.
    ENDIF.

    "--------------------------------------------------------------------
    " 100+: Determine denomination bracket (AED international system)
    "--------------------------------------------------------------------
    IF    iv_int < ls_thousand-num.
      ls_denom = ls_hundred.
    ELSEIF iv_int < ls_million-num.
      ls_denom = ls_thousand.
    ELSEIF iv_int < ls_billion-num.
      ls_denom = ls_million.
    ELSE.
      ls_denom = ls_billion.
    ENDIF.

    lv_floor = iv_int DIV ls_denom-num.    " e.g. 1,500,000 DIV 1,000,000 = 1
    lv_mod   = iv_int MOD ls_denom-num.    " e.g. 1,500,000 MOD 1,000,000 = 500,000

    DATA(lv_high) = number_to_words( lv_floor ).   " Recursive: left part
    CONDENSE lv_high.

    IF lv_mod = 0.
      rv_words = |{ lv_high } { ls_denom-word }|.
    ELSE.
      DATA(lv_low) = number_to_words( lv_mod ).    " Recursive: right part
      CONDENSE lv_low.
      rv_words = |{ lv_high } { ls_denom-wordx } { lv_low }|.
    ENDIF.

    CONDENSE rv_words.

  ENDMETHOD.


  METHOD znumword.

    "--------------------------------------------------------------------
    " Load word table ONCE per program run (class-level cache)
    "--------------------------------------------------------------------
    IF gv_loaded = abap_false.
      SELECT * FROM zdt_numword INTO TABLE @gt_numword.
      gv_loaded = abap_true.
    ENDIF.

    IF gt_numword IS INITIAL.
      rv_words     = 'Word table not found'.
      rv_dec_words = ''.
      RETURN.
    ENDIF.

    "--------------------------------------------------------------------
    " Split amount into integer and decimal parts
    " e.g. '1234.56' → lv_int = 1234, lv_dec_str = '56'
    "--------------------------------------------------------------------
    DATA: lv_part_int TYPE c LENGTH 20,
          lv_part_dec TYPE c LENGTH 5.

    SPLIT iv_num AT '.' INTO lv_part_int lv_part_dec.

    DATA(lv_int) = CONV i( lv_part_int ).
    DATA(lv_dec) = CONV i( lv_part_dec ).

    "--------------------------------------------------------------------
    " Integer part → words
    "--------------------------------------------------------------------
    rv_words = number_to_words( lv_int ).

    "--------------------------------------------------------------------
    " Decimal part → words (AED: fils, 0–99)
    "--------------------------------------------------------------------
    IF lv_dec = 0.
      rv_dec_words = 'Zero'.
    ELSE.
      rv_dec_words = number_to_words( lv_dec ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
