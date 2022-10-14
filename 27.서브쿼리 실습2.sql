/************************************************
     서브쿼리 실습 - 직원의 가장 최근 부서 근무이력 조회
 *************************************************/

drop table if exists hr.emp_dept_hist_01;

-- todate가 99991231가 아닌 경우를 한개 레코드로 생성하기 위해 임시 테이블 생성
create table hr.emp_dept_hist_01
as
select * from hr.emp_dept_hist;


update hr.emp_dept_hist_01
set todate=to_date('1983-12-24', 'yyyy-mm-dd') 
where empno = 7934 and todate=to_date('99991231', 'yyyymmdd');

select * from hr.emp_dept_hist_01;

-- 직원의 가장 최근 부서 근무이력 조회. 비상관 서브쿼리
select * from hr.emp_dept_hist_01 a where (empno, todate) in (select empno, max(todate) from hr.emp_dept_hist_01 x
group by empno);

-- 상관 서브쿼리
select * from hr.emp_dept_hist_01 a where todate = (select max(todate) from hr.emp_dept_hist_01 x where x.empno=a.empno);

-- Analytic SQL
select *
from (
select * 
	, row_number() over (partition by empno order by todate desc) as rnum
from hr.emp_dept_hist_01
)a where rnum = 1;


/************************************************
 서브쿼리 실습 - 고객의 첫번째 주문일의 주문정보와 고객 정보를 함께 추출
 *************************************************/

-- 고객의 첫번째 주문일의 order_id, order_date, shipped_date와 함께 고객명(contact_name), 고객거주도시(city) 정보를 함께 추출
select a.order_id, a.order_date, a.shipped_date, b.contact_name, b.city 
from nw.orders a
	join nw.customers b on a.customer_id = b.customer_id
where a.order_date = (select min(order_date) from nw.orders x where x.customer_id = a.customer_id);

-- Analytic SQL
select order_id, order_date, shipped_date, contact_name, city
from
(
select a.order_id, a.order_date, a.shipped_date, b.contact_name, b.city,
	row_number() over (partition by a.customer_id order by a.order_date) as rnum
from nw.orders a
	join nw.customers b on a.customer_id = b.customer_id
)a where rnum = 1;

/************************************************
 서브쿼리 실습 - 고객별 주문 상품 평균 금액보다 더 큰 금액의 주문 상품명, 주문번호, 주문 상품금액을 구하되 고객명과 고객도시명을 함께 추출
 *************************************************/

-- 고객별 주문상품 평균 금액 
select a.customer_id, avg(b.amount) avg_amount from nw.orders a
join nw.order_items b
on a.order_id = b.order_id
group by customer_id;

-- 상관 서브쿼리로 구하기
select a.customer_id, a.contact_name, a.city, b.order_id, c.product_id, c.amount, d.product_name
from nw.customers a
	join nw.orders b on a.customer_id = b.customer_id
	join nw.order_items c on b.order_id = c.order_id
	join nw.products d on c.product_id = d.product_id
where c.amount >= (select avg(y.amount) avg_amount 
					from nw.orders x
						join nw.order_items y on x.order_id = y.order_id
					where x.customer_id =a.customer_id
					group by x.customer_id
					)
order by a.customer_id, amount;
				
-- Analytic SQL로 구하기 				
select customer_id, contact_name, city, order_id, product_id, amount, product_name
from (
	select a.customer_id, a.contact_name, a.city, b.order_id, c.product_id, c.amount, d.product_name
	, avg(amount) over (partition by a.customer_id rows between unbounded preceding and unbounded following) as avg_amount
	from nw.customers a
		join nw.orders b on a.customer_id = b.customer_id
		join nw.order_items c on b.order_id = c.order_id
		join nw.products d on c.product_id = d.product_id
) a 
where a.amount >= a.avg_amount
order by customer_id, amount;

/************************************************
 Null값이 있는 컬럼의 not in과 not exists 차이 실습
 *************************************************/

select * from hr.emp where deptno in (20, 30, null);

select * from hr.emp where deptno = 20 or deptno=30 or deptno = null;


-- 테스트를 위한 임의의 테이블 생성. 
drop table if exists nw.region;

create table nw.region
as
select ship_region as region_name from nw.orders 
group by ship_region 
;

-- 새로운 XX값을 region테이블에 입력. 
insert into nw.region values('XX');

commit;

select * from nw.region;
