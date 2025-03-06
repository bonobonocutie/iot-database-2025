-- SQL Practice
/* 샘플
	Employee에서 사원번호, 이름, 급여, 업무, 입사일, 상시의 사원번호를 출력하시오.
	이때 이름과 성을 연결하여 Full Name이라는 별칭으로 출력하시오. (107행)
*/
select employee_id,
		concat(first_name, ' ', last_name) as 'full name',
        salary,
        job_id,
        hire_date,
        manager_id
from employees;

/* 문제1
	employee에서 사원의 성과 이름을 name, 업무는 job, 급여는 salary, 연봉에 $100 보너스를 추가해서
    계산한 increased ann_salary, 급여에 $100 보너스를 추가해서 increased salary 별칭으로 출력하시오.(107행)
*/
select concat(first_name, ' ', last_name) as name,
		job_id as job,
        salary,
        (salary * 12) + 100 as 'increased ann salary',
        (salary + 100) * 12 as 'increased salary'
from employees;

/* 문제2
	employee에서 모든 사원의 last_name과 연봉을 '이름: 1 year salary = $연봉' 형식으로 출력하고
    1 year salary라는 별칭으로 붙이세요. (107행)
*/
select concat(last_name, ': 1 year salary = $', (salary * 12) + 100)
from employees;

/* 문제3
	부서에 담당하는 업무를 한번씩만 출력하시오.(20행)
*/
select distinct department_id, job_id
from employees;

-- where, order by
/* 샘플
	hr부서 예산 편성 문제로 급여 정보 보고서를 작성한다. employees에서 salary가 700 ~ 10000달러
    범위 이외의 사람의 성과 이름 급여를 급여가 작은 순서로 출력하시오/(75행)
*/
select concat(first_name, ' ', last_name) as name,
		salary
from employees
where salary not between 7000 and 10000;

/* 문제1
	사원의 last_name 중 e나 o 글자를 포함한 사원을 출력하시오.
    이때 컬럼명은 e and o name 이라고 출력하시오.(10행)
*/
select last_name as 'e and o name'
from employees
where last_name like '%e%' and last_name like '%o%';

/* 문제2
	현재 날짜 타입을 날짜함수를 통해 확인, 1955년 5월 20일 ~ 1996년 5월 20일 사이 입사한
    사원의 이름, 사원번호, 고용일자를 입사일이 빠른 순으로 정렬하시오.(8행)
*/
select date_add(sysdate(), interval 9 hour) as 'sysdate()';

desc employees;

select last_name as name,
		employee_id,
		hire_date
from employees
where hire_date between '1995-05-20' and '1996-05-20' -- date타입은 문자열처럼 조건연산을 해도 됨
order by hire_date;

-- 단일행 함수 및 변환 함수
/* 문제1
	이름이 s로 시작하는 각 사원의 업무를 아래의 예와 같이 출력하고
    머리글은 employye jobs로 표시할 것.(18행)
*/
select concat(first_name, ' ', last_name, ' is a ', upper(job_id)) as 'employee jobs'
from employees
where last_name like '%s';

/* 문제3
	사원의 성과 이름, 입사일, 입사한 요일을 출력하시오.
    이때 주 시작인 일요일부터 출력되도록 정렬(107행)
*/
select concat(first_name, ' ' , last_name) as name,
		hire_date,
        date_format(hire_date, '%W') as 'day of the week'
from employees
order by date_format(hire_date, '%w');

-- 집계함수
/* 문제1
	사원이 소속된 부서별 급여 합계, 급여 평균, 급여 최대값, 급여 최소값을 집계.
    출력값은 여섯자리와 세자리 구분기호, $ 표시 포함, 부서번호를 오름차순
    단, 부서에 소속되지 않는 사원은 정보에서 제외(11행)
*/
select department_id,
		-- round(값, 1): 소수점 1자리까지, format(값, 1): 소수점 표현 및 1000단위 , 표시
		concat('$', format(round(sum(salary), 0), 0)) as 'sum salary',
		concat('$', format(round(avg(salary), 1), 1)) as 'avg salary',
		concat('$', format(round(max(salary), 0), 0)) as 'max salary',
		concat('$', format(round(min(salary), 0), 0)) as 'min salary'
from employees
where department_id is not null
group by department_id; -- 그룹바이 속한 컬럼만 select 절에 사용할 수 있음!

-- 조인
/* 문제2
	job_grades 테이블을 사용, 각 사원의 급여에 따른 급여등급을 보고한다.
    이름과 성, 업무, 부서명, 입사일 ,급여, 급여등급을 출력(106행)
*/
desc job_grades;
desc employees;

select * 
from departments as d inner join employees as e
on d.department_id = e.department_id; -- ANSI standart SQL 쿼리

select concat(e.first_name, ' ', e.last_name) as name,
		e.job_id,
        d.department_name,
        e.hire_date,
        e.salary,
        (select grade_level from job_grades
		 where e.salary between lowest_sal and highest_sal) as 'grade_level'
from departments as d, employees as e
where d.department_id = e.department_id
order by e.salary desc;

/* 문제3
	각 사원의 상사와의 관계를 이용, 보고서 작성을 하려고 함.(107행)
*/
select concat(e2.first_name, ' ', e2.last_name) as employee,
		'report to',
		upper(concat(e1.first_name, ' ', e1.last_name)) as manager
from employees as e1, employees as e2
where e1.employee_id = e2.manager_id;

-- 서브쿼리
/* 문제3
	사원들의 지역별 근무현황을 조회. 도시 이름이 영문 'o'로 시작하는
    지역에 사는 경우 사번, 이름, 업무, 입사일 출력하시오.(34행)
*/
select e.employee_id,
		concat(e.first_name, ' ', e.last_name) as name,
        e.job_id,
        e.hire_date
from employees as e, departments as d
where e.department_id = d.department_id
and d.location_id = (select location_id from locations where city like 'o%');