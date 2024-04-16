CLASS lhc_Student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Student RESULT result.

    METHODS statusUpdate FOR MODIFY
      IMPORTING keys FOR ACTION Student~statusUpdate.

ENDCLASS.

CLASS lhc_Student IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD statusUpdate.
    READ ENTITIES OF zrap_i_student_5001 IN LOCAL MODE
       ENTITY Student
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(students)
       FAILED failed.

    SORT students BY Status DESCENDING.
    LOOP AT students ASSIGNING FIELD-SYMBOL(<lfs_students>).

      IF <lfs_students>-Age < 25.

        APPEND VALUE #(  %tky = <lfs_students>-%tky ) TO failed-student.
        APPEND VALUE #( %tky =  <lfs_students>-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text = <lfs_students>-Firstname && ' has Age less then 25, status not updated '
                        ) ) TO reported-student.
      ELSE.

        <lfs_students>-Status = abap_true.

      ENDIF.
    ENDLOOP.

    IF failed-student IS INITIAL.

      SORT students BY Status DESCENDING.

      MODIFY ENTITIES OF zrap_i_student_5001 IN LOCAL MODE
      ENTITY Student
      UPDATE FIELDS ( Status ) WITH CORRESPONDING #( students )
      .
    ENDIF.

*    READ ENTITIES OF zrap_i_student_5001 IN LOCAL MODE
*     ENTITY Student
*     ALL FIELDS WITH CORRESPONDING #( keys )
*     RESULT DATA(students)
*     FAILED failed.
*
*    SORT students BY Status DESCENDING.
*    LOOP AT students ASSIGNING FIELD-SYMBOL(<lfs_students>).
*      <lfs_students>-Status = abap_true.
*    ENDLOOP.
*
*    MODIFY ENTITIES OF zrap_i_student_5001 IN LOCAL MODE
*    ENTITY Student
*    UPDATE FIELDS ( Status ) WITH CORRESPONDING #( students ).
  ENDMETHOD.

ENDCLASS.
