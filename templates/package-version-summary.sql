-- Count the number of hosts that have a version of the package installed
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
  (CASE WHEN shortversion IS NULL THEN 'Not installed' ELSE shortversion END) AS "Package Version"
FROM
  hosts
  NATURAL LEFT JOIN s
GROUP BY
  shortversion
ORDER BY
  shortversion ASC
