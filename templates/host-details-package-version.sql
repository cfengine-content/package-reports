-- Return the Hostname, IP, Detailed Package Version, and Host Architecutre for
-- hosts having <PACKAGE> installed.

WITH
  s AS (
    SELECT DISTINCT ON (hostkey)
      hostkey,
      softwareversion AS version,
      substring(softwareversion from '^[0-9.]+') AS shortversion,
      softwarearchitecture AS arch
    FROM
      software
    WHERE
      softwarename = '<PACKAGE>'
    ORDER BY
      hostkey ASC,
      arch DESC,
      version DESC
  )
SELECT
  h.hostname AS "Host Name",
  h.ipaddress AS "IP Address",
  (CASE WHEN s.version IS NULL THEN 'Not installed' ELSE s.version END) AS "Package Version",
  s.arch AS "Architecture"
FROM
  hosts AS h
  NATURAL LEFT JOIN s
ORDER BY
  h.ipaddress::inet
