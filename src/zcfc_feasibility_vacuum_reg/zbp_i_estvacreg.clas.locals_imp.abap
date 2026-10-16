CLASS lhc_zi_estvacreg DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_estvacreg RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_estvacreg RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_estvacreg~updateheader.

    METHODS updatemeltcost FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_estvacreg~updatemeltcost.

    METHODS updatechrgcost FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_estvacreg~updatechrgcost.

    METHODS updatemetlcost FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_estvacreg~updatemetlcost.

    METHODS updatelabmcost FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_estvacreg~updatelabmcost.

    METHODS updatemaintcost FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_estvacreg~updatemaintcost.

    METHODS updatefetlcost FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_estvacreg~updatefetlcost.

    METHODS updatepaintcost FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_estvacreg~updatepaintcost.

    METHODS updateselexpcost FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_estvacreg~updateselexpcost.

    METHODS updateaccavcost FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_estvacreg~updateaccavcost.

    METHODS checkdata FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_estvacreg~checkdata.

    METHODS checkvalue FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_estvacreg~checkvalue.

ENDCLASS.

CLASS lhc_zi_estvacreg IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
      ENTITY zi_estvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zcds_fesvacreg_f4 WHERE rfqno = @gfs_header-rfqno
    INTO @DATA(loc_final_1).
    IF sy-subrc = 0.
      gfs_header-rfqdate = loc_final_1-rfqdate.
      gfs_header-matcd = loc_final_1-matcd.
      gfs_header-fxdcst_cal = loc_final_1-fxdcst_cal.
      gfs_header-line = loc_final_1-line.
      gfs_header-boxsize1 = loc_final_1-boxsize1.
      gfs_header-boxsize2 = loc_final_1-boxsize2.
      gfs_header-annualqty = loc_final_1-annualqty.
      gfs_header-mouldspd = loc_final_1-mouldspd.
      gfs_header-reqweight = loc_final_1-reqweight.
      gfs_header-noofcav = loc_final_1-noofcav.
      gfs_header-yield = loc_final_1-yield.
      gfs_header-addacccost = loc_final_1-addacccost.
      gfs_header-drillperfacing = loc_final_1-drillperfacing.
      gfs_header-srfcarea = loc_final_1-srfcarea.


      MODIFY ENTITIES OF zi_estvacreg IN LOCAL MODE
      ENTITY zi_estvacreg
      UPDATE
      FIELDS  ( rfqdate matcd fxdcst_cal line boxsize1 boxsize2
                annualqty mouldspd reqweight noofcav
                yield addacccost drillperfacing srfcarea )
      WITH VALUE #( FOR key IN keys
                 ( %tky = gfs_header-%tky
                 rfqdate = gfs_header-rfqdate
                 matcd = gfs_header-matcd
                 fxdcst_cal = gfs_header-fxdcst_cal
                 line = gfs_header-line
                 boxsize1 = gfs_header-boxsize1
                 boxsize2 = gfs_header-boxsize2
                 annualqty = gfs_header-annualqty
                 mouldspd = gfs_header-mouldspd
                 reqweight = gfs_header-reqweight
                 noofcav = gfs_header-noofcav
                 yield = gfs_header-yield
                 addacccost = gfs_header-addacccost
                 drillperfacing = gfs_header-drillperfacing
                 srfcarea = gfs_header-srfcarea

                 %control-rfqdate = if_abap_behv=>mk-on
                 %control-fxdcst_cal = if_abap_behv=>mk-on
                 %control-line = if_abap_behv=>mk-on
                 %control-boxsize1 = if_abap_behv=>mk-on
                 %control-boxsize2 = if_abap_behv=>mk-on
                 %control-annualqty = if_abap_behv=>mk-on
                 %control-mouldspd = if_abap_behv=>mk-on
                 %control-reqweight = if_abap_behv=>mk-on
                 %control-noofcav = if_abap_behv=>mk-on
                 %control-yield = if_abap_behv=>mk-on
                 %control-addacccost = if_abap_behv=>mk-on
                 %control-drillperfacing = if_abap_behv=>mk-on
                 %control-srfcarea = if_abap_behv=>mk-on
                 ) ).

    ENDIF.

  ENDMETHOD.

  METHOD updatemeltcost.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
          ENTITY zi_estvacreg
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE *
      FROM zcds_spcl_cost AS a
      WHERE a~workcode = 'SE-MELT-CT'
      AND  @gfs_header-rfqdate BETWEEN a~datefrom AND a~dateto
      INTO @DATA(loc_final0).
    IF sy-subrc = 0.
      gfs_header-meltingcst = loc_final0-rate.

      MODIFY ENTITIES OF zi_estvacreg IN LOCAL MODE
                                ENTITY zi_estvacreg
                                UPDATE
                                FIELDS  ( meltingcst )

                                WITH VALUE #( FOR key IN keys
                                            ( %tky = gfs_header-%tky
                                              meltingcst = gfs_header-meltingcst

                                              %control-meltingcst = if_abap_behv=>mk-on

                                              ) ).

    ENDIF.

  ENDMETHOD.

  METHOD updatechrgcost.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
          ENTITY zi_estvacreg
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE *
      FROM zcds_spcl_cost AS a
      WHERE a~workcode = 'SE-CH-CT'
      AND  @gfs_header-rfqdate BETWEEN a~datefrom AND a~dateto
      INTO @DATA(loc_final1).
    IF sy-subrc = 0.
      gfs_header-chrgingcst = loc_final1-rate.

      MODIFY ENTITIES OF zi_estvacreg IN LOCAL MODE
                                ENTITY zi_estvacreg
                                UPDATE
                                FIELDS  ( chrgingcst )

                                WITH VALUE #( FOR key IN keys
                                            ( %tky = gfs_header-%tky
                                              chrgingcst = gfs_header-chrgingcst

                                              %control-chrgingcst = if_abap_behv=>mk-on

                                              ) ).

    ENDIF.

  ENDMETHOD.

  METHOD updatemetlcost.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
          ENTITY zi_estvacreg
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE *
      FROM zcds_spcl_cost AS a
      WHERE a~workcode = 'SE-MTL-CT'
      AND  @gfs_header-rfqdate BETWEEN a~datefrom AND a~dateto
      INTO @DATA(loc_final2).
    IF sy-subrc = 0.
      gfs_header-metalcst = loc_final2-rate.

      MODIFY ENTITIES OF zi_estvacreg IN LOCAL MODE
                              ENTITY zi_estvacreg
                              UPDATE
                              FIELDS  ( metalcst )

                              WITH VALUE #( FOR key IN keys
                                          ( %tky = gfs_header-%tky
                                            metalcst = gfs_header-metalcst

                                            %control-metalcst = if_abap_behv=>mk-on

                                            ) ).
    ENDIF.

  ENDMETHOD.


  METHOD updatelabmcost.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
          ENTITY zi_estvacreg
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE *
      FROM zcds_spcl_cost AS a
      WHERE a~workcode = 'SE-LAMD-CT'
      AND  @gfs_header-rfqdate BETWEEN a~datefrom AND a~dateto
      INTO @DATA(loc_final4).
    IF sy-subrc = 0.
      gfs_header-labmldperbx = loc_final4-rate.

      MODIFY ENTITIES OF zi_estvacreg IN LOCAL MODE
                          ENTITY zi_estvacreg
                          UPDATE
                          FIELDS  ( labmldperbx )

                          WITH VALUE #( FOR key IN keys
                                      ( %tky = gfs_header-%tky
                                        labmldperbx = gfs_header-labmldperbx

                                        %control-labmldperbx = if_abap_behv=>mk-on

                                        ) ).
    ENDIF.

  ENDMETHOD.


  METHOD updatemaintcost.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
          ENTITY zi_estvacreg
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE *
      FROM zcds_spcl_cost AS a
      WHERE a~workcode = 'SE-MAIN-CT'
      AND  @gfs_header-rfqdate BETWEEN a~datefrom AND a~dateto
      INTO @DATA(loc_final6).
    IF sy-subrc = 0.
      gfs_header-mntcstperpc = loc_final6-rate.

      MODIFY ENTITIES OF zi_estvacreg IN LOCAL MODE
                      ENTITY zi_estvacreg
                      UPDATE
                      FIELDS  ( mntcstperpc )

                      WITH VALUE #( FOR key IN keys
                                  ( %tky = gfs_header-%tky
                                    mntcstperpc = gfs_header-mntcstperpc

                                    %control-mntcstperpc = if_abap_behv=>mk-on

                                    ) ).
    ENDIF.

  ENDMETHOD.

  METHOD updatefetlcost.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
          ENTITY zi_estvacreg
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE *
      FROM zcds_spcl_cost AS a
      WHERE a~workcode = 'SE-FETT-CT'
      AND  @gfs_header-rfqdate BETWEEN a~datefrom AND a~dateto
      INTO @DATA(loc_final7).
    IF sy-subrc = 0.
      gfs_header-fetcstperpc = loc_final7-rate.

      MODIFY ENTITIES OF zi_estvacreg IN LOCAL MODE
                    ENTITY zi_estvacreg
                    UPDATE
                    FIELDS  ( fetcstperpc )

                    WITH VALUE #( FOR key IN keys
                                ( %tky = gfs_header-%tky
                                  fetcstperpc = gfs_header-fetcstperpc

                                  %control-fetcstperpc = if_abap_behv=>mk-on

                                  ) ).
    ENDIF.

  ENDMETHOD.

  METHOD updatepaintcost.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
          ENTITY zi_estvacreg
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE *
      FROM zcds_spcl_cost AS a
      WHERE a~workcode = 'SE-PANT-CT'
      AND  @gfs_header-rfqdate BETWEEN a~datefrom AND a~dateto
      INTO @DATA(loc_final8).
    IF sy-subrc = 0.
      gfs_header-paintprcst = loc_final8-rate.

      MODIFY ENTITIES OF zi_estvacreg IN LOCAL MODE
                  ENTITY zi_estvacreg
                  UPDATE
                  FIELDS  ( paintprcst )

                  WITH VALUE #( FOR key IN keys
                              ( %tky = gfs_header-%tky
                                paintprcst = gfs_header-paintprcst

                                %control-paintprcst = if_abap_behv=>mk-on

                                ) ).
    ENDIF.

  ENDMETHOD.

  METHOD updateselexpcost.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
          ENTITY zi_estvacreg
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE *
      FROM zcds_spcl_cost AS a
      WHERE a~workcode = 'SE-SLEX-CT'
      AND  @gfs_header-rfqdate BETWEEN a~datefrom AND a~dateto
      INTO @DATA(loc_final9).
    IF sy-subrc = 0.
      gfs_header-sellexpn = loc_final9-rate.

      MODIFY ENTITIES OF zi_estvacreg IN LOCAL MODE
                ENTITY zi_estvacreg
                UPDATE
                FIELDS  ( sellexpn )

                WITH VALUE #( FOR key IN keys
                            ( %tky = gfs_header-%tky
                              sellexpn = gfs_header-sellexpn

                              %control-sellexpn = if_abap_behv=>mk-on

                              ) ).
    ENDIF.

  ENDMETHOD.

  METHOD updateaccavcost.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
          ENTITY zi_estvacreg
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE *
      FROM zcds_spcl_cost AS a
      WHERE a~workcode = 'SE-ACCV-CT'
      AND  @gfs_header-rfqdate BETWEEN a~datefrom AND a~dateto
      INTO @DATA(loc_final10).
    IF sy-subrc = 0.
      gfs_header-acccavity = loc_final10-rate.

      MODIFY ENTITIES OF zi_estvacreg IN LOCAL MODE
              ENTITY zi_estvacreg
              UPDATE
              FIELDS  ( acccavity )

              WITH VALUE #( FOR key IN keys
                          ( %tky = gfs_header-%tky
                            acccavity = gfs_header-acccavity

                            %control-acccavity = if_abap_behv=>mk-on

                            ) ).
    ENDIF.

  ENDMETHOD.


  METHOD checkdata.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
      ENTITY zi_estvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_3).

    LOOP AT lt_data_3 INTO DATA(ls_data_3).

      IF ls_data_3-rejection IS INITIAL OR ls_data_3-tolerance IS INITIAL.

        APPEND VALUE #( %tky = ls_data_3-%tky )
         TO failed-zi_estvacreg.

        APPEND VALUE #(
          %tky        = ls_data_3-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Please enter both Rejection and Tolerance| )
        ) TO reported-zi_estvacreg.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD checkvalue.

    READ ENTITIES OF zi_estvacreg IN LOCAL MODE
      ENTITY zi_estvacreg
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_4).

    LOOP AT lt_data_4 INTO DATA(ls_data_4).

      IF ls_data_4-packrateperkg <= 0.

        APPEND VALUE #( %tky = ls_data_4-%tky )
         TO failed-zi_estvacreg.

        APPEND VALUE #(
          %tky        = ls_data_4-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Packaging Rate/Kg must be greater than 0.000.| )
        ) TO reported-zi_estvacreg.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
