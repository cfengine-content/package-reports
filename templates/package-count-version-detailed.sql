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
  count(hostkey) AS "Hosts running this version",
  (CASE WHEN version IS NULL THEN 'Not installed' ELSE version END) AS "Package Version"
FROM
  hosts
  NATURAL LEFT JOIN s
GROUP BY
  version
ORDER BY
  version ASC
