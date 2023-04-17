SELECT AB.HISTORY_ID, ROUND(AB.DAILY_FEE * AB.days * ((100 - COALESCE(C.DISCOUNT_RATE, 0)) / 100) ,0) AS FEE
FROM (
    SELECT B.HISTORY_ID,A.CAR_TYPE, DATEDIFF(END_DATE, START_DATE) + 1 AS days, A.DAILY_FEE,
    CASE
        WHEN(DATEDIFF(END_DATE, START_DATE) + 1 >= 90) THEN '90일 이상'
        WHEN(DATEDIFF(END_DATE, START_DATE) + 1 >= 30) THEN '30일 이상'
        WHEN(DATEDIFF(END_DATE, START_DATE) + 1 >= 7) THEN '7일 이상'
    END AS diff
    FROM CAR_RENTAL_COMPANY_CAR A
    INNER JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY B
    ON A.CAR_ID = B.CAR_ID
    WHERE A.CAR_TYPE = '트럭'
) AB
LEFT JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN C
ON C.DURATION_TYPE = AB.diff AND AB.CAR_TYPE = C.CAR_TYPE
ORDER BY FEE DESC, AB.HISTORY_ID DESC
;

# <풀이>
# CAR_RENTAL_COMPANY_CAR, CAR_RENTAL_COMPANY_RENTAL_HISTORY table을 car_id로 join 시킨 뒤 type이 트럭인 것들만 뽑아준다.
# CAR_RENTAL_COMPANY_DISCOUNT_PLAN의 DURATION_TYPE 비교해주기 위해 case end 통해 조건별로 diff 컬럼 생성
# 대여기간과 type 조건으로 left join 후 fee 구해줌. (7일 미만은 null 값이기에 COALESCE으로 0으로 초기화)
# 15번 쥴에 type을 and으로 묶어준 이유 : 7일 미만 얘들이 빠지게 된다.
