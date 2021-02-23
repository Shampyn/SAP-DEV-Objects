CLASS zyb_cl_domain_cust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZYB_CL_DOMAIN_CUST IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA: ls_doma TYPE ZYB_DOMAIN_CUST,
          lt_doma TYPE TABLE OF ZYB_DOMAIN_CUST.

    IF io_request->is_data_requested( ).


   DATA(lt_range_table) = io_request->get_filter( )->get_as_ranges(  ).

   DATA(range) = lt_range_table[ name = 'DOMAINOBJ' ]-range.

    SELECT abapobject
    FROM i_custabapobjdirectoryentry
    WHERE abapobjecttype = 'DOMA'
    AND abapobjectisdeleted <>'X'
    AND ABAPObject in @range
    INTO TABLE @DATA(lt_doma_object).

      LOOP AT lt_doma_object ASSIGNING FIELD-SYMBOL(<lfs_doma_object>).

       ls_doma-DomainObj = <lfs_doma_object>-ABAPObject.
       DATA(lo_domain) = xco_cp_abap_repository=>object->doma->for( CONV #( <lfs_doma_object>-ABAPObject ) ).
       DATA(lt_fixed_value) =  lo_domain->fixed_values->all->get(  ).

       LOOP AT lt_fixed_value ASSIGNING FIELD-SYMBOL(<lfs_fixed_value>).

         ls_doma-fixedValue = <lfs_fixed_value>->content( xco_cp_abap_dictionary=>object_read_state->active_version )->lower_limit.
         ls_doma-description = <lfs_fixed_value>->content( xco_cp_abap_dictionary=>object_read_state->active_version )->get_description(  ).

         APPEND ls_doma TO lt_doma.
       ENDLOOP.

      ENDLOOP.


      DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
      DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
      DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_page_size ).

      DATA(sort_elements) = io_request->get_sort_elements( ).
      DATA(lt_sort_criteria) = VALUE string_table( FOR sort_element IN sort_elements
                                                 ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                                        THEN ` descending`
                                                                                        ELSE ` ascending` ) ) ).
      DATA(lv_sort_string)  = COND #( WHEN lt_sort_criteria IS INITIAL
                                      THEN 'fixedValue'
                                      ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).

      DATA(lt_req_elements) = io_request->get_requested_elements( ).
      DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = `, ` ).


      DATA lt_doma_response TYPE STANDARD TABLE OF ZYB_DOMAIN_CUST.

      SELECT (lv_req_elements) FROM @lt_doma AS object
"               WHERE (lv_sql_filter)
               ORDER BY (lv_sort_string)
               INTO CORRESPONDING FIELDS OF TABLE @lt_doma_response
               OFFSET @lv_offset UP TO @lv_max_rows ROWS.

      io_response->set_data( lt_doma_response ).


    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).

      SELECT COUNT( * ) FROM @lt_doma AS response
                        INTO @DATA(lv_doma_count).

      io_response->set_total_number_of_records( lv_doma_count ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
