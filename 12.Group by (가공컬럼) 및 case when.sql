/************************************
   Group by 실습 - 03(Group by절에 가공 컬럼 및 case when 적용)
*************************************/

select deptno, count(*)
from hr.emp
group by deptno;

select to_char(hiredate,'yyyy') as hireyear, count(*)
from hr.emp
group by to_char(hiredate, 'yyyy')
order by 1
;

-- emp 테이블에서 입사년도별 평균 급여 구하기.  
select to_char(hiredate, 'yyyy') as hire_year, avg(sal) as avg_sal , count(*) as cnt
from hr.emp
group by to_char(hiredate, 'yyyy')
order by 1;


-- 1000미만, 1000-1999, 2000-2999와 같이 1000단위 범위내에 sal이 있는 레벨로 group by 하고 해당 건수를 구함. 
-- float 소수점을 없애버림
select floor(sal/1000)*1000 as bin_range, count(*) as cnt, sum(sal)
from hr.emp
group by floor(sal/1000)*1000
order by 1
;

select *, floor(sal/1000)*1000 as bin_range , 1.0 * sal/1000 as sal_01, floor(sal/1000)
from hr.emp; 

-- job이 SALESMAN인 경우와 그렇지 않은 경우만 나누어서 평균/최소/최대 급여를 구하기. 
-- if a=10 then 
select *, case when job='SALESMAN' then sal end as sales_sal
		, case when job='MANAGER' then sal end as manager_sal
from hr.emp;

select case when job = 'SALESMAN' then 'SALESMAN'
		      else 'OTHERS' end as job_gubun
	   , avg(sal) as avg_sal, max(sal) as max_sal, min(sal) as min_sal --, count(*) as cnt
from hr.emp
group by case when job = 'SALESMAN' then 'SALESMAN'
		      else 'OTHERS' end ;