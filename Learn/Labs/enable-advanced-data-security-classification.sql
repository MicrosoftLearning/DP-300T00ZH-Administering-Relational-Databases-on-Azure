SELECT o.name AS [Table Name]
    ,ac.name AS [Column Name]
    ,sc.label
    ,sc.information_type
FROM sys.sensitivity_classifications sc
INNER JOIN sys.objects o ON o.object_id = sc.major_id
INNER JOIN sys.all_columns ac ON ac.column_id = sc.minor_id
WHERE ac.object_id = o.object_id;