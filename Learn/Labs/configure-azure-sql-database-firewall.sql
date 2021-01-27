-- Step 3
---------

EXECUTE sp_set_database_firewall_rule @name = N'ContosoFirewallRule',
 @start_ip_address = 'n.n.n.n', @end_ip_address = 'n.n.n.n'


-- Step 4
---------

CREATE USER containeddemo WITH PASSWORD = 'P@ssw0rd!'


-- Step 11
----------

SELECT SUERS_NAME();