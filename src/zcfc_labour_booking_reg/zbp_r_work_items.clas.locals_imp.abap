CLASS lhc_zr_work_items DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validatedaterange FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_work_items~validatedaterange.

ENDCLASS.

CLASS lhc_zr_work_items IMPLEMENTATION.

  METHOD validatedaterange.

  " 1. Read new line items from local memory
  READ ENTITIES OF zr_work_header IN LOCAL MODE
    ENTITY zr_work_items FIELDS ( plantcode workcode datefrom dateto )
    WITH CORRESPONDING #( keys )
    RESULT DATA(it_result).

  " 2. Check against DB
  LOOP AT it_result INTO DATA(wa_result).

    SELECT * FROM zwork_items
      WHERE plant_code = @wa_result-plantcode
        AND work_code  = @wa_result-workcode
      INTO TABLE @DATA(lt_existing).

    LOOP AT lt_existing INTO DATA(wa_db).

      IF wa_result-datefrom BETWEEN wa_db-date_from AND wa_db-date_to OR
         wa_result-dateto   BETWEEN wa_db-date_from AND wa_db-date_to OR
         wa_db-date_from BETWEEN wa_result-datefrom AND wa_result-dateto OR
         wa_db-date_to   BETWEEN wa_result-datefrom AND wa_result-dateto.

        " DB Overlap
        APPEND VALUE #( %key = wa_result-%key ) TO failed-zr_work_items.

        APPEND VALUE #(
          %key = wa_result-%key
          %msg = new_message(
            id       = 'ZWORK'
            number   = '001'
            severity = if_abap_behv_message=>severity-error
            v1       = |Date range overlaps with Table for Plant { wa_result-plantcode } and Work { wa_result-workcode }|
          )
        ) TO reported-zr_work_items.

        CONTINUE.
      ENDIF.

    ENDLOOP.

  ENDLOOP.

  " 3. In-memory overlap check among new line items
  DATA(lv_idx_outer) = 0.

  LOOP AT it_result INTO DATA(wa_outer).
    lv_idx_outer += 1.

    DATA(lv_idx_inner) = 0.

    LOOP AT it_result INTO DATA(wa_inner).
      lv_idx_inner += 1.

      IF lv_idx_inner <= lv_idx_outer.
        CONTINUE. " avoid duplicate/self check
      ENDIF.

      IF wa_outer-plantcode = wa_inner-plantcode AND
         wa_outer-workcode  = wa_inner-workcode.

        IF wa_outer-datefrom BETWEEN wa_inner-datefrom AND wa_inner-dateto OR
           wa_outer-dateto   BETWEEN wa_inner-datefrom AND wa_inner-dateto OR
           wa_inner-datefrom BETWEEN wa_outer-datefrom AND wa_outer-dateto OR
           wa_inner-dateto   BETWEEN wa_outer-datefrom AND wa_outer-dateto.

          " Overlap found between new items
          APPEND VALUE #( %key = wa_outer-%key ) TO failed-zr_work_items.
          APPEND VALUE #( %key = wa_inner-%key ) TO failed-zr_work_items.

          " Messages
          APPEND VALUE #(
            %key = wa_outer-%key
            %msg = new_message(
              id       = 'ZWORK'
              number   = '001'
              severity = if_abap_behv_message=>severity-error
              v1       = |Date range overlaps with another new line item(Plant { wa_outer-plantcode }, Work { wa_outer-workcode })|
            )
          ) TO reported-zr_work_items.

          APPEND VALUE #(
            %key = wa_inner-%key
            %msg = new_message(
              id       = 'ZWORK'
              number   = '001'
              severity = if_abap_behv_message=>severity-error
              v1       = |Date range overlaps with another new line item(Plant { wa_outer-plantcode }, Work { wa_outer-workcode })|
            )
          ) TO reported-zr_work_items.

        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDLOOP.

ENDMETHOD.



ENDCLASS.
