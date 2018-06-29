-- See the Information Server installation documentation for instructions
-- for running this script
--
-- Grant all the required access rights to the Staging DB user
-- ===========================================================

CONNECT TO XMETA;

GRANT CREATETAB,IMPLICIT_SCHEMA,CONNECT,LOAD,BINDADD ON DATABASE TO USER xmetasr;

GRANT USE OF TABLESPACE XMETA TO USER xmetasr;

-- this is required so we can run the xmeta diagnostics against the staging repository.
-- It is the only USER TEMPORARY TABLESPACE that is available.
GRANT USE OF TABLESPACE BGSESSIONTEMP TO USER xmetasr;

COMMIT WORK;

CONNECT RESET;
TERMINATE;
