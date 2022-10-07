/* 0. 강의 SQL */

-- order_items 테이블에서 order_id 별 amount 총합까지 표시
select order_id, line_prod_seq, product_id, amount 
	, sum(amount) over (partition by order_id) as total_sum_by_ord
from order_items;

-- order_items 테이블에서시 order_id별 line_prod_seq순으로  누적 amount 합까지 표시
select order_id, line_prod_seq, product_id, amount 
	, sum(amount) over (partition by order_id) as total_sum_by_ord
	, sum(amount) over (partition by order_id order by line_prod_seq rows between unbounded preceding and current row) as cum_sum_by_ord
from order_items;

-- order_items 테이블에서 order_id별 line_prod_seq순으로  누적 amount 합 - partition 또는 order by 절이 없을 경우 windows. 
select order_id, line_prod_seq, product_id, amount 
	, sum(amount) over (partition by order_id) as total_sum_by_ord
	, sum(amount) over (partition by order_id order by line_prod_seq rows between unbounded preceding and current row) as cum_sum_by_ord
	, sum(amount) over () as total_sum	-- 다합친거
from order_items where order_id between 10248 and 10250;

-- order_items 테이블에서 order_id 별 상품 최대 구매금액, order_id별 상품 누적 최대 구매금액
select order_id, line_prod_seq, product_id, amount 
	, max(amount) over (partition by order_id) as max_by_ord
	, max(amount) over (partition by order_id order by line_prod_seq) as cum_max_by_ord
from order_items where order_id between 10248 and 10250;

-- order_items 테이블에서 order_id 별 상품 최소 구매금액, order_id별 상품 누적 최소 구매금액
select order_id, line_prod_seq, product_id, amount 
	, min(amount) over (partition by order_id) as min_by_ord
	, min(amount) over (partition by order_id order by line_prod_seq) as cum_min_by_ord
from order_items where order_id between 10248 and 10250;

-- order_items 테이블에서 order_id 별 상품 평균 구매금액, order_id별 상품 누적 평균 구매금액
select order_id, line_prod_seq, product_id, amount 
	, avg(amount) over (partition by order_id) as avg_by_ord
	, avg(amount) over (partition by order_id order by line_prod_seq) as cum_avg_by_ord
from order_items where order_id between 10248 and 10250;
