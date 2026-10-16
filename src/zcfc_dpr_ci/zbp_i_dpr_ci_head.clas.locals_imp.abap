CLASS lhc_zi_dpr_ci_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_dpr_ci_head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_dpr_ci_head RESULT result.

    METHODS upd FOR MODIFY
      IMPORTING keys FOR ACTION zi_dpr_ci_head~upd RESULT result.

    METHODS popudet FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_dpr_ci_head~popudet.

ENDCLASS.

CLASS lhc_zi_dpr_ci_head IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD upd.

  DATA : lt_item     TYPE STANDARD TABLE OF zi_dpr_ci_itm,
           ls_item     TYPE zi_dpr_ci_itm,
           lv_s_date_m TYPE datum,
           lv_e_date_m TYPE datum,
           lv_s_date_y TYPE datum,
           lv_e_date_y TYPE datum,
           lv_year(4)  TYPE c.

    READ ENTITIES OF zi_dpr_ci_head IN LOCAL MODE
                 ENTITY zi_dpr_ci_head
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 FAILED FINAL(header_failed).

    READ ENTITY zi_dpr_ci_head  " IN LOCAL MODE
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(itmdet).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-indate IS NOT INITIAL.
      LOOP AT itmdet INTO DATA(gfs_item).

        MODIFY ENTITIES OF zi_dpr_ci_head IN LOCAL MODE
                    ENTITY zi_dpr_ci_itm
                    DELETE FROM VALUE #( ( plant  =  gfs_item-plant
                                           kostl  = gfs_item-kostl
                                           indate = gfs_item-indate
                                           mtdytd = gfs_item-mtdytd
                                           kostl1 = gfs_item-kostl1 ) ).
        CLEAR : gfs_item.
      ENDLOOP.

      lv_s_date_m = gfs_header-indate+0(6) && '01'.
      lv_e_date_m = gfs_header-indate. "gfs_header-indate+0(6) && '31'.

      IF gfs_header-indate+4(2) = '01' OR gfs_header-indate+4(2) = '02' OR gfs_header-indate+4(2) = '03'.
        lv_year = gfs_header-indate+0(4) - 1.
        lv_s_date_y = lv_year && '0401'.
        lv_e_date_y = gfs_header-indate."gfs_header-indate+0(4) && '0330'.
      ELSE.
        lv_s_date_y = gfs_header-indate+0(4) && '0401'.
        lv_year = gfs_header-indate+0(4) + 1.
        lv_e_date_y = gfs_header-indate. "lv_year && '0330'.
      ENDIF.
      IF gfs_header-kostl <> 'ALL DEPT'.
        "***********
        SELECT SINGLE * FROM zi_dpr_ci_1
        WHERE shpflrdt = @gfs_header-indate AND dept = @gfs_header-kostl
        INTO @DATA(ls_ci_1_d).

        SELECT SINGLE dept, SUM( totalpoured ) AS totalpoured, SUM( mcloss ) AS mcloss,
                      SUM( bunchwtfar ) AS bunchwtfar, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_1
        WHERE ( shpflrdt BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_1_m).

        SELECT SINGLE dept, SUM( totalpoured ) AS totalpoured, SUM( mcloss ) AS mcloss,
                      SUM( bunchwtfar ) AS bunchwtfar, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_1
        WHERE ( shpflrdt BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_1_y).

        """"""""""""""""""""""""""""""""""""""""""""""""
        SELECT SINGLE * FROM zi_dpr_ci_24
        WHERE shpflrdt = @gfs_header-indate AND dept = @gfs_header-kostl
        INTO @DATA(ls_ci_24_d).

        SELECT SINGLE dept, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_24
        WHERE ( shpflrdt BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_24_m).

        SELECT SINGLE dept, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_24
        WHERE ( shpflrdt BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_24_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_2
        WHERE postingdate = @gfs_header-indate AND dept = @gfs_header-kostl
        INTO @DATA(ls_ci_2_d).

        SELECT SINGLE dept, SUM( totalcast ) AS totalcast, SUM( stdgoodcast ) AS stdgoodcast,
                      SUM( actgoodcast ) AS actgoodcast, SUM( bunchwt ) AS bunchwt,
                      SUM( rejwt ) AS rejwt
        FROM zi_dpr_ci_2
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_2_m).

        SELECT SINGLE dept, SUM( totalcast ) AS totalcast, SUM( stdgoodcast ) AS stdgoodcast,
                      SUM( actgoodcast ) AS actgoodcast, SUM( bunchwt ) AS bunchwt,
                      SUM( rejwt ) AS rejwt
        FROM zi_dpr_ci_2
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_2_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_3
        WHERE postingdate = @gfs_header-indate AND dept = @gfs_header-kostl
        INTO @DATA(ls_ci_3_d).

        SELECT SINGLE dept, SUM( seclinerej ) AS seclinerej, SUM( packwt ) AS packwt
        FROM zi_dpr_ci_3
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_3_m).

        SELECT SINGLE dept, SUM( seclinerej ) AS seclinerej, SUM( packwt ) AS packwt
        FROM zi_dpr_ci_3
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_3_y).

        "************
        DATA : lt_dept1 TYPE RANGE OF kostl,
               ls_dept1 LIKE LINE OF lt_dept1.

        SELECT ltrim( kostl, '0' ) AS kostl FROM zdt_cc_type WHERE cctype = 'CI' INTO TABLE @DATA(lt_cc_1).
        CLEAR : lt_dept1[].
        LOOP AT lt_cc_1 INTO DATA(ls_cc_1).
          ls_dept1-sign = 'I'.
          ls_dept1-option = 'EQ'.
          ls_dept1-low = ls_cc_1-kostl.
          APPEND ls_dept1 TO lt_dept1.
          CLEAR : ls_cc_1, ls_dept1.
        ENDLOOP.

        SELECT SINGLE SUM( arpacharg ) AS arpacharg, SUM( rhinocharg ) AS rhinocharg,  SUM( handmochrg ) AS handmochrg
        FROM zi_dpr_ci_6
        WHERE shpflrdt = @gfs_header-indate AND dept IN @lt_dept1
        INTO @DATA(ls_ci_6_d).

        SELECT SINGLE SUM( arpacharg ) AS arpacharg,  SUM( rhinocharg ) AS rhinocharg, SUM( handmochrg ) AS handmochrg
        FROM zi_dpr_ci_6
        WHERE ( shpflrdt BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept1
        INTO @DATA(ls_ci_6_m).

        SELECT SINGLE SUM( arpacharg ) AS arpacharg, SUM( rhinocharg ) AS rhinocharg, SUM( handmochrg ) AS handmochrg
        FROM zi_dpr_ci_6
        WHERE ( shpflrdt BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept1
        INTO @DATA(ls_ci_6_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_4 INTO @DATA(ls_ci_4).

        SELECT SINGLE * FROM zi_dpr_ci_5 INTO @DATA(ls_ci_5).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_9
        WHERE actualgoodsmovementdate = @gfs_header-indate
        INTO @DATA(ls_ci_9_d).

        SELECT SINGLE profitcenter, SUM( despwt ) AS despwt
        FROM zi_dpr_ci_9
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        GROUP BY profitcenter
        INTO @DATA(ls_ci_9_m).

        SELECT SINGLE profitcenter, SUM( despwt ) AS despwt
        FROM zi_dpr_ci_9
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        GROUP BY profitcenter
        INTO @DATA(ls_ci_9_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_10
        WHERE actualgoodsmovementdate = @gfs_header-indate
        INTO @DATA(ls_ci_10_d).

        SELECT SINGLE profitcenter, SUM( ontimdespwt ) AS ontimdespwt
        FROM zi_dpr_ci_10
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        GROUP BY profitcenter
        INTO @DATA(ls_ci_10_m).

        SELECT SINGLE profitcenter, SUM( ontimdespwt ) AS ontimdespwt
        FROM zi_dpr_ci_10
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        GROUP BY profitcenter
        INTO @DATA(ls_ci_10_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_12
        WHERE postingdate = @gfs_header-indate
        INTO @DATA(ls_ci_12_d).

        SELECT SINGLE SUM( stcostactexp ) AS stcostactexp
        FROM zi_dpr_ci_12
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_12_m).

        SELECT SINGLE SUM( stcostactexp ) AS stcostactexp
        FROM zi_dpr_ci_12
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_12_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_13
        WHERE postingdate = @gfs_header-indate
        INTO @DATA(ls_ci_13_d).

        SELECT SINGLE SUM( trtmntcostacc ) AS trtmntcostacc
        FROM zi_dpr_ci_13
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_13_m).

        SELECT SINGLE SUM( trtmntcostacc ) AS trtmntcostacc
        FROM zi_dpr_ci_13
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_13_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_14
        WHERE rptdate = @gfs_header-indate AND dept = @gfs_header-kostl
        INTO @DATA(ls_ci_14_d).

        SELECT SINGLE dept, SUM( actlabexp ) AS actlabexp
        FROM zi_dpr_ci_14
        WHERE ( rptdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_14_m).

        SELECT SINGLE dept, SUM( actlabexp ) AS actlabexp
        FROM zi_dpr_ci_14
        WHERE ( rptdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_14_y).


        "************
        SELECT SINGLE * FROM zi_dpr_ci_15
        WHERE readdate = @gfs_header-indate
        INTO @DATA(ls_ci_15_d).

        SELECT SINGLE SUM( aux ) AS aux, SUM( furnace ) AS furnace
        FROM zi_dpr_ci_15
        WHERE ( readdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_15_m).

        SELECT SINGLE SUM( aux ) AS aux, SUM( furnace ) AS furnace
        FROM zi_dpr_ci_15
        WHERE ( readdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_15_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_16
        WHERE readdate = @gfs_header-indate
        INTO @DATA(ls_ci_16_d).

        SELECT SINGLE SUM( powercostact ) AS powercostact
        FROM zi_dpr_ci_16
        WHERE ( readdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_16_m).

        SELECT SINGLE SUM( powercostact ) AS powercostact
        FROM zi_dpr_ci_16
        WHERE ( readdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_16_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_7
        WHERE postingdate = @gfs_header-indate AND dept = @gfs_header-kostl
        INTO @DATA(ls_ci_7_d).

        SELECT SINGLE dept, SUM( lmgr ) AS lmgr, SUM( lmgrci ) AS lmgrci
        FROM zi_dpr_ci_7
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_7_m).

        SELECT SINGLE dept, SUM( lmgr ) AS lmgr, SUM( lmgrci ) AS lmgrci
        FROM zi_dpr_ci_7
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_7_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_17
        WHERE postingdate = @gfs_header-indate AND dept = @gfs_header-kostl
        INTO @DATA(ls_ci_17_d).

        SELECT SINGLE dept, SUM( comgr ) AS comgr, SUM( comgrci ) AS comgrci
        FROM zi_dpr_ci_17
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_17_m).

        SELECT SINGLE dept, SUM( comgr ) AS comgr, SUM( comgrci ) AS comgrci
        FROM zi_dpr_ci_17
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_17_y).

        "************
        SELECT SINGLE * FROM ZI_DPR_CI_28
        WHERE postingdate = @gfs_header-indate AND dept = @gfs_header-kostl
        INTO @DATA(ls_ci_19_d).

        SELECT SINGLE dept, SUM( stcoststdgi ) AS stcoststdgi, SUM( trtmntcoststd ) AS trtmntcoststd,
                      SUM( powercoststd ) AS powercoststd, SUM( stdlabexp ) AS stdlabexp
        FROM ZI_DPR_CI_28
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_19_m).

        SELECT SINGLE dept, SUM( stcoststdgi ) AS stcoststdgi, SUM( trtmntcoststd ) AS trtmntcoststd,
                      SUM( powercoststd ) AS powercoststd, SUM( stdlabexp ) AS stdlabexp
        FROM ZI_DPR_CI_28
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept = @gfs_header-kostl
        GROUP BY dept
        INTO @DATA(ls_ci_19_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_20
        WHERE postingdate = @gfs_header-indate
        INTO @DATA(ls_ci_20_d).

        SELECT SINGLE SUM( issuevalue ) AS issuevalue, SUM( frrecval ) AS frrecval
        FROM zi_dpr_ci_20
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_20_m).

        SELECT SINGLE SUM( issuevalue ) AS issuevalue, SUM( frrecval ) AS frrecval
        FROM zi_dpr_ci_20
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_20_y).

        ls_item-kostl              = gfs_header-kostl.
        ls_item-kostl1             = gfs_header-kostl.
        ls_item-plant              = gfs_header-plant.
        ls_item-indate             = gfs_header-indate.
        ls_item-vdate              = gfs_header-indate.
        ls_item-mtdytd             = 'Day'.
        ls_item-totalpoured        = ls_ci_1_d-totalpoured.
        ls_item-mcloss             = ls_ci_1_d-mcloss.
        ls_item-bunchwtfar         = ls_ci_1_d-bunchwtfar.
        ls_item-excesswt           = ls_ci_24_d-excesswt.
        ls_item-totalcast          = ls_ci_2_d-totalcast.
        ls_item-stdgoodcast        = ls_ci_2_d-stdgoodcast.
        ls_item-actgoodcast        = ls_ci_2_d-actgoodcast.
        ls_item-bunchwt            = ls_ci_2_d-bunchwt.
        ls_item-rejwt              = ls_ci_2_d-rejwt.
        ls_item-pendcast           = ls_ci_1_d-totalpoured - ls_ci_2_d-totalcast.
        ls_item-seclinerej         = ls_ci_3_d-seclinerej.
        ls_item-packwt             = ls_ci_3_d-packwt.
        IF ls_ci_2_d-totalcast IS NOT INITIAL.
          ls_item-rejper = ( ls_ci_2_d-rejwt / ls_ci_2_d-totalcast ) * 100.
          ls_item-finalrejper = ( ( ls_ci_2_d-rejwt + ls_ci_3_d-seclinerej ) / ls_ci_2_d-totalcast ) * 100.
        ENDIF.
        IF gfs_header-kostl = '110101'.
          ls_item-chargoprn             = ls_ci_6_d-handmochrg.
        ELSEIF gfs_header-kostl = '110101'.
          ls_item-chargoprn             = ls_ci_6_d-arpacharg.
        ELSEIF gfs_header-kostl = '110101'.
          ls_item-chargoprn             = ls_ci_6_d-rhinocharg.
        ENDIF.
        ls_item-spillage              = ls_item-chargoprn - ls_ci_1_d-bunchwtfar.
        IF ls_ci_2_d-bunchwt IS NOT INITIAL.
          ls_item-stdyield = ( ( ls_ci_2_d-totalcast + ls_ci_1_d-mcloss ) / ls_ci_2_d-bunchwt ) * 100.
        ENDIF.
        IF ls_ci_1_d-bunchwtfar IS NOT INITIAL.
          ls_item-stdyieldfar = ( ( ls_ci_1_d-totalpoured + ls_ci_1_d-mcloss ) / ls_ci_1_d-bunchwtfar ) * 100.
        ENDIF.
        IF ls_item-chargoprn IS NOT INITIAL.
          ls_item-yield    = ( ( ls_ci_2_d-actgoodcast + ls_ci_2_d-rejwt ) / ls_item-chargoprn ) * 100.
          ls_item-yieldfar = ( ( ls_ci_1_d-totalpoured + ls_ci_1_d-mcloss ) / ls_item-chargoprn ) * 100.
        ENDIF.
        ls_item-fgstock             = ls_ci_4-fgstock.
        ls_item-sfgstock            = ls_ci_4-sfgstock.
        ls_item-caststock           = ls_ci_4-caststock.
        ls_item-macstock            = ls_ci_4-macstock.
        ls_item-grindstock          = ls_ci_4-grindstock.
        ls_item-paintstock          = ls_ci_4-paintstock.
        ls_item-rmstock             = ls_ci_5-rmstock.
        ls_item-lmstock             = ls_ci_5-lmstock.
        ls_item-despwt              = ls_ci_9_d-despwt.
        ls_item-ontimdespwt         = ls_ci_10_d-ontimdespwt.
        ls_item-stcostactexp        = ls_ci_12_d-stcostactexp.
        ls_item-trtmntcostacc       = ls_ci_13_d-trtmntcostacc.
        ls_item-stdpowerunit        = '838'.
        ls_item-actlabexp           = ls_ci_14_d-actlabexp.
        IF ls_item-chargoprn IS NOT INITIAL.
          ls_item-actpowunitaux     = ls_ci_15_d-aux / ls_item-chargoprn * 1000.
          ls_item-actpoeunitfur     = ls_ci_15_d-furnace / ls_item-chargoprn * 1000.
        ENDIF.
        ls_item-powercostact        = ls_ci_16_d-powercostact.
        IF ls_ci_7_d-lmgr IS NOT INITIAL.
          ls_item-lmcost            = ls_ci_17_d-comgr / ls_ci_7_d-lmgr.
        ENDIF.
        IF ls_ci_7_d-lmgrci IS NOT INITIAL.
          ls_item-lmcostci          = ls_ci_17_d-comgrci / ls_ci_7_d-lmgrci.
        ENDIF.
        ls_item-stcoststdgi         = ls_ci_19_d-stcoststdgi.
        ls_item-trtmntcoststd       = ls_ci_19_d-trtmntcoststd.
        ls_item-powercoststd        = ls_ci_19_d-powercoststd.
        ls_item-stdlabexp           = ls_ci_19_d-stdlabexp.
        ls_item-rejlossval          = ls_ci_20_d-issuevalue - ls_ci_20_d-frrecval.

        APPEND ls_item TO lt_item.
        CLEAR : ls_item, ls_ci_1_d, ls_ci_2_d, ls_ci_3_d, ls_ci_9_d, ls_ci_10_d, ls_ci_12_d, ls_ci_13_d, ls_ci_14_d,
                ls_ci_15_d, ls_ci_16_d, ls_ci_17_d, ls_ci_7_d, ls_ci_19_d, ls_ci_20_d, ls_ci_6_d, ls_ci_24_d.

        ls_item-kostl              = gfs_header-kostl.
        ls_item-kostl1             = gfs_header-kostl.
        ls_item-plant              = gfs_header-plant.
        ls_item-indate             = gfs_header-indate.
        ls_item-mtdytd             = 'MTD'.
        ls_item-totalpoured        = ls_ci_1_m-totalpoured.
        ls_item-mcloss             = ls_ci_1_m-mcloss.
        ls_item-bunchwtfar         = ls_ci_1_m-bunchwtfar.
        ls_item-excesswt           = ls_ci_24_m-excesswt.
        ls_item-totalcast          = ls_ci_2_m-totalcast.
        ls_item-stdgoodcast        = ls_ci_2_m-stdgoodcast.
        ls_item-actgoodcast        = ls_ci_2_m-actgoodcast.
        ls_item-bunchwt            = ls_ci_2_m-bunchwt.
        ls_item-rejwt              = ls_ci_2_m-rejwt.
        ls_item-pendcast           = ls_ci_1_m-totalpoured - ls_ci_2_m-totalcast.
        ls_item-seclinerej         = ls_ci_3_m-seclinerej.
        ls_item-packwt             = ls_ci_3_m-packwt.
        IF ls_ci_2_m-totalcast IS NOT INITIAL.
          ls_item-rejper = ( ls_ci_2_m-rejwt / ls_ci_2_m-totalcast ) * 100.
          ls_item-finalrejper = ( ( ls_ci_2_m-rejwt + ls_ci_3_m-seclinerej ) / ls_ci_2_m-totalcast ) * 100.
        ENDIF.
        IF gfs_header-kostl = '110101'.
          ls_item-chargoprn             = ls_ci_6_m-handmochrg.
        ELSEIF gfs_header-kostl = '110101'.
          ls_item-chargoprn             = ls_ci_6_m-arpacharg.
        ELSEIF gfs_header-kostl = '110101'.
          ls_item-chargoprn             = ls_ci_6_m-rhinocharg.
        ENDIF.
        ls_item-spillage              = ls_item-chargoprn - ls_ci_1_m-bunchwtfar.
        IF ls_ci_2_m-bunchwt IS NOT INITIAL.
          ls_item-stdyield = ( ( ls_ci_2_m-totalcast + ls_ci_1_m-mcloss ) / ls_ci_2_m-bunchwt ) * 100.
        ENDIF.
        IF ls_ci_1_m-bunchwtfar IS NOT INITIAL.
          ls_item-stdyieldfar = ( ( ls_ci_1_m-totalpoured + ls_ci_1_m-mcloss ) / ls_ci_1_m-bunchwtfar ) * 100.
        ENDIF.
        IF ls_item-chargoprn IS NOT INITIAL.
          ls_item-yield    = ( ( ls_ci_2_m-actgoodcast + ls_ci_2_m-rejwt ) / ls_item-chargoprn ) * 100.
          ls_item-yieldfar = ( ( ls_ci_1_m-totalpoured + ls_ci_1_m-mcloss ) / ls_item-chargoprn ) * 100.
        ENDIF.
        ls_item-fgstock             = ls_ci_4-fgstock.
        ls_item-sfgstock            = ls_ci_4-sfgstock.
        ls_item-caststock           = ls_ci_4-caststock.
        ls_item-macstock            = ls_ci_4-macstock.
        ls_item-grindstock          = ls_ci_4-grindstock.
        ls_item-paintstock          = ls_ci_4-paintstock.
        ls_item-rmstock             = ls_ci_5-rmstock.
        ls_item-lmstock             = ls_ci_5-lmstock.
        ls_item-despwt              = ls_ci_9_m-despwt.
        ls_item-ontimdespwt         = ls_ci_10_m-ontimdespwt.
        ls_item-stcostactexp        = ls_ci_12_m.
        ls_item-trtmntcostacc       = ls_ci_13_m.
        ls_item-stdpowerunit        = '838'.
        ls_item-actlabexp           = ls_ci_14_m-actlabexp.
        IF ls_item-chargoprn IS NOT INITIAL.
          ls_item-actpowunitaux       = ls_ci_15_m-aux / ls_item-chargoprn * 1000.
          ls_item-actpoeunitfur       = ls_ci_15_m-furnace / ls_item-chargoprn * 1000.
        ENDIF.
        ls_item-powercostact        = ls_ci_16_m.
        IF ls_ci_7_m-lmgr IS NOT INITIAL.
          ls_item-lmcost       = ls_ci_17_m-comgr / ls_ci_7_m-lmgr.
        ENDIF.
        IF ls_ci_7_m-lmgrci IS NOT INITIAL.
          ls_item-lmcostci     = ls_ci_17_m-comgrci / ls_ci_7_m-lmgrci.
        ENDIF.
        ls_item-stcoststdgi         = ls_ci_19_m-stcoststdgi.
        ls_item-trtmntcoststd       = ls_ci_19_m-trtmntcoststd.
        ls_item-powercoststd        = ls_ci_19_m-powercoststd.
        ls_item-stdlabexp           = ls_ci_19_m-stdlabexp.
        ls_item-rejlossval          = ls_ci_20_m-issuevalue - ls_ci_20_m-frrecval.

        APPEND ls_item TO lt_item.
        CLEAR : ls_item, ls_ci_1_m, ls_ci_2_m, ls_ci_3_m, ls_ci_9_m, ls_ci_10_m, ls_ci_12_m, ls_ci_13_m, ls_ci_14_m,
                ls_ci_15_m, ls_ci_16_m, ls_ci_17_m, ls_ci_7_m, ls_ci_19_m, ls_ci_20_m, ls_ci_6_m, ls_ci_24_m.

        ls_item-kostl              = gfs_header-kostl.
        ls_item-kostl1             = gfs_header-kostl.
        ls_item-plant              = gfs_header-plant.
        ls_item-indate             = gfs_header-indate.
        ls_item-mtdytd             = 'YTD'.
        ls_item-totalpoured        = ls_ci_1_y-totalpoured.
        ls_item-mcloss             = ls_ci_1_y-mcloss.
        ls_item-bunchwtfar         = ls_ci_1_y-bunchwtfar.
        ls_item-excesswt           = ls_ci_24_y-excesswt.
        ls_item-totalcast          = ls_ci_2_y-totalcast.
        ls_item-stdgoodcast        = ls_ci_2_y-stdgoodcast.
        ls_item-actgoodcast        = ls_ci_2_y-actgoodcast.
        ls_item-bunchwt            = ls_ci_2_y-bunchwt.
        ls_item-rejwt              = ls_ci_2_y-rejwt.
        ls_item-pendcast           = ls_ci_1_y-totalpoured - ls_ci_2_y-totalcast.
        ls_item-seclinerej         = ls_ci_3_y-seclinerej.
        ls_item-packwt             = ls_ci_3_y-packwt.
        IF ls_ci_2_y-totalcast IS NOT INITIAL.
          ls_item-rejper = ( ls_ci_2_y-rejwt / ls_ci_2_y-totalcast ) * 100.
          ls_item-finalrejper = ( ( ls_ci_2_y-rejwt + ls_ci_3_y-seclinerej ) / ls_ci_2_y-totalcast ) * 100.
        ENDIF.
        IF gfs_header-kostl = '110101'.
          ls_item-chargoprn             = ls_ci_6_y-handmochrg.
        ELSEIF gfs_header-kostl = '110101'.
          ls_item-chargoprn             = ls_ci_6_y-arpacharg.
        ELSEIF gfs_header-kostl = '110101'.
          ls_item-chargoprn             = ls_ci_6_y-rhinocharg.
        ENDIF.
        ls_item-spillage              = ls_item-chargoprn - ls_ci_1_y-bunchwtfar.
        IF ls_ci_2_y-bunchwt IS NOT INITIAL.
          ls_item-stdyield = ( ( ls_ci_2_y-totalcast + ls_ci_1_y-mcloss ) / ls_ci_2_y-bunchwt ) * 100.
        ENDIF.
        IF ls_ci_1_y-bunchwtfar IS NOT INITIAL.
          ls_item-stdyieldfar = ( ( ls_ci_1_y-totalpoured + ls_ci_1_y-mcloss ) / ls_ci_1_y-bunchwtfar ) * 100.
        ENDIF.
        IF ls_item-chargoprn IS NOT INITIAL.
          ls_item-yield    = ( ( ls_ci_2_y-actgoodcast + ls_ci_2_y-rejwt ) / ls_item-chargoprn ) * 100.
          ls_item-yieldfar = ( ( ls_ci_1_y-totalpoured + ls_ci_1_y-mcloss ) / ls_item-chargoprn ) * 100.
        ENDIF.
        ls_item-fgstock             = ls_ci_4-fgstock.
        ls_item-sfgstock            = ls_ci_4-sfgstock.
        ls_item-caststock           = ls_ci_4-caststock.
        ls_item-macstock            = ls_ci_4-macstock.
        ls_item-grindstock          = ls_ci_4-grindstock.
        ls_item-paintstock          = ls_ci_4-paintstock.
        ls_item-rmstock             = ls_ci_5-rmstock.
        ls_item-lmstock             = ls_ci_5-lmstock.
        ls_item-despwt              = ls_ci_9_y-despwt.
        ls_item-ontimdespwt         = ls_ci_10_y-ontimdespwt.
        ls_item-stcostactexp        = ls_ci_12_y.
        ls_item-trtmntcostacc       = ls_ci_13_y.
        ls_item-stdpowerunit        = '838'.
        ls_item-actlabexp           = ls_ci_14_y-actlabexp.
        IF ls_item-chargoprn IS NOT INITIAL.
          ls_item-actpowunitaux       = ls_ci_15_y-aux / ls_item-chargoprn * 1000.
          ls_item-actpoeunitfur       = ls_ci_15_y-furnace / ls_item-chargoprn * 1000.
        ENDIF.
        ls_item-powercostact        = ls_ci_16_y.
        IF ls_ci_7_y-lmgr IS NOT INITIAL.
          ls_item-lmcost       = ls_ci_17_y-comgr / ls_ci_7_y-lmgr.
        ENDIF.
        IF ls_ci_7_y-lmgrci IS NOT INITIAL.
          ls_item-lmcostci     = ls_ci_17_y-comgrci / ls_ci_7_y-lmgrci.
        ENDIF.
        ls_item-stcoststdgi         = ls_ci_19_y-stcoststdgi.
        ls_item-trtmntcoststd       = ls_ci_19_y-trtmntcoststd.
        ls_item-powercoststd        = ls_ci_19_y-powercoststd.
        ls_item-stdlabexp           = ls_ci_19_y-stdlabexp.
        ls_item-rejlossval          = ls_ci_20_y-issuevalue - ls_ci_20_y-frrecval.

        APPEND ls_item TO lt_item.
        CLEAR : ls_item, ls_ci_1_y, ls_ci_2_y, ls_ci_3_y, ls_ci_4, ls_ci_5, ls_ci_9_y, ls_ci_10_y, ls_ci_12_y, ls_ci_13_y,
                ls_ci_14_y, ls_ci_15_y, ls_ci_16_y, ls_ci_17_y, ls_ci_7_y, ls_ci_19_y, ls_ci_20_y, ls_ci_6_y, ls_ci_24_y.
      ELSE.
        DATA : lt_dept TYPE RANGE OF kostl,
               ls_dept LIKE LINE OF lt_dept.

        SELECT ltrim( kostl, '0' ) AS kostl FROM zdt_cc_type WHERE cctype = 'CI' INTO TABLE @DATA(lt_cc).
        CLEAR : lt_dept[].
        LOOP AT lt_cc INTO DATA(ls_cc1).
          ls_dept-sign = 'I'.
          ls_dept-option = 'EQ'.
          ls_dept-low = ls_cc1-kostl.
          APPEND ls_dept TO lt_dept.
          CLEAR : ls_cc1, ls_dept.
        ENDLOOP.

        SELECT * FROM zi_dpr_ci_1
        WHERE shpflrdt = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO TABLE @DATA(lt_ci_1_d).

        SELECT dept, SUM( totalpoured ) AS totalpoured, SUM( mcloss ) AS mcloss,
                      SUM( bunchwtfar ) AS bunchwtfar, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_1
        WHERE ( shpflrdt BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept " = @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_1_m).

        SELECT dept, SUM( totalpoured ) AS totalpoured, SUM( mcloss ) AS mcloss,
                     SUM( bunchwtfar ) AS bunchwtfar, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_1
        WHERE ( shpflrdt BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_1_y).
        "************
        SELECT * FROM zi_dpr_ci_24
        WHERE shpflrdt = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO TABLE @DATA(lt_ci_24_d).

        SELECT dept, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_24
        WHERE ( shpflrdt BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept " = @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_24_m).

        SELECT dept, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_24
        WHERE ( shpflrdt BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_24_y).

        "************
        SELECT * FROM zi_dpr_ci_2
        WHERE postingdate = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO TABLE @DATA(lt_ci_2_d).

        SELECT dept, SUM( totalcast ) AS totalcast, SUM( stdgoodcast ) AS stdgoodcast,
                      SUM( actgoodcast ) AS actgoodcast, SUM( bunchwt ) AS bunchwt,
                      SUM( rejwt ) AS rejwt
        FROM zi_dpr_ci_2
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept "=@gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_2_m).

        SELECT dept, SUM( totalcast ) AS totalcast, SUM( stdgoodcast ) AS stdgoodcast,
                      SUM( actgoodcast ) AS actgoodcast, SUM( bunchwt ) AS bunchwt,
                      SUM( rejwt ) AS rejwt
        FROM zi_dpr_ci_2
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_2_y).

        "************
        SELECT * FROM zi_dpr_ci_3
        WHERE postingdate = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO TABLE @DATA(lt_ci_3_d).

        SELECT dept, SUM( seclinerej ) AS seclinerej, SUM( packwt ) AS packwt
        FROM zi_dpr_ci_3
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_3_m).

        SELECT dept, SUM( seclinerej ) AS seclinerej, SUM( packwt ) AS packwt
        FROM zi_dpr_ci_3
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_3_y).

        "************
        SELECT SUM( arpacharg ) AS arpacharg, SUM( rhinocharg ) AS rhinocharg,  SUM( handmochrg ) AS handmochrg
        FROM zi_dpr_ci_6
        WHERE shpflrdt = @gfs_header-indate AND dept IN @lt_dept
        INTO TABLE @DATA(lt_ci_6_d).

        SELECT SUM( arpacharg ) AS arpacharg, SUM( rhinocharg ) AS rhinocharg,  SUM( handmochrg ) AS handmochrg
        FROM zi_dpr_ci_6
        WHERE ( shpflrdt BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept
        INTO TABLE @DATA(lt_ci_6_m).

        SELECT SUM( arpacharg ) AS arpacharg, SUM( rhinocharg ) AS rhinocharg,  SUM( handmochrg ) AS handmochrg
        FROM zi_dpr_ci_6
        WHERE ( shpflrdt BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept
        INTO TABLE @DATA(lt_ci_6_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_4 INTO @ls_ci_4.

        SELECT SINGLE * FROM zi_dpr_ci_5 INTO @ls_ci_5.

        "************
        SELECT SINGLE * FROM zi_dpr_ci_9
        WHERE actualgoodsmovementdate = @gfs_header-indate
        INTO @ls_ci_9_d.

        SELECT SINGLE profitcenter, SUM( despwt ) AS despwt
        FROM zi_dpr_ci_9
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        GROUP BY profitcenter
        INTO @ls_ci_9_m.

        SELECT SINGLE profitcenter, SUM( despwt ) AS despwt
        FROM zi_dpr_ci_9
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        GROUP BY profitcenter
        INTO @ls_ci_9_y.

        "************
        SELECT SINGLE * FROM zi_dpr_ci_10
        WHERE actualgoodsmovementdate = @gfs_header-indate
        INTO @ls_ci_10_d.

        SELECT SINGLE profitcenter, SUM( ontimdespwt ) AS ontimdespwt
        FROM zi_dpr_ci_10
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        GROUP BY profitcenter
        INTO @ls_ci_10_m.

        SELECT SINGLE profitcenter, SUM( ontimdespwt ) AS ontimdespwt
        FROM zi_dpr_ci_10
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        GROUP BY profitcenter
        INTO @ls_ci_10_y.

        "************
        SELECT SINGLE * FROM zi_dpr_ci_12
        WHERE postingdate = @gfs_header-indate
        INTO @ls_ci_12_d.

        SELECT SINGLE SUM( stcostactexp ) AS stcostactexp
        FROM zi_dpr_ci_12
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @ls_ci_12_m.

        SELECT SINGLE SUM( stcostactexp ) AS stcostactexp
        FROM zi_dpr_ci_12
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @ls_ci_12_y.

        "************
        SELECT SINGLE * FROM zi_dpr_ci_13
        WHERE postingdate = @gfs_header-indate
        INTO @ls_ci_13_d.

        SELECT SINGLE SUM( trtmntcostacc ) AS trtmntcostacc
        FROM zi_dpr_ci_13
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @ls_ci_13_m.

        SELECT SINGLE SUM( trtmntcostacc ) AS trtmntcostacc
        FROM zi_dpr_ci_13
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @ls_ci_13_y.

        "************
        SELECT * FROM zi_dpr_ci_14
        WHERE rptdate = @gfs_header-indate AND dept IN @lt_dept
        INTO TABLE @DATA(lt_ci_14_d).

        SELECT dept, SUM( actlabexp ) AS actlabexp
        FROM zi_dpr_ci_14
        WHERE ( rptdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_14_m).

        SELECT dept, SUM( actlabexp ) AS actlabexp
        FROM zi_dpr_ci_14
        WHERE ( rptdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_14_y).


        "************
        SELECT SINGLE * FROM zi_dpr_ci_15
        WHERE readdate = @gfs_header-indate
        INTO @ls_ci_15_d.

        SELECT SINGLE SUM( aux ) AS aux, SUM( furnace ) AS furnace
        FROM zi_dpr_ci_15
        WHERE ( readdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @ls_ci_15_m.

        SELECT SINGLE SUM( aux ) AS aux, SUM( furnace ) AS furnace
        FROM zi_dpr_ci_15
        WHERE ( readdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @ls_ci_15_y.

        "************
        SELECT SINGLE * FROM zi_dpr_ci_16
        WHERE readdate = @gfs_header-indate
        INTO @ls_ci_16_d.

        SELECT SINGLE SUM( powercostact ) AS powercostact
        FROM zi_dpr_ci_16
        WHERE ( readdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @ls_ci_16_m.

        SELECT SINGLE SUM( powercostact ) AS powercostact
        FROM zi_dpr_ci_16
        WHERE ( readdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @ls_ci_16_y.

        "************
        SELECT * FROM zi_dpr_ci_7
        WHERE postingdate = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO TABLE @DATA(lt_ci_7_d).

        SELECT dept, SUM( lmgr ) AS lmgr, SUM( lmgrci ) AS lmgrci
        FROM zi_dpr_ci_7
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_7_m).

        SELECT dept, SUM( lmgr ) AS lmgr, SUM( lmgrci ) AS lmgrci
        FROM zi_dpr_ci_7
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_7_y).

        "************
        SELECT * FROM zi_dpr_ci_17
        WHERE postingdate = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO TABLE @DATA(lt_ci_17_d).

        SELECT dept, SUM( comgr ) AS comgr, SUM( comgrci ) AS comgrci
        FROM zi_dpr_ci_17
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_17_m).

        SELECT dept, SUM( comgr ) AS comgr, SUM( comgrci ) AS comgrci
        FROM zi_dpr_ci_17
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_17_y).

        "************
        SELECT * FROM ZI_DPR_ci_28
        WHERE postingdate = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO TABLE @DATA(lt_ci_19_d).

        SELECT dept, SUM( stcoststdgi ) AS stcoststdgi, SUM( trtmntcoststd ) AS trtmntcoststd,
                      SUM( powercoststd ) AS powercoststd, SUM( stdlabexp ) AS stdlabexp
        FROM ZI_DPR_ci_28
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_19_m).

        SELECT dept, SUM( stcoststdgi ) AS stcoststdgi, SUM( trtmntcoststd ) AS trtmntcoststd,
                      SUM( powercoststd ) AS powercoststd, SUM( stdlabexp ) AS stdlabexp
        FROM ZI_DPR_ci_28
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        GROUP BY dept
        INTO TABLE @DATA(lt_ci_19_y).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_20
        WHERE postingdate = @gfs_header-indate
        INTO @ls_ci_20_d.

        SELECT SINGLE SUM( issuevalue ) AS issuevalue, SUM( frrecval ) AS frrecval
        FROM zi_dpr_ci_20
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @ls_ci_20_m.

        SELECT SINGLE SUM( issuevalue ) AS issuevalue, SUM( frrecval ) AS frrecval
        FROM zi_dpr_ci_20
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @ls_ci_20_y.


        LOOP AT lt_cc INTO DATA(ls_cc).
          READ TABLE lt_ci_1_d INTO ls_ci_1_d WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_1_m INTO ls_ci_1_m WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_1_y INTO ls_ci_1_y WITH KEY dept = ls_cc-kostl.

          READ TABLE lt_ci_24_d INTO ls_ci_24_d WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_24_m INTO ls_ci_24_m WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_24_y INTO ls_ci_24_y WITH KEY dept = ls_cc-kostl.

          READ TABLE lt_ci_2_d INTO ls_ci_2_d WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_2_m INTO ls_ci_2_m WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_2_y INTO ls_ci_2_y WITH KEY dept = ls_cc-kostl.

          READ TABLE lt_ci_3_d INTO ls_ci_3_d WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_3_m INTO ls_ci_3_m WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_3_y INTO ls_ci_3_y WITH KEY dept = ls_cc-kostl.

          READ TABLE lt_ci_6_d INTO ls_ci_6_d INDEX 1.
          READ TABLE lt_ci_6_m INTO ls_ci_6_m INDEX 1.
          READ TABLE lt_ci_6_y INTO ls_ci_6_y INDEX 1.

          READ TABLE lt_ci_7_d INTO ls_ci_7_d WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_7_m INTO ls_ci_7_m WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_7_y INTO ls_ci_7_y WITH KEY dept = ls_cc-kostl.

          READ TABLE lt_ci_14_d INTO ls_ci_14_d WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_14_m INTO ls_ci_14_m WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_14_y INTO ls_ci_14_y WITH KEY dept = ls_cc-kostl.

          READ TABLE lt_ci_17_d INTO ls_ci_17_d WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_17_m INTO ls_ci_17_m WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_17_y INTO ls_ci_17_y WITH KEY dept = ls_cc-kostl.

          READ TABLE lt_ci_19_d INTO ls_ci_19_d WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_19_m INTO ls_ci_19_m WITH KEY dept = ls_cc-kostl.
          READ TABLE lt_ci_19_y INTO ls_ci_19_y WITH KEY dept = ls_cc-kostl.

          ls_item-kostl              = gfs_header-kostl.
          ls_item-kostl1             = ls_cc-kostl.
          ls_item-plant              = gfs_header-plant.
          ls_item-indate             = gfs_header-indate.
          ls_item-vdate              = gfs_header-indate.
          ls_item-mtdytd             = 'Day'.
          ls_item-totalpoured        = ls_ci_1_d-totalpoured.
          ls_item-mcloss             = ls_ci_1_d-mcloss.
          ls_item-bunchwtfar         = ls_ci_1_d-bunchwtfar.
          ls_item-excesswt           = ls_ci_24_d-excesswt.
          ls_item-totalcast          = ls_ci_2_d-totalcast.
          ls_item-stdgoodcast        = ls_ci_2_d-stdgoodcast.
          ls_item-actgoodcast        = ls_ci_2_d-actgoodcast.
          ls_item-bunchwt            = ls_ci_2_d-bunchwt.
          ls_item-rejwt              = ls_ci_2_d-rejwt.
          ls_item-pendcast           = ls_ci_1_d-totalpoured - ls_ci_2_d-totalcast.
          ls_item-seclinerej         = ls_ci_3_d-seclinerej.
          ls_item-packwt             = ls_ci_3_d-packwt.
          IF ls_ci_2_d-totalcast IS NOT INITIAL.
            ls_item-rejper = ( ls_ci_2_d-rejwt / ls_ci_2_d-totalcast ) * 100.
            ls_item-finalrejper = ( ( ls_ci_2_d-rejwt + ls_ci_3_d-seclinerej ) / ls_ci_2_d-totalcast ) * 100.
          ENDIF.
          IF ls_cc-kostl = '110101'.
            ls_item-chargoprn             = ls_ci_6_d-handmochrg.
          ELSEIF ls_cc-kostl = '110101'.
            ls_item-chargoprn             = ls_ci_6_d-arpacharg.
          ELSEIF ls_cc-kostl = '110101'.
            ls_item-chargoprn             = ls_ci_6_d-rhinocharg.
          ENDIF.
          ls_item-spillage              = ls_item-chargoprn - ls_ci_1_d-bunchwtfar.
          IF ls_ci_2_d-bunchwt IS NOT INITIAL.
            ls_item-stdyield = ( ( ls_ci_2_d-totalcast + ls_ci_1_d-mcloss ) / ls_ci_2_d-bunchwt ) * 100.
          ENDIF.
          IF ls_ci_1_d-bunchwtfar IS NOT INITIAL.
            ls_item-stdyieldfar = ( ( ls_ci_1_d-totalpoured + ls_ci_1_d-mcloss ) / ls_ci_1_d-bunchwtfar ) * 100.
          ENDIF.
          IF ls_item-chargoprn IS NOT INITIAL.
            ls_item-yield    = ( ( ls_ci_2_d-actgoodcast + ls_ci_2_d-rejwt ) / ls_item-chargoprn ) * 100.
            ls_item-yieldfar = ( ( ls_ci_1_d-totalpoured + ls_ci_1_d-mcloss ) / ls_item-chargoprn ) * 100.
          ENDIF.
          ls_item-fgstock             = ls_ci_4-fgstock.
          ls_item-sfgstock            = ls_ci_4-sfgstock.
          ls_item-caststock           = ls_ci_4-caststock.
          ls_item-macstock            = ls_ci_4-macstock.
          ls_item-grindstock          = ls_ci_4-grindstock.
          ls_item-paintstock          = ls_ci_4-paintstock.
          ls_item-rmstock             = ls_ci_5-rmstock.
          ls_item-rmstock             = ls_ci_5-lmstock.
          ls_item-despwt              = ls_ci_9_d-despwt.
          ls_item-ontimdespwt         = ls_ci_10_d-ontimdespwt.
          ls_item-stcostactexp        = ls_ci_12_d-stcostactexp.
          ls_item-trtmntcostacc       = ls_ci_13_d-trtmntcostacc.
          ls_item-stdpowerunit        = '838'.
          ls_item-actlabexp           = ls_ci_14_d-actlabexp.
          IF ls_item-chargoprn IS NOT INITIAL.
            ls_item-actpowunitaux     = ls_ci_15_d-aux / ls_item-chargoprn * 1000.
            ls_item-actpoeunitfur     = ls_ci_15_d-furnace / ls_item-chargoprn * 1000.
          ENDIF.
          ls_item-powercostact        = ls_ci_16_d-powercostact.
          IF ls_ci_7_d-lmgr IS NOT INITIAL.
            ls_item-lmcost            = ls_ci_17_d-comgr / ls_ci_7_d-lmgr.
          ENDIF.
          IF ls_ci_7_d-lmgrci IS NOT INITIAL.
            ls_item-lmcostci          = ls_ci_17_d-comgrci / ls_ci_7_d-lmgrci.
          ENDIF.
          ls_item-stcoststdgi         = ls_ci_19_d-stcoststdgi.
          ls_item-trtmntcoststd       = ls_ci_19_d-trtmntcoststd.
          ls_item-powercoststd        = ls_ci_19_d-powercoststd.
          ls_item-stdlabexp           = ls_ci_19_d-stdlabexp.
          ls_item-rejlossval          = ls_ci_20_d-issuevalue - ls_ci_20_d-frrecval.

          APPEND ls_item TO lt_item.
          CLEAR : ls_item, ls_ci_1_d, ls_ci_2_d, ls_ci_3_d, ls_ci_6_d, ls_ci_17_d, ls_ci_7_d, ls_ci_19_d, ls_ci_14_d, ls_ci_24_d.

          ls_item-kostl              = gfs_header-kostl.
          ls_item-kostl1             = ls_cc-kostl.
          ls_item-plant              = gfs_header-plant.
          ls_item-indate             = gfs_header-indate.
          ls_item-mtdytd             = 'MTD'.
          ls_item-totalpoured        = ls_ci_1_m-totalpoured.
          ls_item-mcloss             = ls_ci_1_m-mcloss.
          ls_item-bunchwtfar         = ls_ci_1_m-bunchwtfar.
          ls_item-excesswt           = ls_ci_24_m-excesswt.
          ls_item-totalcast          = ls_ci_2_m-totalcast.
          ls_item-stdgoodcast        = ls_ci_2_m-stdgoodcast.
          ls_item-actgoodcast        = ls_ci_2_m-actgoodcast.
          ls_item-bunchwt            = ls_ci_2_m-bunchwt.
          ls_item-rejwt              = ls_ci_2_m-rejwt.
          ls_item-pendcast           = ls_ci_1_m-totalpoured - ls_ci_2_m-totalcast.
          ls_item-seclinerej         = ls_ci_3_m-seclinerej.
          ls_item-packwt             = ls_ci_3_m-packwt.
          IF ls_ci_2_m-totalcast IS NOT INITIAL.
            ls_item-rejper = ( ls_ci_2_m-rejwt / ls_ci_2_m-totalcast ) * 100.
            ls_item-finalrejper = ( ( ls_ci_2_m-rejwt + ls_ci_3_m-seclinerej ) / ls_ci_2_m-totalcast ) * 100.
          ENDIF.
          IF ls_cc-kostl = '110101'.
            ls_item-chargoprn             = ls_ci_6_m-handmochrg.
          ELSEIF ls_cc-kostl = '110101'.
            ls_item-chargoprn             = ls_ci_6_m-arpacharg.
          ELSEIF ls_cc-kostl = '110101'.
            ls_item-chargoprn             = ls_ci_6_m-rhinocharg.
          ENDIF.
          ls_item-spillage              = ls_item-chargoprn - ls_ci_1_m-bunchwtfar.
          IF ls_ci_2_m-bunchwt IS NOT INITIAL.
            ls_item-stdyield = ( ( ls_ci_2_m-totalcast + ls_ci_1_m-mcloss ) / ls_ci_2_m-bunchwt ) * 100.
          ENDIF.
          IF ls_ci_1_m-bunchwtfar IS NOT INITIAL.
            ls_item-stdyieldfar = ( ( ls_ci_1_m-totalpoured + ls_ci_1_m-mcloss ) / ls_ci_1_m-bunchwtfar ) * 100.
          ENDIF.
          IF ls_item-chargoprn IS NOT INITIAL.
            ls_item-yield    = ( ( ls_ci_2_m-actgoodcast + ls_ci_2_m-rejwt ) / ls_item-chargoprn ) * 100.
            ls_item-yieldfar = ( ( ls_ci_1_m-totalpoured + ls_ci_1_m-mcloss ) / ls_item-chargoprn ) * 100.
          ENDIF.
          ls_item-fgstock             = ls_ci_4-fgstock.
          ls_item-sfgstock            = ls_ci_4-sfgstock.
          ls_item-caststock           = ls_ci_4-caststock.
          ls_item-macstock            = ls_ci_4-macstock.
          ls_item-grindstock          = ls_ci_4-grindstock.
          ls_item-paintstock          = ls_ci_4-paintstock.
          ls_item-rmstock             = ls_ci_5-rmstock.
          ls_item-lmstock             = ls_ci_5-lmstock.
          ls_item-despwt              = ls_ci_9_m-despwt.
          ls_item-ontimdespwt         = ls_ci_10_m-ontimdespwt.
          ls_item-stcostactexp        = ls_ci_12_m.
          ls_item-trtmntcostacc       = ls_ci_13_m.
          ls_item-stdpowerunit        = '838'.
          ls_item-actlabexp           = ls_ci_14_m-actlabexp.
          IF ls_item-chargoprn IS NOT INITIAL.
            ls_item-actpowunitaux       = ls_ci_15_m-aux / ls_item-chargoprn * 1000.
            ls_item-actpoeunitfur       = ls_ci_15_m-furnace / ls_item-chargoprn * 1000.
          ENDIF.
          ls_item-powercostact        = ls_ci_16_m.
          IF ls_ci_7_m-lmgr IS NOT INITIAL.
            ls_item-lmcost       = ls_ci_17_m-comgr / ls_ci_7_m-lmgr.
          ENDIF.
          IF ls_ci_7_m-lmgrci IS NOT INITIAL.
            ls_item-lmcostci     = ls_ci_17_m-comgrci / ls_ci_7_m-lmgrci.
          ENDIF.
          ls_item-stcoststdgi         = ls_ci_19_m-stcoststdgi.
          ls_item-trtmntcoststd       = ls_ci_19_m-trtmntcoststd.
          ls_item-powercoststd        = ls_ci_19_m-powercoststd.
          ls_item-stdlabexp           = ls_ci_19_m-stdlabexp.
          ls_item-rejlossval          = ls_ci_20_m-issuevalue - ls_ci_20_m-frrecval.

          APPEND ls_item TO lt_item.
          CLEAR : ls_item, ls_ci_1_m, ls_ci_2_m, ls_ci_3_m, ls_ci_6_m, ls_ci_17_m, ls_ci_7_m, ls_ci_19_m, ls_ci_14_m, ls_ci_24_m.

          ls_item-kostl              = gfs_header-kostl.
          ls_item-kostl1             = ls_cc-kostl.
          ls_item-plant              = gfs_header-plant.
          ls_item-indate             = gfs_header-indate.
          ls_item-mtdytd             = 'YTD'.
          ls_item-totalpoured        = ls_ci_1_y-totalpoured.
          ls_item-mcloss             = ls_ci_1_y-mcloss.
          ls_item-bunchwtfar         = ls_ci_1_y-bunchwtfar.
          ls_item-excesswt           = ls_ci_24_y-excesswt.
          ls_item-totalcast          = ls_ci_2_y-totalcast.
          ls_item-stdgoodcast        = ls_ci_2_y-stdgoodcast.
          ls_item-actgoodcast        = ls_ci_2_y-actgoodcast.
          ls_item-bunchwt            = ls_ci_2_y-bunchwt.
          ls_item-rejwt              = ls_ci_2_y-rejwt.
          ls_item-pendcast           = ls_ci_1_y-totalpoured - ls_ci_2_y-totalcast.
          ls_item-seclinerej         = ls_ci_3_y-seclinerej.
          ls_item-packwt             = ls_ci_3_y-packwt.
          IF ls_ci_2_y-totalcast IS NOT INITIAL.
            ls_item-rejper = ( ls_ci_2_y-rejwt / ls_ci_2_y-totalcast ) * 100.
            ls_item-finalrejper = ( ( ls_ci_2_y-rejwt + ls_ci_3_y-seclinerej ) / ls_ci_2_y-totalcast ) * 100.
          ENDIF.
          IF ls_cc-kostl = '110101'.
            ls_item-chargoprn             = ls_ci_6_y-handmochrg.
          ELSEIF ls_cc-kostl = '110101'.
            ls_item-chargoprn             = ls_ci_6_y-arpacharg.
          ELSEIF ls_cc-kostl = '110101'.
            ls_item-chargoprn             = ls_ci_6_y-rhinocharg.
          ENDIF.
          ls_item-spillage              = ls_item-chargoprn - ls_ci_1_y-bunchwtfar.
          IF ls_ci_2_y-bunchwt IS NOT INITIAL.
            ls_item-stdyield = ( ( ls_ci_2_y-totalcast + ls_ci_1_y-mcloss ) / ls_ci_2_y-bunchwt ) * 100.
          ENDIF.
          IF ls_ci_1_y-bunchwtfar IS NOT INITIAL.
            ls_item-stdyieldfar = ( ( ls_ci_1_y-totalpoured + ls_ci_1_y-mcloss ) / ls_ci_1_y-bunchwtfar ) * 100.
          ENDIF.
          IF ls_item-chargoprn IS NOT INITIAL.
            ls_item-yield    = ( ( ls_ci_2_y-actgoodcast + ls_ci_2_y-rejwt ) / ls_item-chargoprn ) * 100.
            ls_item-yieldfar = ( ( ls_ci_1_y-totalpoured + ls_ci_1_y-mcloss ) / ls_item-chargoprn ) * 100.
          ENDIF.
          ls_item-fgstock             = ls_ci_4-fgstock.
          ls_item-sfgstock            = ls_ci_4-sfgstock.
          ls_item-caststock           = ls_ci_4-caststock.
          ls_item-macstock            = ls_ci_4-macstock.
          ls_item-grindstock          = ls_ci_4-grindstock.
          ls_item-paintstock          = ls_ci_4-paintstock.
          ls_item-rmstock             = ls_ci_5-rmstock.
          ls_item-lmstock             = ls_ci_5-lmstock.
          ls_item-despwt              = ls_ci_9_y-despwt.
          ls_item-ontimdespwt         = ls_ci_10_y-ontimdespwt.
          ls_item-stcostactexp        = ls_ci_12_y.
          ls_item-trtmntcostacc       = ls_ci_13_y.
          ls_item-stdpowerunit        = '838'.
          ls_item-actlabexp           = ls_ci_14_y-actlabexp.
          IF ls_item-chargoprn IS NOT INITIAL.
            ls_item-actpowunitaux       = ls_ci_15_y-aux / ls_item-chargoprn * 1000.
            ls_item-actpoeunitfur       = ls_ci_15_y-furnace / ls_item-chargoprn * 1000.
          ENDIF.
          ls_item-powercostact        = ls_ci_16_y.
          IF ls_ci_7_y-lmgr IS NOT INITIAL.
            ls_item-lmcost       = ls_ci_17_y-comgr / ls_ci_7_y-lmgr.
          ENDIF.
          IF ls_ci_7_y-lmgrci IS NOT INITIAL.
            ls_item-lmcostci     = ls_ci_17_y-comgrci / ls_ci_7_y-lmgrci.
          ENDIF.
          ls_item-stcoststdgi         = ls_ci_19_y-stcoststdgi.
          ls_item-trtmntcoststd       = ls_ci_19_y-trtmntcoststd.
          ls_item-powercoststd        = ls_ci_19_y-powercoststd.
          ls_item-stdlabexp           = ls_ci_19_y-stdlabexp.
          ls_item-rejlossval          = ls_ci_20_y-issuevalue - ls_ci_20_y-frrecval.

          APPEND ls_item TO lt_item.
          CLEAR : ls_item, ls_ci_1_y, ls_ci_2_y, ls_ci_3_y, ls_ci_6_y, ls_ci_17_y, ls_ci_7_y, ls_ci_19_y, ls_ci_14_y, ls_ci_24_y.

          CLEAR : ls_cc.

        ENDLOOP.

        CLEAR : ls_ci_4, ls_ci_5, ls_ci_9_y, ls_ci_10_y, ls_ci_12_y, ls_ci_13_y, ls_ci_14_y, ls_ci_15_y, ls_ci_16_y,
                ls_ci_20_y, ls_ci_9_m, ls_ci_10_m, ls_ci_12_m, ls_ci_13_m, ls_ci_14_m, ls_ci_15_m, ls_ci_16_m, ls_ci_20_m,
                ls_ci_9_d, ls_ci_10_d, ls_ci_12_d, ls_ci_13_d, ls_ci_14_d, ls_ci_15_d, ls_ci_16_d, ls_ci_20_d.


        "Total department Value
        "***********
        SELECT SINGLE SUM( totalpoured ) AS totalpoured, SUM( mcloss ) AS mcloss,
                      SUM( bunchwtfar ) AS bunchwtfar, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_1
        WHERE shpflrdt = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_1_d_1).

        SELECT SINGLE SUM( totalpoured ) AS totalpoured, SUM( mcloss ) AS mcloss,
                      SUM( bunchwtfar ) AS bunchwtfar, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_1
        WHERE ( shpflrdt BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_1_m_1).

        SELECT SINGLE SUM( totalpoured ) AS totalpoured, SUM( mcloss ) AS mcloss,
                      SUM( bunchwtfar ) AS bunchwtfar, SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_1
        WHERE ( shpflrdt BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_1_y_1).

        SELECT SINGLE SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_24
        WHERE shpflrdt = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_24_d_1).

        SELECT SINGLE SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_24
        WHERE ( shpflrdt BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_24_m_1).

        SELECT SINGLE SUM( excesswt ) AS excesswt
        FROM zi_dpr_ci_24
        WHERE ( shpflrdt BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_24_y_1).

        "************
        SELECT SINGLE SUM( totalcast ) AS totalcast, SUM( stdgoodcast ) AS stdgoodcast,
                      SUM( actgoodcast ) AS actgoodcast, SUM( bunchwt ) AS bunchwt,
                      SUM( rejwt ) AS rejwt
        FROM zi_dpr_ci_2
        WHERE postingdate = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_2_d_1).

        SELECT SINGLE SUM( totalcast ) AS totalcast, SUM( stdgoodcast ) AS stdgoodcast,
                      SUM( actgoodcast ) AS actgoodcast, SUM( bunchwt ) AS bunchwt,
                      SUM( rejwt ) AS rejwt
        FROM zi_dpr_ci_2
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_2_m_1).

        SELECT SINGLE SUM( totalcast ) AS totalcast, SUM( stdgoodcast ) AS stdgoodcast,
                      SUM( actgoodcast ) AS actgoodcast, SUM( bunchwt ) AS bunchwt,
                      SUM( rejwt ) AS rejwt
        FROM zi_dpr_ci_2
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_2_y_1).

        "************
        SELECT SINGLE SUM( seclinerej ) AS seclinerej, SUM( packwt ) AS packwt
        FROM zi_dpr_ci_3
        WHERE postingdate = @gfs_header-indate AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_3_d_1).

        SELECT SINGLE SUM( seclinerej ) AS seclinerej, SUM( packwt ) AS packwt
        FROM zi_dpr_ci_3
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_3_m_1).

        SELECT SINGLE SUM( seclinerej ) AS seclinerej, SUM( packwt ) AS packwt
        FROM zi_dpr_ci_3
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept "= @gfs_header-kostl
        INTO @DATA(ls_ci_3_y_1).

        "************
        SELECT SINGLE SUM( arpacharg + rhinocharg + handmochrg ) AS chargoprn
        FROM zi_dpr_ci_6
        WHERE shpflrdt = @gfs_header-indate AND dept IN @lt_dept
        INTO @DATA(ls_ci_6_d_1).

        SELECT SINGLE SUM( arpacharg + rhinocharg + handmochrg ) AS chargoprn
        FROM zi_dpr_ci_6
        WHERE ( shpflrdt BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_6_m_1).

        SELECT SINGLE SUM( arpacharg + rhinocharg + handmochrg ) AS chargoprn
        FROM zi_dpr_ci_6
        WHERE ( shpflrdt BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_6_y_1).

        "************
        SELECT SINGLE * FROM zi_dpr_ci_4 INTO @DATA(ls_ci_4_1).

        SELECT SINGLE * FROM zi_dpr_ci_5 INTO @DATA(ls_ci_5_1).

        "************
        SELECT SINGLE SUM( despwt ) AS despwt FROM zi_dpr_ci_9
        WHERE actualgoodsmovementdate = @gfs_header-indate
        INTO @DATA(ls_ci_9_d_1).

        SELECT SINGLE SUM( despwt ) AS despwt
        FROM zi_dpr_ci_9
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_9_m_1).

        SELECT SINGLE SUM( despwt ) AS despwt
        FROM zi_dpr_ci_9
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_9_y_1).

        "************
        SELECT SINGLE SUM( ontimdespwt ) AS ontimdespwt FROM zi_dpr_ci_10
        WHERE actualgoodsmovementdate = @gfs_header-indate
        INTO @DATA(ls_ci_10_d_1).

        SELECT SINGLE SUM( ontimdespwt ) AS ontimdespwt
        FROM zi_dpr_ci_10
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_10_m_1).

        SELECT SINGLE SUM( ontimdespwt ) AS ontimdespwt
        FROM zi_dpr_ci_10
        WHERE ( actualgoodsmovementdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_10_y_1).

        "************
        SELECT SINGLE SUM( stcostactexp ) AS stcostactexp
        FROM zi_dpr_ci_12
        WHERE postingdate = @gfs_header-indate
        INTO @DATA(ls_ci_12_d_1).

        SELECT SINGLE SUM( stcostactexp ) AS stcostactexp
        FROM zi_dpr_ci_12
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_12_m_1).

        SELECT SINGLE SUM( stcostactexp ) AS stcostactexp
        FROM zi_dpr_ci_12
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_12_y_1).

        "************
        SELECT SINGLE SUM( trtmntcostacc ) AS trtmntcostacc FROM zi_dpr_ci_13
        WHERE postingdate = @gfs_header-indate
        INTO @DATA(ls_ci_13_d_1).

        SELECT SINGLE SUM( trtmntcostacc ) AS trtmntcostacc
        FROM zi_dpr_ci_13
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_13_m_1).

        SELECT SINGLE SUM( trtmntcostacc ) AS trtmntcostacc
        FROM zi_dpr_ci_13
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_13_y_1).

        "************
        SELECT SINGLE SUM( actlabexp ) AS actlabexp
        FROM zi_dpr_ci_14
        WHERE rptdate = @gfs_header-indate AND dept IN @lt_dept
        INTO @DATA(ls_ci_14_d_1).

        SELECT SINGLE SUM( actlabexp ) AS actlabexp
        FROM zi_dpr_ci_14
        WHERE ( rptdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept
        INTO @DATA(ls_ci_14_m_1).

        SELECT SINGLE SUM( actlabexp ) AS actlabexp
        FROM zi_dpr_ci_14
        WHERE ( rptdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept
        INTO @DATA(ls_ci_14_y_1).


        "************
        SELECT SINGLE SUM( aux ) AS aux, SUM( furnace ) AS furnace
        FROM zi_dpr_ci_15
        WHERE readdate = @gfs_header-indate
        INTO @DATA(ls_ci_15_d_1).

        SELECT SINGLE SUM( aux ) AS aux, SUM( furnace ) AS furnace
        FROM zi_dpr_ci_15
        WHERE ( readdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_15_m_1).

        SELECT SINGLE SUM( aux ) AS aux, SUM( furnace ) AS furnace
        FROM zi_dpr_ci_15
        WHERE ( readdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_15_y_1).

        "************
        SELECT SINGLE SUM( powercostact ) AS powercostact
        FROM zi_dpr_ci_16
        WHERE readdate = @gfs_header-indate
        INTO @DATA(ls_ci_16_d_1).

        SELECT SINGLE SUM( powercostact ) AS powercostact
        FROM zi_dpr_ci_16
        WHERE ( readdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_16_m_1).

        SELECT SINGLE SUM( powercostact ) AS powercostact
        FROM zi_dpr_ci_16
        WHERE ( readdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_16_y_1).

        "************
        SELECT SINGLE SUM( lmgr ) AS lmgr, SUM( lmgrci ) AS lmgrci
        FROM zi_dpr_ci_7
        WHERE postingdate = @gfs_header-indate AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_7_d_1).

        SELECT SINGLE SUM( lmgr ) AS lmgr, SUM( lmgrci ) AS lmgrci
        FROM zi_dpr_ci_7
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_7_m_1).

        SELECT SINGLE SUM( lmgr ) AS lmgr, SUM( lmgrci ) AS lmgrci
        FROM zi_dpr_ci_7
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_7_y_1).

        "************
        SELECT SINGLE SUM( comgr ) AS comgr, SUM( comgrci ) AS comgrci
        FROM zi_dpr_ci_17
        WHERE postingdate = @gfs_header-indate AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_17_d_1).

        SELECT SINGLE SUM( comgr ) AS comgr, SUM( comgrci ) AS comgrci
        FROM zi_dpr_ci_17
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_17_m_1).

        SELECT SINGLE SUM( comgr ) AS comgr, SUM( comgrci ) AS comgrci
        FROM zi_dpr_ci_17
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_17_y_1).

        "************
        SELECT SINGLE SUM( stcoststdgi ) AS stcoststdgi, SUM( trtmntcoststd ) AS trtmntcoststd,
                      SUM( powercoststd ) AS powercoststd, SUM( stdlabexp ) AS stdlabexp
        FROM ZI_DPR_ci_28
        WHERE postingdate = @gfs_header-indate AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_19_d_1).

        SELECT SINGLE SUM( stcoststdgi ) AS stcoststdgi, SUM( trtmntcoststd ) AS trtmntcoststd,
                      SUM( powercoststd ) AS powercoststd, SUM( stdlabexp ) AS stdlabexp
        FROM ZI_DPR_ci_28
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m ) AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_19_m_1).

        SELECT SINGLE SUM( stcoststdgi ) AS stcoststdgi, SUM( trtmntcoststd ) AS trtmntcoststd,
                      SUM( powercoststd ) AS powercoststd, SUM( stdlabexp ) AS stdlabexp
        FROM ZI_DPR_ci_28
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y ) AND dept IN @lt_dept " = @gfs_header-kostl
        INTO @DATA(ls_ci_19_y_1).

        "************
        SELECT SINGLE SUM( issuevalue ) AS issuevalue, SUM( frrecval ) AS frrecval
        FROM zi_dpr_ci_20
        WHERE postingdate = @gfs_header-indate
        INTO @DATA(ls_ci_20_d_1).

        SELECT SINGLE SUM( issuevalue ) AS issuevalue, SUM( frrecval ) AS frrecval
        FROM zi_dpr_ci_20
        WHERE ( postingdate BETWEEN @lv_s_date_m  AND @lv_e_date_m )
        INTO @DATA(ls_ci_20_m_1).

        SELECT SINGLE SUM( issuevalue ) AS issuevalue, SUM( frrecval ) AS frrecval
        FROM zi_dpr_ci_20
        WHERE ( postingdate BETWEEN @lv_s_date_y  AND @lv_e_date_y )
        INTO @DATA(ls_ci_20_y_1).

        ls_item-kostl              = gfs_header-kostl.
        ls_item-kostl1             = gfs_header-kostl.
        ls_item-plant              = gfs_header-plant.
        ls_item-indate             = gfs_header-indate.
        ls_item-vdate              = gfs_header-indate.
        ls_item-mtdytd             = 'Day'.
        ls_item-totalpoured        = ls_ci_1_d_1-totalpoured.
        ls_item-mcloss             = ls_ci_1_d_1-mcloss.
        ls_item-bunchwtfar         = ls_ci_1_d_1-bunchwtfar.
        ls_item-excesswt           = ls_ci_24_d_1.
        ls_item-totalcast          = ls_ci_2_d_1-totalcast.
        ls_item-stdgoodcast        = ls_ci_2_d_1-stdgoodcast.
        ls_item-actgoodcast        = ls_ci_2_d_1-actgoodcast.
        ls_item-bunchwt            = ls_ci_2_d_1-bunchwt.
        ls_item-rejwt              = ls_ci_2_d_1-rejwt.
        ls_item-pendcast           = ls_ci_1_d_1-totalpoured - ls_ci_2_d_1-totalcast.
        ls_item-seclinerej         = ls_ci_3_d_1-seclinerej.
        ls_item-packwt             = ls_ci_3_d_1-packwt.
        IF ls_ci_2_d_1-totalcast IS NOT INITIAL.
          ls_item-rejper = ( ls_ci_2_d_1-rejwt / ls_ci_2_d_1-totalcast ) * 100.
          ls_item-finalrejper = ( ( ls_ci_2_d_1-rejwt + ls_ci_3_d_1-seclinerej ) / ls_ci_2_d_1-totalcast ) * 100.
        ENDIF.
        ls_item-chargoprn             = ls_ci_6_d_1.
        ls_item-spillage              = ls_ci_6_d_1 - ls_ci_1_d_1-bunchwtfar.
        IF ls_ci_2_d_1-bunchwt IS NOT INITIAL.
          ls_item-stdyield = ( ( ls_ci_2_d_1-totalcast + ls_ci_1_d_1-mcloss ) / ls_ci_2_d_1-bunchwt ) * 100.
        ENDIF.
        IF ls_ci_1_d_1-bunchwtfar IS NOT INITIAL.
          ls_item-stdyieldfar = ( ( ls_ci_1_d_1-totalpoured + ls_ci_1_d_1-mcloss ) / ls_ci_1_d_1-bunchwtfar ) * 100.
        ENDIF.
        IF ls_ci_6_d_1 IS NOT INITIAL.
          ls_item-yield    = ( ( ls_ci_2_d_1-actgoodcast + ls_ci_2_d_1-rejwt ) / ls_ci_6_d_1 ) * 100.
          ls_item-yieldfar = ( ( ls_ci_1_d_1-totalpoured + ls_ci_1_d_1-mcloss ) / ls_ci_6_d_1 ) * 100.
        ENDIF.
        ls_item-fgstock             = ls_ci_4_1-fgstock.
        ls_item-sfgstock            = ls_ci_4_1-sfgstock.
        ls_item-caststock           = ls_ci_4_1-caststock.
        ls_item-macstock            = ls_ci_4_1-macstock.
        ls_item-grindstock          = ls_ci_4_1-grindstock.
        ls_item-paintstock          = ls_ci_4_1-paintstock.
        ls_item-rmstock             = ls_ci_5_1-rmstock.
        ls_item-lmstock             = ls_ci_5_1-lmstock.
        ls_item-despwt              = ls_ci_9_d_1.
        ls_item-ontimdespwt         = ls_ci_10_d_1.
        ls_item-stcostactexp        = ls_ci_12_d_1.
        ls_item-trtmntcostacc       = ls_ci_13_d_1.
        ls_item-stdpowerunit        = '838'.
        ls_item-actlabexp           = ls_ci_14_d_1.
        IF ls_ci_6_d_1 IS NOT INITIAL.
          ls_item-actpowunitaux     = ls_ci_15_d_1-aux / ls_ci_6_d_1 * 1000.
          ls_item-actpoeunitfur     = ls_ci_15_d_1-furnace / ls_ci_6_d_1 * 1000.
        ENDIF.
        ls_item-powercostact        = ls_ci_16_d_1.
        IF ls_ci_7_d_1-lmgr IS NOT INITIAL.
          ls_item-lmcost            = ls_ci_17_d_1-comgr / ls_ci_7_d_1-lmgr.
        ENDIF.
        IF ls_ci_7_d_1-lmgrci IS NOT INITIAL.
          ls_item-lmcostci          = ls_ci_17_d_1-comgrci / ls_ci_7_d_1-lmgrci.
        ENDIF.
        ls_item-stcoststdgi         = ls_ci_19_d_1-stcoststdgi.
        ls_item-trtmntcoststd       = ls_ci_19_d_1-trtmntcoststd.
        ls_item-powercoststd        = ls_ci_19_d_1-powercoststd.
        ls_item-stdlabexp           = ls_ci_19_d_1-stdlabexp.
        ls_item-rejlossval          = ls_ci_20_d_1-issuevalue - ls_ci_20_d_1-frrecval.

        APPEND ls_item TO lt_item.
        CLEAR : ls_item, ls_ci_1_d_1, ls_ci_2_d_1, ls_ci_3_d_1, ls_ci_9_d_1, ls_ci_10_d_1, ls_ci_12_d_1, ls_ci_13_d_1, ls_ci_14_d_1,
                ls_ci_15_d_1, ls_ci_16_d_1, ls_ci_17_d_1, ls_ci_7_d_1, ls_ci_19_d_1, ls_ci_20_d_1, ls_ci_6_d_1, ls_ci_24_d_1.

        ls_item-kostl              = gfs_header-kostl.
        ls_item-kostl1             = gfs_header-kostl.
        ls_item-plant              = gfs_header-plant.
        ls_item-indate             = gfs_header-indate.
        ls_item-mtdytd             = 'MTD'.
        ls_item-totalpoured        = ls_ci_1_m_1-totalpoured.
        ls_item-mcloss             = ls_ci_1_m_1-mcloss.
        ls_item-bunchwtfar         = ls_ci_1_m_1-bunchwtfar.
        ls_item-excesswt           = ls_ci_24_m_1.
        ls_item-totalcast          = ls_ci_2_m_1-totalcast.
        ls_item-stdgoodcast        = ls_ci_2_m_1-stdgoodcast.
        ls_item-actgoodcast        = ls_ci_2_m_1-actgoodcast.
        ls_item-bunchwt            = ls_ci_2_m_1-bunchwt.
        ls_item-rejwt              = ls_ci_2_m_1-rejwt.
        ls_item-pendcast           = ls_ci_1_m_1-totalpoured - ls_ci_2_m_1-totalcast.
        ls_item-seclinerej         = ls_ci_3_m_1-seclinerej.
        ls_item-packwt             = ls_ci_3_m_1-packwt.
        IF ls_ci_2_m_1-totalcast IS NOT INITIAL.
          ls_item-rejper = ( ls_ci_2_m_1-rejwt / ls_ci_2_m_1-totalcast ) * 100.
          ls_item-finalrejper = ( ( ls_ci_2_m_1-rejwt + ls_ci_3_m_1-seclinerej ) / ls_ci_2_m_1-totalcast ) * 100.
        ENDIF.
        ls_item-chargoprn             = ls_ci_6_m_1.
        ls_item-spillage              = ls_ci_6_m_1 - ls_ci_1_m_1-bunchwtfar.
        IF ls_ci_2_m_1-bunchwt IS NOT INITIAL.
          ls_item-stdyield = ( ( ls_ci_2_m_1-totalcast + ls_ci_1_m_1-mcloss ) / ls_ci_2_m_1-bunchwt ) * 100.
        ENDIF.
        IF ls_ci_1_m_1-bunchwtfar IS NOT INITIAL.
          ls_item-stdyieldfar = ( ( ls_ci_1_m_1-totalpoured + ls_ci_1_m_1-mcloss ) / ls_ci_1_m_1-bunchwtfar ) * 100.
        ENDIF.
        IF ls_ci_6_m_1 IS NOT INITIAL.
          ls_item-yield    = ( ( ls_ci_2_m_1-actgoodcast + ls_ci_2_m_1-rejwt ) / ls_ci_6_m_1 ) * 100.
          ls_item-yieldfar = ( ( ls_ci_1_m_1-totalpoured + ls_ci_1_m_1-mcloss ) / ls_ci_6_m_1 ) * 100.
        ENDIF.
        ls_item-fgstock             = ls_ci_4_1-fgstock.
        ls_item-sfgstock            = ls_ci_4_1-sfgstock.
        ls_item-caststock           = ls_ci_4_1-caststock.
        ls_item-macstock            = ls_ci_4_1-macstock.
        ls_item-grindstock          = ls_ci_4_1-grindstock.
        ls_item-paintstock          = ls_ci_4_1-paintstock.
        ls_item-rmstock             = ls_ci_5_1-rmstock.
        ls_item-lmstock             = ls_ci_5_1-lmstock.
        ls_item-despwt              = ls_ci_9_m_1.
        ls_item-ontimdespwt         = ls_ci_10_m_1.
        ls_item-stcostactexp        = ls_ci_12_m_1.
        ls_item-trtmntcostacc       = ls_ci_13_m_1.
        ls_item-stdpowerunit        = '838'.
        ls_item-actlabexp           = ls_ci_14_m_1.
        IF ls_ci_6_m_1 IS NOT INITIAL.
          ls_item-actpowunitaux       = ls_ci_15_m_1-aux / ls_ci_6_m_1 * 1000.
          ls_item-actpoeunitfur       = ls_ci_15_m_1-furnace / ls_ci_6_m_1 * 1000.
        ENDIF.
        ls_item-powercostact        = ls_ci_16_m_1.
        IF ls_ci_7_m_1-lmgr IS NOT INITIAL.
          ls_item-lmcost       = ls_ci_17_m_1-comgr / ls_ci_7_m_1-lmgr.
        ENDIF.
        IF ls_ci_7_m-lmgrci IS NOT INITIAL.
          ls_item-lmcostci     = ls_ci_17_m_1-comgrci / ls_ci_7_m_1-lmgrci.
        ENDIF.
        ls_item-stcoststdgi         = ls_ci_19_m_1-stcoststdgi.
        ls_item-trtmntcoststd       = ls_ci_19_m_1-trtmntcoststd.
        ls_item-powercoststd        = ls_ci_19_m_1-powercoststd.
        ls_item-stdlabexp           = ls_ci_19_m_1-stdlabexp.
        ls_item-rejlossval          = ls_ci_20_m_1-issuevalue - ls_ci_20_m_1-frrecval.

        APPEND ls_item TO lt_item.
        CLEAR : ls_item, ls_ci_1_m_1, ls_ci_2_m_1, ls_ci_3_m_1, ls_ci_9_m_1, ls_ci_10_m_1, ls_ci_12_m_1, ls_ci_13_m_1, ls_ci_14_m_1,
                ls_ci_15_m_1, ls_ci_16_m_1, ls_ci_17_m_1, ls_ci_7_m_1, ls_ci_19_m_1, ls_ci_20_m_1, ls_ci_6_m_1, ls_ci_24_m_1.

        ls_item-kostl              = gfs_header-kostl.
        ls_item-kostl1             = gfs_header-kostl.
        ls_item-plant              = gfs_header-plant.
        ls_item-indate             = gfs_header-indate.
        ls_item-mtdytd             = 'YTD'.
        ls_item-totalpoured        = ls_ci_1_y_1-totalpoured.
        ls_item-mcloss             = ls_ci_1_y_1-mcloss.
        ls_item-bunchwtfar         = ls_ci_1_y_1-bunchwtfar.
        ls_item-excesswt           = ls_ci_24_y_1.
        ls_item-totalcast          = ls_ci_2_y_1-totalcast.
        ls_item-stdgoodcast        = ls_ci_2_y_1-stdgoodcast.
        ls_item-actgoodcast        = ls_ci_2_y_1-actgoodcast.
        ls_item-bunchwt            = ls_ci_2_y_1-bunchwt.
        ls_item-rejwt              = ls_ci_2_y_1-rejwt.
        ls_item-pendcast           = ls_ci_1_y_1-totalpoured - ls_ci_2_y_1-totalcast.
        ls_item-seclinerej         = ls_ci_3_y_1-seclinerej.
        ls_item-packwt             = ls_ci_3_y_1-packwt.
        IF ls_ci_2_y_1-totalcast IS NOT INITIAL.
          ls_item-rejper = ( ls_ci_2_y_1-rejwt / ls_ci_2_y_1-totalcast ) * 100.
          ls_item-finalrejper = ( ( ls_ci_2_y_1-rejwt + ls_ci_3_y_1-seclinerej ) / ls_ci_2_y_1-totalcast ) * 100.
        ENDIF.
        ls_item-chargoprn             = ls_ci_6_y_1.
        ls_item-spillage              = ls_ci_6_y_1 - ls_ci_1_y_1-bunchwtfar.
        IF ls_ci_2_y_1-bunchwt IS NOT INITIAL.
          ls_item-stdyield = ( ( ls_ci_2_y_1-totalcast + ls_ci_1_y_1-mcloss ) / ls_ci_2_y_1-bunchwt ) * 100.
        ENDIF.
        IF ls_ci_1_y_1-bunchwtfar IS NOT INITIAL.
          ls_item-stdyieldfar = ( ( ls_ci_1_y_1-totalpoured + ls_ci_1_y_1-mcloss ) / ls_ci_1_y_1-bunchwtfar ) * 100.
        ENDIF.
        IF ls_ci_6_y_1 IS NOT INITIAL.
          ls_item-yield    = ( ( ls_ci_2_y_1-actgoodcast + ls_ci_2_y_1-rejwt ) / ls_ci_6_y_1 ) * 100.
          ls_item-yieldfar = ( ( ls_ci_1_y_1-totalpoured + ls_ci_1_y_1-mcloss ) / ls_ci_6_y_1 ) * 100.
        ENDIF.
        ls_item-fgstock             = ls_ci_4_1-fgstock.
        ls_item-sfgstock            = ls_ci_4_1-sfgstock.
        ls_item-caststock           = ls_ci_4_1-caststock.
        ls_item-macstock            = ls_ci_4_1-macstock.
        ls_item-grindstock          = ls_ci_4_1-grindstock.
        ls_item-paintstock          = ls_ci_4_1-paintstock.
        ls_item-rmstock             = ls_ci_5_1-rmstock.
        ls_item-lmstock             = ls_ci_5_1-lmstock.
        ls_item-despwt              = ls_ci_9_y_1.
        ls_item-ontimdespwt         = ls_ci_10_y_1.
        ls_item-stcostactexp        = ls_ci_12_y_1.
        ls_item-trtmntcostacc       = ls_ci_13_y_1.
        ls_item-stdpowerunit        = '838'.
        ls_item-actlabexp           = ls_ci_14_y_1.
        IF ls_ci_6_y_1 IS NOT INITIAL.
          ls_item-actpowunitaux       = ls_ci_15_y_1-aux / ls_ci_6_y_1 * 1000.
          ls_item-actpoeunitfur       = ls_ci_15_y_1-furnace / ls_ci_6_y_1 * 1000 .
        ENDIF.
        ls_item-powercostact        = ls_ci_16_y_1.
        IF ls_ci_7_y_1-lmgr IS NOT INITIAL.
          ls_item-lmcost       = ls_ci_17_y_1-comgr / ls_ci_7_y_1-lmgr.
        ENDIF.
        IF ls_ci_7_y_1-lmgrci IS NOT INITIAL.
          ls_item-lmcostci     = ls_ci_17_y_1-comgrci / ls_ci_7_y_1-lmgrci.
        ENDIF.
        ls_item-stcoststdgi         = ls_ci_19_y_1-stcoststdgi.
        ls_item-trtmntcoststd       = ls_ci_19_y_1-trtmntcoststd.
        ls_item-powercoststd        = ls_ci_19_y_1-powercoststd.
        ls_item-stdlabexp           = ls_ci_19_y_1-stdlabexp.
        ls_item-rejlossval          = ls_ci_20_y_1-issuevalue - ls_ci_20_y_1-frrecval.

        APPEND ls_item TO lt_item.
        CLEAR : ls_item, ls_ci_1_y_1, ls_ci_2_y_1, ls_ci_3_y_1, ls_ci_4_1, ls_ci_5_1, ls_ci_9_y_1, ls_ci_10_y_1, ls_ci_12_y_1, ls_ci_13_y_1,
                ls_ci_14_y_1, ls_ci_15_y_1, ls_ci_16_y_1, ls_ci_17_y_1, ls_ci_7_y_1, ls_ci_19_y_1, ls_ci_20_y_1, ls_ci_6_y_1, ls_ci_24_y_1.
      ENDIF.

      LOOP AT lt_item INTO DATA(ls_itemu).

        MODIFY ENTITIES OF zi_dpr_ci_head IN LOCAL MODE
                       ENTITY zi_dpr_ci_head
                       CREATE BY \_item
                       FROM VALUE #( (  plant = ls_itemu-plant
                                        kostl = ls_itemu-kostl
                                      %target = VALUE #( (     %cid                = ls_itemu-kostl1 && ls_itemu-indate && ls_itemu-mtdytd

                                                               plant               = ls_itemu-plant
                                                               kostl               = ls_itemu-kostl
                                                               indate              = ls_itemu-indate
                                                               mtdytd              = ls_itemu-mtdytd
                                                               kostl1              = ls_itemu-kostl1
                                                               vdate               = ls_itemu-vdate
                                                               totalpoured         = ls_itemu-totalpoured
                                                               mcloss              = ls_itemu-mcloss
                                                               bunchwtfar          = ls_itemu-bunchwtfar
                                                               excesswt            = ls_itemu-excesswt
                                                               totalcast           = ls_itemu-totalcast
                                                               stdgoodcast         = ls_itemu-stdgoodcast
                                                               actgoodcast         = ls_itemu-actgoodcast
                                                               bunchwt             = ls_itemu-bunchwt
                                                               rejwt               = ls_itemu-rejwt
                                                               pendcast            = ls_itemu-pendcast
                                                               seclinerej          = ls_itemu-seclinerej
                                                               packwt              = ls_itemu-packwt
                                                               rejper              = ls_itemu-rejper
                                                               finalrejper         = ls_itemu-finalrejper
                                                               chargoprn           = ls_itemu-chargoprn
                                                               spillage            = ls_itemu-spillage
                                                               stdyield            = ls_itemu-stdyield
                                                               stdyieldfar         = ls_itemu-stdyieldfar
                                                               yield               = ls_itemu-yield
                                                               yieldfar            = ls_itemu-yieldfar
                                                               fgstock             = ls_itemu-fgstock
                                                               sfgstock            = ls_itemu-sfgstock
                                                               caststock           = ls_itemu-caststock
                                                               macstock            = ls_itemu-macstock
                                                               grindstock          = ls_itemu-grindstock
                                                               paintstock          = ls_itemu-paintstock
                                                               rmstock             = ls_itemu-rmstock
                                                               lmstock             = ls_itemu-lmstock
                                                               despwt              = ls_itemu-despwt
                                                               ontimdespwt         = ls_itemu-ontimdespwt
                                                               stcostactexp        = ls_itemu-stcostactexp
                                                               trtmntcostacc       = ls_itemu-trtmntcostacc
                                                               stdpowerunit        = ls_itemu-stdpowerunit
                                                               actlabexp           = ls_itemu-actlabexp
                                                               actpowunitaux       = ls_itemu-actpowunitaux
                                                               actpoeunitfur       = ls_itemu-actpoeunitfur
                                                               powercostact        = ls_itemu-powercostact
                                                               lmcost              = ls_itemu-lmcost
                                                               lmcostci            = ls_itemu-lmcostci
                                                               stcoststdgi         = ls_itemu-stcoststdgi
                                                               trtmntcoststd       = ls_itemu-trtmntcoststd
                                                               powercoststd        = ls_itemu-powercoststd
                                                               stdlabexp           = ls_itemu-stdlabexp
                                                               rejlossval          = ls_itemu-rejlossval

                                                               %control-plant          = if_abap_behv=>mk-on
                                                               %control-kostl          = if_abap_behv=>mk-on
                                                               %control-indate         = if_abap_behv=>mk-on
                                                               %control-mtdytd         = if_abap_behv=>mk-on
                                                               %control-kostl1         = if_abap_behv=>mk-on
                                                               %control-vdate          = if_abap_behv=>mk-on
                                                               %control-totalpoured    = if_abap_behv=>mk-on
                                                               %control-mcloss         = if_abap_behv=>mk-on
                                                               %control-bunchwtfar     = if_abap_behv=>mk-on
                                                               %control-excesswt       = if_abap_behv=>mk-on
                                                               %control-totalcast      = if_abap_behv=>mk-on
                                                               %control-stdgoodcast    = if_abap_behv=>mk-on
                                                               %control-actgoodcast    = if_abap_behv=>mk-on
                                                               %control-bunchwt        = if_abap_behv=>mk-on
                                                               %control-rejwt          = if_abap_behv=>mk-on
                                                               %control-pendcast       = if_abap_behv=>mk-on
                                                               %control-seclinerej     = if_abap_behv=>mk-on
                                                               %control-packwt         = if_abap_behv=>mk-on
                                                               %control-rejper         = if_abap_behv=>mk-on
                                                               %control-finalrejper    = if_abap_behv=>mk-on
                                                               %control-chargoprn      = if_abap_behv=>mk-on
                                                               %control-spillage       = if_abap_behv=>mk-on
                                                               %control-stdyield       = if_abap_behv=>mk-on
                                                               %control-stdyieldfar    = if_abap_behv=>mk-on
                                                               %control-yield          = if_abap_behv=>mk-on
                                                               %control-yieldfar       = if_abap_behv=>mk-on
                                                               %control-fgstock        = if_abap_behv=>mk-on
                                                               %control-sfgstock       = if_abap_behv=>mk-on
                                                               %control-caststock      = if_abap_behv=>mk-on
                                                               %control-macstock       = if_abap_behv=>mk-on
                                                               %control-grindstock     = if_abap_behv=>mk-on
                                                               %control-paintstock     = if_abap_behv=>mk-on
                                                               %control-rmstock        = if_abap_behv=>mk-on
                                                               %control-lmstock        = if_abap_behv=>mk-on
                                                               %control-despwt         = if_abap_behv=>mk-on
                                                               %control-ontimdespwt    = if_abap_behv=>mk-on
                                                               %control-stcostactexp   = if_abap_behv=>mk-on
                                                               %control-trtmntcostacc  = if_abap_behv=>mk-on
                                                               %control-stdpowerunit   = if_abap_behv=>mk-on
                                                               %control-actlabexp      = if_abap_behv=>mk-on
                                                               %control-actpowunitaux  = if_abap_behv=>mk-on
                                                               %control-actpoeunitfur  = if_abap_behv=>mk-on
                                                               %control-powercostact   = if_abap_behv=>mk-on
                                                               %control-lmcost         = if_abap_behv=>mk-on
                                                               %control-lmcostci       = if_abap_behv=>mk-on
                                                               %control-stcoststdgi    = if_abap_behv=>mk-on
                                                               %control-trtmntcoststd  = if_abap_behv=>mk-on
                                                               %control-powercoststd   = if_abap_behv=>mk-on
                                                               %control-stdlabexp      = if_abap_behv=>mk-on
                                                               %control-rejlossval     = if_abap_behv=>mk-on
                                                        ) ) ) )
                                      MAPPED FINAL(ls_mappe21)
                                      FAILED FINAL(ls_failed21)
                                      REPORTED FINAL(ls_reported21).
        CLEAR : ls_itemu.

      ENDLOOP.

    ENDIF.

    READ ENTITY zi_dpr_ci_head  " IN LOCAL MODE
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(itmdet2).

    READ ENTITIES OF zi_dpr_ci_head IN LOCAL MODE
        ENTITY  zi_dpr_ci_head
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).

  ENDMETHOD.

  METHOD popudet.

  DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    READ ENTITIES OF zi_dpr_ci_head IN LOCAL MODE
                   ENTITY zi_dpr_ci_head
                   ALL FIELDS
                   WITH CORRESPONDING #( keys )
                   RESULT DATA(header)
                   FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    gfs_header-lastupdby = sy-uname.

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
    gfs_header-lastupdon = lv_date.
    gfs_header-lastupdat = lv_time.

    MODIFY ENTITIES OF zi_dpr_ci_head IN LOCAL MODE
               ENTITY zi_dpr_ci_head
               UPDATE FIELDS ( lastupdby lastupdon lastupdat )
               WITH VALUE #( ( %tky          = gfs_header-%tky
                               lastupdby     = gfs_header-lastupdby
                               lastupdon     = gfs_header-lastupdon
                               lastupdat     = gfs_header-lastupdat
                           ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_dpr_ci_head DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_dpr_ci_head IMPLEMENTATION.

  METHOD save_modified.

  DATA : lv_flag TYPE flag,
           ls_item TYPE zdt_dpr_ci_itm,
           ls_hdr  TYPE zdt_dpr_ci.
    IF create IS NOT INITIAL.

      DATA(lt_head1) = create-zi_dpr_ci_head.
      IF lt_head1 IS NOT INITIAL.
        READ TABLE lt_head1 INDEX 1 INTO DATA(wa_head1).
        CLEAR : ls_hdr.
        MOVE-CORRESPONDING wa_head1 TO ls_hdr.
        MODIFY zdt_dpr_ci FROM @ls_hdr.
        CLEAR : ls_hdr, wa_head1.
      ENDIF.

      DATA(lt_item1) = create-zi_dpr_ci_itm.
      READ TABLE lt_item1 INTO DATA(ls_item1) INDEX 1.
      DELETE FROM zdt_dpr_ci_itm WHERE plant = @ls_item1-plant AND kostl = @ls_item1-kostl.
      LOOP AT lt_item1 INTO DATA(ls_item_1).
        MOVE-CORRESPONDING ls_item_1 TO ls_item.
        MODIFY zdt_dpr_ci_itm FROM @ls_item.
        CLEAR : ls_item_1 , ls_item.
      ENDLOOP.
      lv_flag = 'X'.
    ENDIF.
    IF update IS NOT INITIAL.
      DATA(lt_head) = update-zi_dpr_ci_head.
      DATA(lt_item2) = update-zi_dpr_ci_itm.

      IF lt_head IS NOT INITIAL.
        READ TABLE lt_head INDEX 1 INTO DATA(wa_head).
        CLEAR : ls_hdr.
        MOVE-CORRESPONDING wa_head TO ls_hdr.
        MODIFY zdt_dpr_ci FROM @ls_hdr.
        CLEAR : ls_hdr, wa_head.
      ENDIF.

      IF lv_flag <> 'X'.
        DELETE FROM zdt_dpr_ci_itm WHERE plant = @ls_item1-plant AND kostl = @ls_item1-kostl.
      ENDIF.
      LOOP AT lt_item2 INTO DATA(ls_item2).
        MOVE-CORRESPONDING ls_item2 TO ls_item.
        MODIFY zdt_dpr_ci_itm FROM @ls_item.
        CLEAR : ls_item1 , ls_item.
      ENDLOOP.

    ENDIF.
    CLEAR : lv_flag.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
