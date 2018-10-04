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
 * TABLE: Hosts
 ********************************************************************************/

-- Table (and Primary Key)
CREATE SEQUENCE sq_DLB_Host MINVALUE 10000 MAXVALUE 2147483647 INCREMENT 1 CACHE 1;
CREATE TABLE tb_DLB_Host ( pk bigint NOT NULL PRIMARY KEY DEFAULT( nextval( 'sq_DLB_Host' ) ) ) WITHOUT OIDS;

-- Host
ALTER TABLE tb_DLB_Host ADD COLUMN vc_IP varchar( 40 ) NOT NULL;
ALTER TABLE tb_DLB_Host ADD COLUMN vc_Port varchar( 5 ) NOT NULL;
-- ... indexes
CREATE UNIQUE INDEX uq_DLB_Host ON tb_DLB_Host ( vc_IP, vc_Port );

-- Status
ALTER TABLE tb_DLB_Host ADD COLUMN b_Active boolean NOT NULL DEFAULT( false );
-- ... indexes
CREATE INDEX ix_DLB_Host_Active ON tb_DLB_Host ( b_Active );


/*
 * END
 ********************************************************************************/
