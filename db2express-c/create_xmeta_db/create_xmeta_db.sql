--------------------------------------------------------------------------------
-- IBM Information Server metadata repository database creation for DB2
-- Version 11.1
--------------------------------------------------------------------------------
-- Copyright (c) 2007-2017 IBM Corporation. All rights reserved.
--------------------------------------------------------------------------------
--
-- See the accompanying readme for instructions on using this script.
-- 
-- The settings in this file are the one that are recommended for creating and 
-- configuring a DB2 11.1 database to be used as the IBM Information Server
-- metadata repository database.
--
--------------------------------------------------------------------------------

-- CODESET:
-- ========
--   This creates a database with the recommended codeset of UTF-8. If the 
--   database is configured to use another codeset, data entered or transferred
--   that contains characters not supported by the configured codeset will not
--   be stored, processed or displayed correctly by IBM Information Server. To 
--   avoid issues with unsupported characters use the UTF-8 codeset.
--
-- COLLATE:
-- ========
--   With the Identity collating sequence, strings are compared byte for byte.
--   Identity is the default for Unicode databases. The value of this property 
--   impacts the way strings are compared and sorted in a query. To ensure case 
--   sensitive query behavior, the Identity collation must be used. If a 
--   different collation is required for some reason, properties 
--   Query.Collator.Locale and Query.Collator.Strength must be set accordingly 
--   in the xmeta.bootstrap.properties file used to configure the matching 
--   behavior on the server side, so that any String sorting performed in memory
--   produce results compatible with String sorting performed by the SQL engine.
--
--   Recommendation: Use IDENTITY collation regardless of the CODESET to ensure 
--   consistent query behavior. 
--
-- AUTOCONFIGURE:
-- ==============
--   DB2 will automatically configure 25% of physical memory for the database
--   and the USERSPACE1 tablespace will automatically be configured to use 
--   automatic storage, with an initial size of 1GB

--#SET TERMINATOR %

CREATE DATABASE XMETA
       ALIAS XMETA
       USING CODESET UTF-8 TERRITORY US 
       COLLATE USING IDENTITY
       DFT_EXTENT_SZ 2
       USER TABLESPACE
         MANAGED BY AUTOMATIC STORAGE
         AUTORESIZE YES
         INITIALSIZE 500 M
         INCREASESIZE 10 PERCENT
       MAXSIZE NONE%

connect to XMETA%

-- ASLHEAPSZ
-- =========
--   Application support layer heap size. The default is 15.
-- 
--   Recommendation: Set the value of ASLHEAPSZ to 256.

-- QUERY_HEAP_SZ must be set before ASLHEAPSZ to ensure that QUERY_HEAP_SZ >= ASLHEAPSZ at all times
UPDATE DBM CFG USING QUERY_HEAP_SZ 4096 IMMEDIATE%
UPDATE DBM CFG USING ASLHEAPSZ 1024 IMMEDIATE%



--   Explicitly set initial values for LOCKLIST and
--   MAXLOCKS to avoid lock escalation before DB2 can tune itself.

--   Note: when LOCKLIST is set to AUTOMATIC,  MAXLOCKS must also be set to AUTOMATIC.
--   Since we're using the IMMEDIATE keyword, they need to be set together.  Otherwise
--   DB2 issues a warning.

UPDATE DATABASE CONFIGURATION FOR XMETA USING LOCKLIST 20000 AUTOMATIC MAXLOCKS 90 AUTOMATIC IMMEDIATE%


-- AGENT_STACK_SZ  
-- ==============
--   Agent stack size. The virtual memory that is allocated to each agent by 
--   DB2. The stack increases when the complexity of the query increases. The 
--   memory is committed when each SQL statement is processed. When preparing a 
--   large SQL statement, the agent can run out of stack space and the system 
--   will generate a stack overflow exception. When this happens, the server 
--   will shut down because the error is non-recoverable. The agent stack size
--   and the number of concurrent clients are inversely related: a larger stack
--   size reduces the potential number of concurrent clients that can be 
--   running. The default value is 64. 
--
--   Recommendation: Set the value of agent_stack_sz to 768.

UPDATE DBM CFG USING agent_stack_sz 768 IMMEDIATE%

-- DFT_MON monitor switches:
-- =========================
--   By default, all the DFT_MON switches are disabled except DFT_MON_TIMESTAMP.
--   All the switches will incur some sort of overhead - in particular, as CPU 
--   approaches 100%, DFT_MON_TIMESTAMP will have an increasing effect on 
--   performance.
--
--   Recommendation: Leave default for all DFT_MON switches (off), except 
--   DFT_MON_TIMESTAMP which should explicitly be disabled.

UPDATE DBM CFG USING DFT_MON_TIMESTAMP OFF IMMEDIATE%

-- AVG_APPLS
-- =========
--   Average number of active applications. Used by the query optimizer to help
--   estimate how much buffer pool will be available at run-time for the access
--   plan chosen.

UPDATE DATABASE CONFIGURATION FOR XMETA USING AVG_APPLS 5 IMMEDIATE%

-- SELF_TUNING_MEM:
-- ================
--   New to v9, DB2 has the ability to self-tune a number of memory related 
--   parameters. These parameters are:
--
--    DATABASE_MEMORY
--    LOCKLIST 
--    MAXLOCKS 
--    PCKCACHESZ 
--    SHEAPTHRES_SHR 
--    SORTHEAP 
--    STMTHEAP (9.5)
--    DBHEAP (9.5)
--    APPLHEAPSZ (9.5)
--
--   By default, all these parameters are enabled for self tuning memory apart
--   from SHEAPTHRES_SHR.
--
--   Recommendation: Enable all parameters for self-tuning memory since this is 
--   an autonomic feature which should mean less intervention and administration
--   of the database is required.

--   Note: when SHEAPTHRES_SHR is set to AUTOMATIC,  SORTHEAP must also be set to AUTOMATIC.
--   Since we're using the IMMEDIATE keyword, they need to be set together.  Otherwise
--   DB2 issues a warning and sets SORTHEAP to AUTOMATIC anyways.

UPDATE DATABASE CONFIGURATION FOR XMETA USING SHEAPTHRES_SHR AUTOMATIC SORTHEAP AUTOMATIC IMMEDIATE%
UPDATE DATABASE CONFIGURATION FOR XMETA USING APPLHEAPSZ AUTOMATIC IMMEDIATE%
UPDATE DATABASE CONFIGURATION FOR XMETA USING PCKCACHESZ AUTOMATIC IMMEDIATE%
UPDATE DATABASE CONFIGURATION FOR XMETA USING STMTHEAP AUTOMATIC IMMEDIATE%



-- Logging configuration
-- =====================

UPDATE DATABASE CONFIGURATION FOR XMETA USING LOGBUFSZ 2048 IMMEDIATE%
UPDATE DATABASE CONFIGURATION FOR XMETA USING LOGFILSIZ 5000%
UPDATE DATABASE CONFIGURATION FOR XMETA USING LOGPRIMARY 50%
UPDATE DATABASE CONFIGURATION FOR XMETA USING LOGSECOND 200%

-- Enabling Automatic Statistics Collection
-- ========================================

UPDATE DATABASE CONFIGURATION FOR XMETA USING AUTO_MAINT ON AUTO_TBL_MAINT ON AUTO_RUNSTATS ON%

-- APP_CTL_HEAP_SZ (64 bit)
-- ===============
-- Application control heap size.
-- The value of this parameter must be increased if your applications 
-- receive an error indicating that there is not enough storage in 
-- the application control heap. The default value varies from 64 to 512
-- depending on database plaform and other database configuration settings.
-- Recommendation:
--  Set the value of APP_CTL_HEAP_SZ to 512.
UPDATE DATABASE CONFIGURATION FOR XMETA USING APP_CTL_HEAP_SZ      512%


CONNECT TO XMETA%

-- Bufferpools
-- ============
--   In DB2 9 bufferpools have the ability to be managed by the self-tuning 
--   memory feature. To be able to support installation in a variety of
--   environments this setting is used.

CREATE BUFFERPOOL XMETA IMMEDIATE 
       SIZE 8000 AUTOMATIC 
       PAGESIZE 32 K %

-- DMS Tablespace
-- ==============
--   Create a DMS tablespace with 32k pagesize to hold wide tables whose storage
--   is automatically managed by DB2

CREATE REGULAR TABLESPACE XMETA 
       IN DATABASE PARTITION GROUP IBMDEFAULTGROUP 
       PAGESIZE 32768 
       MANAGED BY AUTOMATIC STORAGE
       AUTORESIZE YES
       INITIALSIZE 500 M
       INCREASESIZE 10 PERCENT
       MAXSIZE NONE
       EXTENTSIZE 2
       BUFFERPOOL XMETA
       FILE SYSTEM CACHING  
       DROPPED TABLE RECOVERY ON%

COMMIT WORK%

-- SMS Tablespace
-- ==============
--   Create a temporary SMS tablespace for the XMETA regular tablespace whose 
--   storage is automatically managed by DB2

CREATE TEMPORARY TABLESPACE XMETATEMP  
       IN DATABASE PARTITION GROUP IBMTEMPGROUP 
       PAGESIZE 32768 
       MANAGED BY AUTOMATIC STORAGE
       EXTENTSIZE 2
       BUFFERPOOL XMETA
       FILE SYSTEM CACHING%

COMMENT ON TABLESPACE XMETATEMP IS '32 page swap'%

COMMIT WORK%

-- This is for BG

CREATE USER TEMPORARY TABLESPACE BGSESSIONTEMP
PAGESIZE 4 K
MANAGED BY AUTOMATIC STORAGE
EXTENTSIZE 16
OVERHEAD 10.5
PREFETCHSIZE 16
TRANSFERRATE 0.14
BUFFERPOOL IBMDEFAULTBP%

COMMIT WORK%

-- Granting all the required access rights to the XMETADB user
-- ===========================================================

GRANT CREATETAB,IMPLICIT_SCHEMA,CONNECT,LOAD,BINDADD ON DATABASE TO USER xmeta%
GRANT USE OF TABLESPACE XMETA TO USER xmeta%
GRANT USE OF TABLESPACE BGSESSIONTEMP TO USER xmeta%
CREATE SCHEMA xmeta%
GRANT ALTERIN, CREATEIN, DROPIN ON SCHEMA xmeta TO USER xmeta%

COMMIT WORK%


CONNECT RESET%
TERMINATE%

