SELECT LEFT(PRODUCT_CODE, 2) AS CATEGORY, COUNT(*) AS PRODUCTS
FROM PRODUCT
GROUP BY CATEGORY
ORDER BY CATEGORY
;

# <풀이>
# 새로운 컬럼 그룹핑 카운트
