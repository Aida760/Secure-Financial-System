
SET SERVEROUTPUT ON SIZE UNLIMITED;


CREATE OR REPLACE VIEW VW_CUSTOMER_MASKED AS
SELECT 
    c.customer_id,
    c.full_name,
    SUBSTR(c.email, 1, 4) || '***@***' AS email_masked,
    SUBSTR(c.national_id, 1, 2) || RPAD('*', LENGTH(c.national_id)-4, '*') || SUBSTR(c.national_id, -2) AS national_id_masked,
    c.risk_level
FROM CUSTOMERS c;

CREATE OR REPLACE VIEW VW_ROLE_BASED_CUSTOMERS AS
SELECT 
    c.customer_id,
    c.full_name,
    CASE 
        WHEN SYS_CONTEXT('SYS_SESSION_ROLES', 'BANK_ADMIN_ROLE') = 'TRUE' THEN c.email
        ELSE SUBSTR(c.email, 1, 4) || '***@***'
    END AS email_display,
    CASE 
        WHEN SYS_CONTEXT('SYS_SESSION_ROLES', 'BANK_ADMIN_ROLE') = 'TRUE' THEN c.national_id
        ELSE SUBSTR(c.national_id, 1, 2) || RPAD('*', LENGTH(c.national_id)-4, '*') || SUBSTR(c.national_id, -2)
    END AS national_id_display
FROM CUSTOMERS c;

CREATE OR REPLACE VIEW VW_LOW_RISK_ACTIVE AS
SELECT c.customer_id, c.full_name, c.risk_level, a.account_id, a.account_status
FROM CUSTOMERS c
JOIN ACCOUNTS a ON c.customer_id = a.customer_id
WHERE c.risk_level = 'LOW' AND a.account_status = 'ACTIVE';

CREATE OR REPLACE VIEW VW_AUDIT_SECURITY AS
SELECT al.log_id, al.event_time, al.db_user, al.action_type, al.table_affected, al.action_details, s.full_name AS staff_name, s.job_role AS staff_role
FROM AUDIT_LOGS al
LEFT JOIN STAFF s ON UPPER(s.username) = UPPER(al.db_user);

REVOKE SELECT, INSERT, UPDATE ON CUSTOMERS FROM BANK_OFFICER_ROLE;
REVOKE SELECT, INSERT, UPDATE ON ACCOUNTS FROM BANK_OFFICER_ROLE;

GRANT SELECT ON VW_CUSTOMER_MASKED TO BANK_OFFICER_ROLE;
GRANT SELECT ON VW_LOW_RISK_ACTIVE TO BANK_OFFICER_ROLE;
