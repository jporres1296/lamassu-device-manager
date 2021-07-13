CREATE TABLE device_information (
    id TEXT PRIMARY KEY,
    alias TEXT,
    status TEXT,
    dms_id int,
    country TEXT,
    state TEXT,
    locality TEXT,
    organization TEXT,
    organization_unit TEXT,
    common_name TEXT,
    key_stregnth TEXT,
    key_type TEXT,
    key_bits int,
    creation_ts timestamp,
    current_cert_serial_number TEXT
);

CREATE TABLE device_logs (
    id TEXT PRIMARY KEY,
    creation_ts timestamp,
    device_uuid TEXT,
    log_type TEXT,
    log_message TEXT
);

CREATE TABLE device_certificates_history (
    serial_number TEXT PRIMARY KEY,
    device_uuid TEXT,
    issuer_serial_number TEXT,
    issuer_name TEXT,
    status TEXT,
    creation_ts timestamp
);

CREATE VIEW devices_certs AS (
	select serial_number, device_uuid, dch.creation_ts, di.dms_id from device_information di inner join device_certificates_history dch on dch.serial_number=di.current_cert_serial_number order by di.dms_id, creation_ts 
);

CREATE VIEW last_issued_cert_by_dms AS (
	select dms_id, creation_ts, c.serial_number from devices_certs c where c.serial_number in (select c2.serial_number from devices_certs c2 where dms_id=c.dms_id order by c2.creation_ts desc limit 1)
);