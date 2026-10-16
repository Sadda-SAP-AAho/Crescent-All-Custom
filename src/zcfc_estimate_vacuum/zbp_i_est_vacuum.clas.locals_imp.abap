CLASS lhc_zi_est_vacuum DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_est_vacuum RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_est_vacuum RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_est_vacuum~updateheader.

    METHODS Upd FOR MODIFY
      IMPORTING keys FOR ACTION zi_est_vacuum~Upd RESULT result.

ENDCLASS.

CLASS lhc_zi_est_vacuum IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.
    READ ENTITIES OF zi_est_vacuum IN LOCAL MODE
        ENTITY zi_est_vacuum
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE *
    FROM zcds_feasvacuum_f4
    WHERE matcd = @gfs_header-matcd
    INTO @DATA(loc_final1).
    IF sy-subrc = 0.
      gfs_header-line = loc_final1-typofmld.
      gfs_header-boxsize1 = loc_final1-boxsize1.
      gfs_header-boxsize2 = loc_final1-boxsize2.
      gfs_header-annualqty = loc_final1-annualqty.
      gfs_header-mouldspd = loc_final1-mouldspd.
      gfs_header-reqweight = loc_final1-reqweight.
      gfs_header-noofcav = loc_final1-noofcav.
      gfs_header-yield = loc_final1-yield.
      gfs_header-addacccost = loc_final1-addacccost.
      gfs_header-drillperfacing = loc_final1-drillperfacing.
      gfs_header-srfcarea = loc_final1-srfcarea.
      gfs_header-srfcarea = loc_final1-srfcarea.
      gfs_header-tonnagecal = loc_final1-tonnagecal.
      gfs_header-wgtprbxcal = loc_final1-wgtprbxcal.
      gfs_header-wgtprbxcal = loc_final1-wgtprbxcal.
      gfs_header-mltngcstmtcal = loc_final1-mltngcstmtcal.
      gfs_header-totlcstmtcal = loc_final1-totlcstmtcal.
      gfs_header-totlcsttolcal = loc_final1-totlcsttolcal.
      gfs_header-mtlcstprpccal = loc_final1-mtlcstprpccal.
      gfs_header-labmldprbxcal = loc_final1-labmldperbxcal.
      gfs_header-mntprpccal = loc_final1-mntprpccal.
      gfs_header-fetcstprpccal = loc_final1-fetcstprpccal.
      gfs_header-cstmldprmtcal = loc_final1-cstmldprmtcal.
      gfs_header-pntprmrcstcal = loc_final1-pntprmrcstcal.

    ENDIF.


    MODIFY ENTITIES OF zi_est_vacuum IN LOCAL MODE
      ENTITY zi_est_vacuum
      UPDATE
      FIELDS ( line boxsize1 boxsize2 annualqty mouldspd reqweight noofcav yield
               addacccost drillperfacing tonnagecal wgtprbxcal mltngcstmtcal totlcstmtcal
               totlcsttolcal mtlcstprpccal labmldprbxcal mntprpccal fetcstprpccal
               cstmldprmtcal pntprmrcstcal  )
      WITH VALUE #( FOR key IN keys
                  ( %tky = gfs_header-%tky
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
                    tonnagecal = gfs_header-tonnagecal
                    wgtprbxcal = gfs_header-wgtprbxcal
                    mltngcstmtcal = gfs_header-mltngcstmtcal
                    totlcstmtcal = gfs_header-totlcstmtcal
                    totlcsttolcal = gfs_header-totlcsttolcal
                    mtlcstprpccal = gfs_header-mtlcstprpccal
                    labmldprbxcal = gfs_header-labmldprbxcal
                    mntprpccal = gfs_header-mntprpccal
                    fetcstprpccal = gfs_header-fetcstprpccal
                    cstmldprmtcal = gfs_header-cstmldprmtcal
                    pntprmrcstcal = gfs_header-pntprmrcstcal

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
                    %control-tonnagecal = if_abap_behv=>mk-on
                    %control-wgtprbxcal = if_abap_behv=>mk-on
                    %control-mltngcstmtcal = if_abap_behv=>mk-on
                    %control-totlcstmtcal = if_abap_behv=>mk-on
                    %control-totlcsttolcal = if_abap_behv=>mk-on
                    %control-mtlcstprpccal = if_abap_behv=>mk-on
                    %control-labmldprbxcal = if_abap_behv=>mk-on
                    %control-mntprpccal = if_abap_behv=>mk-on
                    %control-fetcstprpccal = if_abap_behv=>mk-on
                    %control-cstmldprmtcal = if_abap_behv=>mk-on
                    %control-pntprmrcstcal = if_abap_behv=>mk-on
                    ) ).

  ENDMETHOD.


  METHOD upd.



  ENDMETHOD.

ENDCLASS.
