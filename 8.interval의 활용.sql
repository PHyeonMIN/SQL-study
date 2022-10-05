/******************************************************
날짜와 시간 연산. interval의 활용. 
*******************************************************/

-- 날짜 연산 
-- Date 타입에 숫자값을 더하거나/빼면 숫자값에 해당하는 일자를 더해거나/빼서 날짜 계산. 
select to_date('2022-01-01', 'yyyy-mm-dd') +  2 as date_01;

-- Date 타입에 곱하기나 나누기는 할 수 없음. 
select to_date('2022-01-01', 'yyyy-mm-dd') * 10 as date_01;	-- 에러

-- Timestamp 연산. +7을 하면 아래는 오류를 발생. 
select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + 7;	-- 에러

-- Timestamp는 interval 타입을 이용하여 연산 수행. 
select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + interval '7 hour' as timestamp_01;

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + interval '2 days' as timestamp_01;

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + interval '2 days 7 hours 30 minutes' as timestamp_01;

-- Date 타입에 interval을 더하면 Timestamp로 변환됨. 
select to_date('2022-01-01', 'yyyy-mm-dd') + interval '2 days' as date_01;

-- interval '2 days'와 같이 ' '내에는 days나 day를 혼용해도 되지만 interval '2' day만 허용. 
select to_date('2022-01-01', 'yyyy-mm-dd') + interval '2' day as date_01;

-- 날짜 간의 차이 구하기. 차이값은 정수형.  
select to_date('2022-01-03', 'yyyy-mm-dd') - to_date('2022-01-01', 'yyyy-mm-dd') as interval_01
	, pg_typeof(to_date('2022-01-03', 'yyyy-mm-dd') - to_date('2022-01-01', 'yyyy-mm-dd')) as type ;	-- integer

-- Timestamp간의 차이 구하기. 차이값은 interval 
select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') 
     - to_timestamp('2022-01-01 12:36:52', 'yyyy-mm-dd hh24:mi:ss') as time_01
     , pg_typeof(to_timestamp('2022-01-01 08:36:52', 'yyyy-mm-dd hh24:mi:ss') 
     - to_timestamp('2022-01-01 12:36:52', 'yyyy-mm-dd hh24:mi:ss')) as type	-- interval
;

-- date + date는 허용하지 않음. 
select to_date('2022-01-03', 'yyyy-mm-dd') +  to_date('2022-01-01', 'yyyy-mm-dd')

-- now(), current_timestamp, current_date, current_time 
-- interval을 년, 월, 일로 표시하기. justify_interval와 age 사용 차이
with 
temp_01 as (
select empno, ename, hiredate, now(), current_timestamp, current_date, current_time
	, date_trunc('second', now()) as now_trunc
	, now() - hiredate as 근속기간
from hr.emp
)
select * from temp_01;
select *
	, date_part('year', 근속기간)
	, justify_interval(근속기간)
	, age(hiredate)
	, date_part('year', justify_interval(근속기간))||'년 '||date_part('month', justify_interval(근속기간))||'월' as 근속년월
	, date_part('year', age(hiredate))||'년 '||date_part('month', age(hiredate))||'월' as 근속년월_01
from temp_01;