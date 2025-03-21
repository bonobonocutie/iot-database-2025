-- 실무실습 계속
-- 서브쿼리 계속
/* 문제1
	사원의 급여 정보 중 업무별 최소 급여를 받는 사원의 
    이름, 성, 별칭, 업무, 급여, 입사일로 출력(21행)
*/
desc jobs;

select concat(first_name, ' ' , last_name) as name,
		e1.job_id, e1.salary, e1.hire_date
from employees as e1
where (e1.job_id, e1.salary) 
in (select e.job_id, min(e.salary) as salary
	from employees as e
	group by e.job_id);
    
-- 집합연산자 : 테이블 내용을 합쳐서 조회

-- 조건부 논리 표현식 제어 : case -> if문과 동일
/* 샘플
	프로젝트 성공으로 급여인상이 결정됨.
    사원현재 107명 19개 업무에 소속되어 근무중. 5개 업무에서 일하는 사원.
    hr_rep(10), mk_rep(12), pr_rep(15), sa_rep(18), it_prog(20%)
    5개 업무를 제외하고는 나머지는 동결(107개행)
*/
select employee_id,
		concat(first_name, ' ' , last_name) as name,
        job_id, salary,
        case job_id when 'HR_REP' then salary * 1.1
					when 'MK_REP' then salary * 1.12
                    when 'PR_REP' then salary * 1.15
                    when 'SA_REP' then salary * 1.18
                    when 'IT_PROG' then salary * 1.2
                    else salary
        end as NewSalary
from employees;

/* 문제3
	월별로 입사한 사원수가 행별로 출력되도록 하시오.(12행)
*/
-- 형변환 함수 cast(), convert()
select cast('09' as unsigned); -- signed(음수포함 숫자형)
select convert('09', signed); -- unsigned(양수만 숫자형)
select convert(00009, char);
select convert('20250307', date);

-- 컬럼을 입사일 중 월만 추출해서 숫자로 변경
select convert(date_format(hire_date, '%m'), signed)
from employees;

select date_format(hire_date, '%m') as month, count(*)
from employees
group by month
order by month;

-- rollup
/* 샘플
	부서와 업무별 급여합계를 구하고 신년도 급여수준 레벨을 지정하려고 함.
    부서 번호와 업무를 기준으로 행을 그룹별로 나누어 급여합계와 인원수를 출력(20행)
*/
select department_id, job_id,
		concat('$', format(sum(salary), 0)) as 'salary sum',
        count(employee_id) as 'count emps'
from employees
group by department_id, job_id
order by department_id;

-- 각 총계
select department_id, job_id,
		concat('$', format(sum(salary), 0)) as 'salary sum',
        count(employee_id) as 'count emps'
from employees
group by department_id, job_id
-- group by의 컬럼이 하나면 총계는 하나, 컬럼이 두개면 첫번째 컬럼별로 소계 후 두 컬럼의 합산이 총계로
with rollup; 

/* 문제1
	이전문제를 활용, 집계결과가 아니면 all-depts라고 출력.(33행)
    업무에 대한 집계결과가 아니면 all-jobs를 출력
	rollup으로 만들어진 소계면 all-jobs, 총계면 all-depts
*/
select case grouping(department_id) when 1 then 'all-jobs' else ifnull(department_id, '부서없음') end as 'depts',
		case grouping(job_id) when 1 then 'all-jobs' else job_id end as 'jobs',
        concat('$', format(sum(salary), 0)) as 'salary sum',
        count(employee_id) as 'count emps',
        -- grouping(department_id),
        -- grouping(job_id),
        format(avg(salary) * 12, 0) as 'avg ann_sal'
from employees
group by department_id, job_id
with rollup;

-- rank
/* 샘플
	분석함수 ntile() 사용, 부서별 급여 합계를 구하시오.
    급여가 제일 큰 것이 1, 제일 작은 것이 4가 되도록 등급을 나눔(12행)
*/
select department_id,
		sum(salary) as 'sum salary',
		ntile(4) over (order by sum(salary) desc) as 'bucket#' -- 범위별로 등급 매기는 키워드
from employees
group by department_id;

/* 문제1
	부서별 급여를 기준으로 내림차순 정렬하시오.
    이때 다음 세가지 함수를 활용하여 순위를 출력하시오.(107행)
*/
select employee_id, last_name, salary, department_id,
		rank() over (partition by department_id order by salary desc) as 'rank', -- 1, 1, 3 순위매기기 rank
		dense_rank() over (partition by department_id order by salary desc) as 'dense_rank', -- 1, 1, 2 순위매기기 dense_rank
        row_number() over (partition by department_id order by salary desc) as 'row_number'-- 행번호 매기기
from employees
order by department_id, salary desc;