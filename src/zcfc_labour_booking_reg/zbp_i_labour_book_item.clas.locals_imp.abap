CLASS lhc_zi_labour_book_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateamount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_labour_book_item~calculateamount.

ENDCLASS.

CLASS lhc_zi_labour_book_item IMPLEMENTATION.

  METHOD calculateamount.

  DATA lt_update TYPE TABLE FOR UPDATE zi_labour_book_item.
DATA failed TYPE TABLE FOR FAILED zi_labour_book_item.

READ ENTITIES OF zi_labour_book IN LOCAL MODE
  ENTITY zi_labour_book_item
  FIELDS ( rate quantity )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_items).

LOOP AT lt_items INTO DATA(ls_item).
  IF ls_item-rate IS NOT INITIAL AND ls_item-quantity IS NOT INITIAL.
    APPEND VALUE #(
      %tky   = ls_item-%tky " Ensure you include the technical key
      Amount = ls_item-rate * ls_item-quantity
    ) TO lt_update.
  ENDIF.
ENDLOOP.

MODIFY ENTITIES OF zi_labour_book IN LOCAL MODE
  ENTITY zi_labour_book_item
  UPDATE FIELDS ( Amount )
  WITH lt_update.

  ENDMETHOD.

ENDCLASS.
