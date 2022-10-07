/* 1. aggregation analytic 실습 */ 

-- 직원 정보 및 부서별로 직원 급여의 hiredate순으로 누적 급여합. 
select empno, ename, deptno, hiredate, sal 
	, sum(sal) over (partition by deptno order by hiredate) as cum_sal 
from hr.emp;

--직원 정보 및 부서별 평균 급여와 개인 급여와의 차이 출력
select empno, ename, deptno, hiredate, sal
	, avg(sal) over (partition by deptno) as avg_sal
	, sal - avg(sal) over (partition by deptno) as diff_sal
from hr.emp
order by deptno 
;

-- analytic을 사용하지 않고 위와 동일한 결과 출력
with 
temp_01 as (
	select deptno, avg(sal) as avg_sal
	from hr.emp group by deptno
)
select empno, ename, a.deptno, hiredate, sal
	, sal - avg_sal as diff_sal
from hr.emp a
	join temp_01 b on a.deptno = b.deptno
order by deptno;

-- 직원 정보및 부서별 총 급여 대비 개인 급여의 비율 출력(소수점 2자리까지로 비율 출력)
select empno, ename, deptno, hiredate, sal
	, sum(sal) over (partition by deptno) as dept_sum_sal
	, round(sal/sum(sal) over (partition by deptno),2) as dept_sum_sal_ratio
from hr.emp;

-- 직원 정보 및 부서에서 가장 높은 급여 대비 비율 출력(소수점 2자리까지로 비율 출력)
select empno, ename, deptno, hiredate, sal
	, max(sal) over (partition by deptno) as dept_max_sal
	, round(sal/max(sal) over (partition by deptno),2) as dept_max_sal_ratio
from hr.emp;

