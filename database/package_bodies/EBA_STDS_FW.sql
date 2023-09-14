--liquibase formatted sql
--changeset package_body_script:EBA_STDS_FW stripComments:false endDelimiter:/ runOnChange:true
create or replace PACKAGE BODY "EBA_STDS_FW" as
    function conv_txt_html (
        p_txt_message in varchar2 )
        return varchar2
    is
        l_html_message   varchar2(32767) default p_txt_message;
        l_length number;
    begin
        l_html_message := replace(l_html_message, chr(10), '<br />');
        l_html_message := replace(l_html_message, chr(13), null);
        return l_html_message;
    end conv_txt_html;
    function format_status_update ( p_string in clob, p_shorten_url in varchar2 default 'N' ) return varchar2 is
        l_string      varchar2(32767);
        c_endofUrl    constant varchar2(4000) := chr(10) || chr(13) || chr(9) || ' )<>';
        l_url         varchar2(4000);
        l_current_pos number := 1;
        n             number := 1;
        m             number := 1;
        p             number := 1;
    begin
        l_string := apex_escape.html(dbms_lob.substr(p_string,2500,1)) || ' ';
        for i in 1 .. 1000 loop
            n := instr( lower(l_string), 'http:&#x2f;&#x2f;', l_current_pos );
            m := instr( lower(l_string), 'https:&#x2f;&#x2f;', l_current_pos );
            p := instr( lower(l_string), 'ftp:&#x2f;&#x2f;', l_current_pos   );
            -- set n to position of first link
            if m > 0 and (n = 0 or m < n) and (p = 0 or m < p) then
               n := m;
            elsif p > 0 and (n = 0 or p < n) then
               n := p;
            end if;
            exit when n = 0 or length(l_string) > 32000;
            for j in 0 .. length( l_string ) - n loop
                if ( instr( c_endofUrl, substr( l_string, n+j, 1 ) ) > 0 ) then
                   l_url := rtrim( substr( l_string, n, j ), '.'||chr(32)||chr(10) );
                   if p_shorten_url = 'Y' and length(l_url) > 100 then
                       l_url := '<a href="' || l_url || '" target="_blank">'
                           || substr(l_url,0,60)||'...'||substr(l_url,-30,30) || '</a>';
                   else
                       l_url := '<a href="' || l_url || '" target="_blank">' || l_url || '</a>';
                   end if;
                   l_string := substr( l_string, 1, n-1 ) || l_url || substr( l_string, n+j );
                   l_current_pos := n + length(l_url);
                   exit;
                end if;
            end loop;
        end loop;
        return replace(l_string,chr(10),'<br>');
    end format_status_update;
    function conv_urls_links (
        p_string in varchar2 )
        return varchar2
    is
        l_string   varchar2(32767) default p_string;
        c_endofUrl constant varchar2(4000) := chr(10) || chr(13) || chr(9) || ' )<>';
        l_url         varchar2(4000);
        l_current_pos number := 1;
        n             number := 1;
        m             number := 1;
        p             number := 1;
    begin
        l_string := p_string || ' ';
        for i in 1 .. 1000 loop
            n := instr( lower(l_string), 'http://', l_current_pos );
            m := instr( lower(l_string), 'https://', l_current_pos );
            p := instr( lower(l_string), 'ftp://', l_current_pos   );
            -- set n to position of first link
            if m > 0 and (n = 0 or m < n) and (p = 0 or m < p) then
               n := m;
            elsif p > 0 and (n = 0 or p < n) then
               n := p;
            end if;
            exit when n = 0 or length(l_string) > 32000;
            for j in 0 .. length( l_string ) - n loop
                if ( instr( c_endofUrl, substr( l_string, n+j, 1 ) ) > 0 ) then
                   l_url := rtrim( substr( l_string, n, j ), '.'||chr(32)||chr(10) );
                   l_url := '<a href="' || l_url || '">' || l_url || '</a>';
                   l_string := substr( l_string, 1, n-1 ) || l_url || substr( l_string, n+j );
                   l_current_pos := n + length(l_url);
                   exit;
                end if;
            end loop;
        end loop;
        return l_string;
    end conv_urls_links;
    function tags_cleaner (
        p_tags  in varchar2,
        p_case  in varchar2 default 'U' )
        return varchar2
    is
        type tags is table of varchar2(255) index by varchar2(255);
        l_tags_a        tags;
        l_tag           varchar2(255);
        l_tags          apex_application_global.vc_arr2;
        l_tags_string   varchar2(32767);
    begin
        l_tags := apex_util.string_to_table(p_tags,',');
        for i in 1..l_tags.count loop
            --remove all whitespace, including tabs, spaces, line feeds and carraige returns with a single space
            l_tag := substr(trim(regexp_replace(l_tags(i),'[[:space:]]{1,}',' ')),1,255);
            if l_tag is not null and l_tag != ' ' then
                if p_case = 'U' then
                    l_tag := upper(l_tag);
                elsif p_case = 'L' then
                    l_tag := lower(l_tag);
                end if;
                --add it to the associative array, if it is a duplicate, it will just be replaced
                l_tags_a(l_tag) := l_tag;
            end if;
        end loop;
        l_tag := null;
        l_tag := l_tags_a.first;
        while l_tag is not null loop
            l_tags_string := l_tags_string||l_tag;
            if l_tag != l_tags_a.LAST then
                l_tags_string := l_tags_string || ', ';
            end if;
            l_tag := l_tags_a.next(l_tag);
        end loop;
        return substr(l_tags_string, 1, 4000);
    end tags_cleaner;
    function get_preference_value (
        p_preference_name varchar2 )
        return varchar2
    is
        l_preference_value varchar2(255);
    begin
        select preference_value
            into l_preference_value
        from eba_stds_preferences
        where preference_name = p_preference_name;
        return l_preference_value;
    exception
        when no_data_found then
            return 'Preference does not exist';
    end get_preference_value;
    procedure set_preference_value (
        p_preference_name  varchar2, 
        p_preference_value varchar2 )
    is
    begin
        merge into eba_stds_preferences dest
        using ( select upper(p_preference_name) preference_name,
                    p_preference_value preference_value
                from dual ) src
        on ( upper(dest.preference_name) = src.preference_name )
        when matched then
            update set dest.preference_value = src.preference_value
        when not matched then
            insert (dest.preference_name, dest.preference_value)
            values (src.preference_name, src.preference_value);
    end set_preference_value;
    function compress_int (
        n in integer )
        return varchar2
    as
        ret varchar2(30);
        quotient integer;
        l_remainder integer;
        digit char(1);
    begin
        ret := '';
        quotient := n;
        while quotient > 0
        loop
            l_remainder := mod(quotient, 10 + 26);
            quotient := floor(quotient  / (10 + 26));
            if l_remainder < 26 then
                digit := chr(ascii('A') + l_remainder);
            else
                digit := chr(ascii('0') + l_remainder - 26);
            end if;
            ret := digit || ret;
        end loop ;
        if length(ret) < 5 then
            ret := lpad(ret, 4, 'A');
        end if ;
        return upper(ret);
    end compress_int;
    function apex_error_handling (
        p_error in apex_error.t_error )
        return apex_error.t_error_result
    is
        l_result          apex_error.t_error_result;
        l_constraint_name varchar2(255);
    begin
        l_result := apex_error.init_error_result (
                        p_error => p_error );
        -- If it is an internal error raised by APEX, like an invalid statement or
        -- code which can not be executed, the error text might contain security sensitive
        -- information. To avoid this security problem we can rewrite the error to
        -- a generic error message and log the original error message for further
        -- investigation by the help desk.
        if p_error.is_internal_error then
            -- mask all errors that are not common runtime errors (Access Denied
            -- errors raised by application / page authorization and all errors
            -- regarding session and session state)
            if not p_error.is_common_runtime_error then
                -- add_error_log( p_error );
                -- Change the message to the generic error message which doesn't expose
                -- any sensitive information.
                l_result.message         := 'An unexpected internal application error has occurred.';
                l_result.additional_info := null;
            end if;
        else
            -- Always show the error as inline error
            -- Note: If you have created manual tabular forms (using the package
            --       apex_item/htmldb_item in the SQL statement) you should still
            --       use "On error page" on that pages to avoid loosing entered data
            l_result.display_location := case
                                           when l_result.display_location = apex_error.c_on_error_page then apex_error.c_inline_in_notification
                                           else l_result.display_location
                                         end;
            -- If it's a constraint violation like
            --
            --   -) ORA-00001: unique constraint violated
            --   -) ORA-02091: transaction rolled back (-> can hide a deferred constraint)
            --   -) ORA-02290: check constraint violated
            --   -) ORA-02291: integrity constraint violated - parent key not found
            --   -) ORA-02292: integrity constraint violated - child record found
            --
            -- we try to get a friendly error message from our constraint lookup configuration.
            -- If we don't find the constraint in our lookup table we fallback to
            -- the original ORA error message.
            if p_error.ora_sqlcode in (-1, -2091, -2290, -2291, -2292) then
                l_constraint_name := apex_error.extract_constraint_name (
                                         p_error => p_error );
                begin
                    select message
                      into l_result.message
                      from eba_stds_error_lookup
                     where constraint_name = l_constraint_name;
                exception when no_data_found then null; -- not every constraint has to be in our lookup table
                end;
            end if;
            -- If an ORA error has been raised, for example a raise_application_error(-20xxx, '...')
            -- in a table trigger or in a PL/SQL package called by a process and we
            -- haven't found the error in our lookup table, then we just want to see
            -- the actual error text and not the full error stack with all the ORA error numbers.
            if p_error.ora_sqlcode is not null and l_result.message = p_error.message then
                l_result.message := apex_error.get_first_ora_error_text (
                                        p_error => p_error );
            end if;
            -- If no associated page item/tabular form column has been set, we can use
            -- apex_error.auto_set_associated_item to automatically guess the affected
            -- error field by examine the ORA error for constraint names or column names.
            if l_result.page_item_name is null and l_result.column_alias is null then
                apex_error.auto_set_associated_item (
                    p_error        => p_error,
                    p_error_result => l_result );
            end if;
        end if;
        return l_result;
    end apex_error_handling;
end eba_stds_fw;
/

--rollback drop package EBA_STDS_FW;
