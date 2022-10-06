/************************************
   조인 실습 - Outer 조인. 
*************************************/	

-- 주문이 단 한번도 없는 고객 정보 구하기. 
select a.customer_id , a.contact_name , b.order_id , b.customer_id 
from nw.customers a
	left outer join nw.orders b on a.customer_id = b.customer_id
where b.order_id is null
;

-- 부서정보와 부서에 소속된 직원명 정보 구하기. 부서가 직원을 가지고 있지 않더라도 부서정보는 표시되어야함. 
select a.*, b.empno , b.ename 
from hr.dept a
	left join hr.emp b on a.deptno = b.deptno
; 
-- 같은 결과 : right join 사용 -> 같게 나온다. 그렇기에 right join을 잘 사용하지 않는다.
select a.*, b.empno, b.ename
from hr.emp b
	right join hr.dept a on a.deptno = b.deptno
;


-- Madrid에 살고 있는 고객이 주문한 주문 정보를 구할것.
-- 고객명, 주문id, 주문일자, 주문접수 직원명, 배송업체명을 구하되, 
-- 만일 고객이 주문을 한번도 하지 않은 경우라도 고객정보는 빠지면 안됨. 이경우 주문 정보가 없으면 주문id를 0으로 나머지는 Null로 구할것. 
select a.customer_id , a.contact_name , coalesce(b.order_id, 0) as order_id						--coalesce : b.order_id가 null 이면 0값으로 해라 
	, c.first_name || ' ' || c.last_name as employee_name , d.company_name as shipper_name
from nw.customers a
	left join nw.orders b on a.customer_id = b.customer_id
	left join nw.employees c on b.employee_id = c.employee_id	-- left를 빼면 마지막 결과가 left join 값이 빠진다.
	left join nw.shippers d on b.ship_via = d.shipper_id 
where a.city = 'Madrid'
;

-- orders_items에 주문번호(order_id)가 없는 order_id를 가진 orders 데이터 찾기 
select *
from nw.orders a
	left join nw.order_items b on a.order_id = b.order_id 
where b.order_id is null;


-- orders 테이블에 없는 order_id가 있는 order_items 데이터 찾기. 
select * 
from nw.order_items a
	left join nw.orders b on a.order_id = b.order_id 
where b.order_id is null;
