

This project implements a multi-tiered security framework designed for financial data protection:

Role-Based Access Control (RBAC) & Profiles:Enforces principle of least privilege using granular database profiles and custom access roles
Data Masking & Secure Views: Restricts access to full Personally Identifiable Information (PII) by exposing masked views (VW_CUSTOMER_MASKED) to non-admin roles.
Storage Encryption (AES-256):Encrypts sensitive financial metrics (balance, credit_score) using DBMS_CRYPTO with AES-256 CBC cipher and PKCS5 padding before removing plaintext columns.
Autonomous Audit Logging:Captures critical security events and updates independently via PRAGMA AUTONOMOUS_TRANSACTION.
Immutable Audit Protection: Enforces non-repudiation using PL/SQL triggers (`TRG_AUDIT_FINAL_IMMUTABLE`) that block modifications or deletions on AUDIT_LOGS.







