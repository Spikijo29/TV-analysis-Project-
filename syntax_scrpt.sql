SELECT 
  coalesce(A.UserID, B.UserID) AS userid,
  A.Gender,
  A.Race,
   CASE
      WHEN A.RACE IN ('Black', 'African') THEN 'Black/African'
      WHEN A.RACE IN ('White') THEN 'White'
      WHEN A.RACE IN ('Coloured') THEN 'Coloured'
      WHEN A.RACE IN ('Asian', 'Indian') THEN 'Asian/Indian'
      WHEN A.RACE IN ('None', 'Unknown') THEN 'Other'
      END AS race_bucket,
  A.Age,
  CASE 
    WHEN A.AGE = 0 THEN '01 UNDER 1'
    WHEN A.AGE BETWEEN 0 AND 12 THEN '02 1-12'
    WHEN A.AGE BETWEEN 13 AND 17 THEN '03 13-17'
    WHEN A.AGE BETWEEN 18 AND 24 THEN '04 18-24'
    WHEN A.AGE >= 25 THEN '25+'
  END AS age_group,
  A.Province,
  B.Duration2,
  B.Channel2,
  CASE 
    WHEN hour(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN hour(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN hour(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) BETWEEN 18 AND 21 THEN 'Evening'
    ELSE 'Night'
  END AS time_bucket,
  B.RecordDate2,
  to_date(
    B.RecordDate2,
    'yyyy/MM/dd HH:mm'
  ) AS watchdate,
  COUNT(*) AS interaction_count
FROM bright_tv_user_profiles AS A
FULL OUTER JOIN bright_tv_viewership AS B
  ON A.UserID = B.UserID
GROUP BY 
  coalesce(A.UserID, B.UserID),
  A.Gender,  
  A.Race,
  A.Age,
  A.Province,
  B.Duration2,
  B.Channel2,
  B.RecordDate2
