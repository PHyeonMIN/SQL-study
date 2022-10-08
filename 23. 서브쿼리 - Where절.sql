/************************************************
                  서브쿼리 유형 기본
 *************************************************/

-- 평균 급여 이상의 급여를 받는 직원
select * from hr.emp where sal >= (select avg(sal) from hr.emp);

-- 가장 최근 급여 정보
select * from hr.emp_salary_hist a where todate = (select max(todate) from hr.emp_salary_hist x where a.empno = x.empno);


-- 스칼라 서브쿼리
select ename, deptno, 
	(select dname from hr.dept x where x.deptno=a.deptno) as dname
from hr.emp a;

-- 인라인뷰 서브쿼리
select a.deptno, b.dname, a.sum_sal
from
(
	select deptno, sum(sal) as sum_sal 
	from hr.emp 
	group by deptno
) a 
join hr.dept b 
on a.deptno = b.deptno;

/************************************************
                 where 절 서브쿼리 이해
 *************************************************/
-- ok 10, 20, 30
select a.* from hr.dept a where a.deptno in (select deptno from hr.emp x where x.sal > 1000);

-- 수행 안됨. 에러
select a.*, x.ename from hr.dept a where a.deptno in (select deptno from hr.emp x where x.sal > 1000 );

--ok
select a.* from hr.dept a where exists (select deptno from hr.emp x where x.deptno=a.deptno and x.sal > 1000)

-- 서브쿼리의 반환값은 무조건 중복이 제거된 unique한 값 - 비상관 서브쿼리
select * from nw.orders a where order_id in (select order_id from nw.order_items where amount > 100);
--select * from nw.orders a where order_id in (select distinct order_id from nw.order_items where amount > 100);	-- 같은 결과

-- 서브쿼리의 반환값은 메이쿼리의 개별 레코드로 연결된 결과값에서 무조건 중복이 제거된 unique한 값 - 상관 서브쿼리
select * from nw.orders a where exists (select order_id from nw.order_items x where a.order_id = x.order_id and x.amount > 100);

