/************************************
   Group by cube
*************************************/

-- deptno, job의 가능한 결합으로 Group by 수행. 
select deptno, job, sum(sal)
from hr.emp
group by cube(deptno, job)
order by 1, 2;

-- 상품 카테고리 + 상품별 + 주문처리직원별 매출
select c.category_name, b.product_name, e.last_name||e.first_name as emp_name, sum(amount) 
from nw.order_items a
	join nw.products b on a.product_id = b.product_id
	join nw.categories c on b.category_id = c.category_id
	join nw.orders d on a.order_id = d.order_id
	join nw.employees e on d.employee_id = e.employee_id
group by c.category_name, b.product_name, e.last_name||e.first_name
order by 1, 2, 3
;

--상품 카테고리, 상품별, 주문처리직원별 가능한 결합으로 Group by 수행
select c.category_name, b.product_name, e.last_name||e.first_name as emp_name, sum(amount) 
from nw.order_items a
	join nw.products b on a.product_id = b.product_id
	join nw.categories c on b.category_id = c.category_id
	join nw.orders d on a.order_id = d.order_id
	join nw.employees e on d.employee_id = e.employee_id
group by cube(c.category_name, b.product_name, e.last_name||e.first_name)
order by 1, 2, 3
;