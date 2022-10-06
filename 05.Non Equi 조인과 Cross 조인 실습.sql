/************************************
   조인 실습 - Non Equi 조인과 Cross 조인. 
*************************************/

select * from hr.salgrade;

select * from hr.emp;

-- 직원정보와 급여등급 정보를 추출. 
select a.*, b.grade as salgrade
from hr.emp a 
	join hr.salgrade b on a.sal between b.losal and b.hisal;


-- 직원 급여의 이력정보를 나타내며, 해당 급여를 가졌던 시작 시점에서의 부서번호도 함께 가져올것. 
select * 
from hr.emp_salary_hist a
	join hr.emp_dept_hist b on a.empno = b.empno and a.fromdate between b.fromdate and b.todate; 
-- between 대신에 where절을 사용해도 된다. 하지만 between을 사용하면 join 양을 줄여주기 때문에 성능상 좋다.



-- cross 조인
with			-- with 절 : 임시 테이블을 만드는 것
temp_01 as (
select 1 as rnum 
union all
select 2 as rnum
)
select a.*, b.*
from hr.dept a 
	cross join temp_01 b;
