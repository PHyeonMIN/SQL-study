-- product_id 총 매출액을 구하고, 전체 매출 대비 개별 상품의 총 매출액 비율을 소수점2자리로 구한 뒤 매출액 비율 내림차순으로 정렬
with
temp_01 as 
(
	select product_id, sum(amount) as sum_by_prod
	from nw.order_items
	group by product_id
)
select product_id, sum_by_prod
	, sum(sum_by_prod) over () as total_sum
	, round(sum_by_prod/sum(sum_by_prod) over (),2) as sum_ratio
from temp_01
order by 4 desc;
;




-- 직원별 개별 상품 매출액, 직원별 가장 높은 상품 매출액을 구하고, 직원별로 가장 높은 매출을 올리는 상품의 매출 금액 대비 개별 상품 매출 비율 구하기
with 
temp_01 as (
	select a.employee_id, b.product_id, sum(amount) as sum_by_emp_prod
	from nw.orders a
		join order_items b on a.order_id = b.order_id
	group by a.employee_id, b.product_id
)
select employee_id, product_id, sum_by_emp_prod 
	, max(sum_by_emp_prod) over (partition by employee_id) as max_sum_prod
	, sum_by_emp_prod/max(sum_by_emp_prod) over (partition by employee_id) as max_sum_ratio
from temp_01 order by 1,5 desc;


-- 상품별 매출합을 구하되, 상품 카테고리별 매출합의 5% 이상이고, 동일 카테고리에서 상위 3개 매출의 상품 정보 추출. 
-- 1. 상품별 + 상품 카테고리별 총 매출 계산. (상품별 + 상품 카테고리별 총 매출은 결국 상품별 총 매출임)
-- 2. 상품 카테고리별 총 매출 계산 및 동일 카테고리에서 상품별 랭킹 구함
-- 3. 상품 카테고리 매출의 5% 이상인 상품 매출과 매출 기준 top 3 상품 추출.  
with
temp_01 as (
	select a.product_id, max(b.category_id) as category_id, sum(amount) as sum_by_prod
	from nw.order_items a
		join products b on a.product_id = b.product_id 
	group by a.product_id 
),
temp_02 as (
	select product_id, category_id, sum_by_prod
		, sum(sum_by_prod) over (partition by category_id) as sum_by_cat
		, row_number() over (partition by category_id order by sum_by_prod desc) as top_prod_ranking
	from temp_01
)
select *
from temp_02
where sum_by_prod >= 0.05 * sum_by_cat and top_prod_ranking <= 3;

