-- INDENTING (emacs/vi): -*- mode:sql; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

/*
 * Dovecot Load-Balancer
 * Copyright (C) 2012-2018 Cedric Dufour <http://cedric.dufour.name>
 * Author: Cedric Dufour <http://cedric.dufour.name>
 *
 * The Dovecot Load-Balancer is free software:
 * you can redistribute it and/or modify it under the terms of the GNU General
 * Public License as published by the Free Software Foundation, Version 3.
 *
 * The Dovecot Load-Balancer is distributed in the hope
 * that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * See the GNU General Public License for more details.
 */


/*
 * FUNCTIONS: Global
 ********************************************************************************/

CREATE OR REPLACE FUNCTION hex2dec(
 text
) RETURNS bigint AS $$
  SELECT CAST( CAST( ( 'x' || LPAD( $1, 16, '0' ) ) AS bit(64) ) AS bigint );
$$ LANGUAGE SQL STRICT IMMUTABLE;


/*
 * FUNCTIONS: Host
 ********************************************************************************/

CREATE OR REPLACE FUNCTION fn_DLB_Host_add(
  text,text
) RETURNS bigint AS $$
DECLARE
-- ARGUMENTS
  A_vc_IP ALIAS FOR $1;
  A_vc_Port ALIAS FOR $2;
BEGIN
  -- INSERT
  INSERT INTO tb_DLB_Host (
    vc_IP, vc_Port
  ) VALUES (
    A_vc_IP, A_vc_Port
  );

  IF NOT FOUND THEN
    RETURN null;
  END IF;

  -- END
  RETURN currval( 'sq_DLB_Host' );
END
$$ LANGUAGE 'plpgsql' STRICT VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION fn_DLB_Host_status(
  text,text,boolean
) RETURNS boolean AS $$
DECLARE
-- ARGUMENTS
  A_vc_IP ALIAS FOR $1;
  A_vc_Port ALIAS FOR $2;
  A_b_Active ALIAS FOR $3;
BEGIN
  -- UPDATE:
  UPDATE tb_DLB_Host SET
    b_Active = A_b_Active
  WHERE
    vc_IP = A_vc_IP AND vc_Port = A_vc_Port
  ;

  -- END
  RETURN FOUND;
END
$$ LANGUAGE 'plpgsql' STRICT VOLATILE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION fn_DLB_Host_remove(
  text,text
) RETURNS boolean AS $$
DECLARE
-- ARGUMENTS
  A_vc_IP ALIAS FOR $1;
  A_vc_Port ALIAS FOR $2;
BEGIN
  -- DELETE
  DELETE FROM tb_DLB_Host WHERE vc_IP = A_vc_IP AND vc_Port = A_vc_Port;

  -- END
  RETURN FOUND;
END
$$ LANGUAGE 'plpgsql' STRICT VOLATILE SECURITY DEFINER;

CREATE OR REPLACE VIEW vw_DLB_Host_forUser AS
SELECT
  NULL::varchar AS password,
  NULL::varchar AS nopassword,
  vc_IP  AS host,
  vc_Port AS port,
  NULL::varchar AS destuser,
  NULL::varchar AS nologin,
  NULL::varchar AS nodelay,
  NULL::varchar AS proxy,
  NULL::varchar AS ssl
FROM
  tb_DLB_Host
;
 
CREATE OR REPLACE FUNCTION fn_DLB_Host_forUser(
  text
) RETURNS setof vw_DLB_Host_forUser AS $$
DECLARE
-- ARGUMENTS
  A_vc_user ALIAS FOR $1;
-- VARIABLES
  V_i_Host_count bigint;
  V_i_Host_limit bigint;
BEGIN
  -- Retrieve active hosts count and corresponding query limit
  SELECT COUNT( pk ) FROM tb_DLB_Host WHERE b_Active INTO V_i_Host_count;
  SELECT CASE WHEN V_i_Host_count > 0 THEN MOD( hex2dec( SUBSTR( MD5( A_vc_User ), 1, 8 ) ), V_i_Host_count )+1 ELSE 0 END INTO V_i_Host_limit;

  -- Retrieve host
  RETURN QUERY SELECT
    NULL::varchar,
    'Y'::varchar,
    vc_IP,
    vc_Port,
    NULL::varchar,
    'Y'::varchar,
    'Y'::varchar,
    'Y'::varchar,
    'any-cert'::varchar
  FROM
  (
    SELECT
      pk, vc_IP, vc_Port
    FROM
      tb_DLB_Host
    WHERE
      b_Active
    ORDER BY
      pk ASC
    LIMIT
      V_i_Host_limit
  ) AS vw
  ORDER BY
    pk DESC
  LIMIT
    1
  ;
END
$$ LANGUAGE 'plpgsql' STRICT STABLE SECURITY DEFINER;


/*
 * END
 ********************************************************************************/
