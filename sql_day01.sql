--sql day01
--1. scott 계정 활성화 : sys 계정으로 접속하여 스크립트 실행
@D:\oraclexe\app\oracle\product\11.2.0\server\rdbms\admin\scott.sql
--2. 접속유저 확인 명령
show user;
--3.HR계정 활성화 : SYS 계정으로 접속하여
--다른 사용자 확장 후 HR계정의 
--계정잠김,비밀번호 만료 상태 해제

SELECT sysdate
from dual
;

desc emp;
-----------------------------
--scott 계정의 데이터 구조
--(2)emp테이블 내용 조회
select *
from emp 
;
/*
7369	SMITH	CLERK	7902	80/12/17	800		20
7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	30
7521	WARD	SALESMAN	7698	81/02/22	1250	500	30
7566	JONES	MANAGER	7839	81/04/02	2975		20
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30
7698	BLAKE	MANAGER	7839	81/05/01	2850		30
7782	CLARK	MANAGER	7839	81/06/09	2450		10
7839	KING	PRESIDENT		81/11/17	5000		10
7844	TURNER	SALESMAN	7698	81/09/08	1500	0	30
7900	JAMES	CLERK	7698	81/12/03	950		30
7902	FORD	ANALYST	7566	81/12/03	3000		20
7934	MILLER	CLERK	7782	82/01/23	1300		10
*/

--(2)dept테이블 내용조회
SELECT *
FROM dept
;
/*10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON*/

--(3)SALGRADE 테이블 내용 조회
SELECT *
FROM salgrade
;
/*
1	700	1200
2	1201	1400
3	1401	2000
4	2001	3000
5	3001	9999
*/
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
 FROM emp e
 ; --소문자 e는 alias(별칭)

--01. DQL
--(1)select구문
--emp테이블에서 사번,이름,직무를 조회
-- 중복된 값 출력
SELECT e.job
FROM emp e
;
/*CLERK
SALESMAN
SALESMAN
MANAGER
SALESMAN
MANAGER
MANAGER
PRESIDENT
SALESMAN
CLERK
ANALYST
CLERK
*/
-- 중복제거 된 값 출력

-- (2)DISTINCT구문 : SELECT 문 사용시 중복을 배제하여 조회
--EMP테이블에서 JOB컬럼의 중복을 배제하여 조회
SELECT DISTINCT e.job
FROM emp e
;
/*
CLERK
SALESMAN
PRESIDENT
MANAGER
ANALYST
*/

--/*SQL SELECT구문의 작동원리 : 테이블의 한 행을 기본 단위로 실행함.
--                           테이블 행의 개수만큼 반복실행

SELECT 'HELLO,SQL~'
FROM emp e;

--emp 테이블에서 job,deptno에 대해 중복을 제거하여 조회
SELECT DISTINCT 
        e.job
       ,e.deptno
FROM emp e
;
--(3)order by절:정렬
--emp 테이블에서 job을 중복배제하여 조회하고 결과는 오름차순으로 정렬
SELECT DISTINCT
    e.job
    from emp e
    order by e.job asc;
/*ANALYST
CLERK
MANAGER
PRESIDENT
SALESMAN
*/
---------
--(6)emp테이블에서 job을 중복배제하여 조회하고 내림차순으로 정렬
SELECT DISTINCT
    e.job
    from emp e
    order by e.job desc;

/*SALESMAN
PRESIDENT
MANAGER
CLERK
ANALYST
*/

--(7)emp 테이블에서 comm을 가장 많이 받는 순서대로 출력 
--사번,이름,직무,입사일,커미션 순으로 조회
SELECT 
     e.empno
    ,e.ename
    ,e.job
    ,e.hiredate
    ,e.comm
FROM emp e
ORDER BY e.comm desc;
/* null값이 먼저 출력되는것을 확인 null이 정렬에 들어가게 될 때는 가장 먼저 출력됨
7369	SMITH	CLERK	80/12/17	
7698	BLAKE	MANAGER	81/05/01	
7902	FORD	ANALYST	81/12/03	
7900	JAMES	CLERK	81/12/03	
7839	KING	PRESIDENT	81/11/17	
7566	JONES	MANAGER	81/04/02	
7934	MILLER	CLERK	82/01/23	
7782	CLARK	MANAGER	81/06/09	
7654	MARTIN	SALESMAN	81/09/28	1400
7521	WARD	SALESMAN	81/02/22	500
7499	ALLEN	SALESMAN	81/02/20	300
7844	TURNER	SALESMAN	81/09/08	0
*/
--(8)emp테이블에서 comm이 작은 순으로,직무별 오름차순,이름별 오름차순으로 조회
--사번,이름,직무,입사일,커미션을 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.job
      ,e.hiredate
      ,e.comm
 FROM emp e
 ORDER BY e.COMM,e.JOB,e.ENAME
;
/* order by에서 나타난 커미션,잡,이름을 우선순위로 오름차순 정렬이 출력
7844	TURNER	SALESMAN	81/09/08	0
7499	ALLEN	SALESMAN	81/02/20	300
7521	WARD	SALESMAN	81/02/22	500
7654	MARTIN	SALESMAN	81/09/28	1400
7902	FORD	ANALYST	81/12/03	
7900	JAMES	CLERK	81/12/03	
7934	MILLER	CLERK	82/01/23	
7369	SMITH	CLERK	80/12/17	
7698	BLAKE	MANAGER	81/05/01	
7782	CLARK	MANAGER	81/06/09	
7566	JONES	MANAGER	81/04/02	
7839	KING	PRESIDENT	81/11/17	
*/
--(9)emp테이블에서 comm이 적은 순서대로,직무별 오름차순, 이름별 내림차순으로 정렬
--사번 ,이름,직무,입사일,커미션을 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB 
      ,e.HIREDATE
      ,e.COMM
 FROM emp e
 ORDER BY E.COMM,E.JOB,E.ENAME DESC;

--(4)Alias : 별칭
--10)emp테이블에서 풀네임으로 별칭부여
--empno--> Employee No.
--ename--> Employee Name.
--job--> Job No.
SELECT e.EMPNO as "Employee No."
      ,e.ENAME as "Employee Name."
      ,e.JOB as "Job No."
    FROM emp e;
--11)10번과 동일 as키워드 생략하여 조회
--empno--> 사번.
--ename--> 직원이름.
--job--> 직무.
SELECT e.EMPNO as "사번"
      ,e.ENAME as "직원이름"
      ,e.JOB as "직무"
    FROM emp e;
    
--12) 테이블에 붙이는 별칭을 주지 않았을 때
SELECT empno
FROM emp
;

SELECT emp.empno
FROM emp
;
SELECT e.empno --FROM 절에서 설정된 테이블 병칭은 SELECT 절에서 사용됨
FROM emp e -- 소문자 E가 EMP테이블 별칭이며 테이블 별칭은 FROM절에 사용 됨

SELECT d.DEPTNO
FROM dept d;

--13)영문별칭 사용시 특수기호 사용하는 경우
SELECT empno Employee_No
      ,e.ENAME "Employee Name"
    FROM emp e;
--14)별칭과 정렬의 조합 : 별칭을 준 경우 ORDER BY절에서 사용가능
--  EMP테이블에서 사번,이름,직무,입사일,커미션 조회할 때
--  각 컬럼에 대해서 한글별칭을 주어 조회
--  정렬은 커미션,직무,이름을 오름차순 정렬
SELECT e.empno 사번
      ,e.ename 이름
      ,e.job 직무
      ,e.hiredate 입사일
      ,e.comm 커미션
FROM emp e
ORDER BY 커미션,직무,이름;

--15)DISTINCT,별칭,정렬의 조합
--   JOB을 중복을 제거하여 직무라는 별칭을 조회하고
--   내림차순으로 정렬
SELECT DISTINCT e.JOB 직무
FROM emp e
ORDER BY 직무 DESC;
/*
  직무
SALESMAN
PRESIDENT
MANAGER
CLERK
ANALYST
*/
--(5)WHERE 조건절
--16)EMP테이블에서 EMPNO이 7900인 사원의 
--사번,이름,직무,입사일,급여,부서번호
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.HIREDATE
      ,e.SAL
      ,e.DEPTNO
FROM emp e
WHERE e.EMPNO = 7900
;
--17)EMP테이블에서 EMPNO는 7900이거나 DEPTNO가 20인 직원의 정보를 조회
--   사번,이름,직무,입사일,급여,부서번호 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.HIREDATE
      ,e.DEPTNO
FROM emp e
WHERE e.empno = 7900 or e.deptno = 20
;

--18) 17번의 조회조건을 and 조건으로 조합
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.HIREDATE
      ,e.DEPTNO
FROM emp e
WHERE e.empno = 7900 and e.deptno = 20
;
--19)JOB이 'CRERK'이면서 DEPTNO가 10인 직원의
--  사번,이름,직무,부서번호를 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.job
      ,e.DEPTNO
FROM emp e
WHERE e.JOB = 'CLERK' --문자값 비교시 ''사용
AND e.DEPTNO = 10--숫자값 비교시 따옴표 사용 x
;
--20)19번과 비교
SELECT e.EMPNO
      ,e.ENAME
      ,e.job
      ,e.DEPTNO
FROM emp e
WHERE e.JOB = 'clerk' --문자값 비교시 ''사용,문자값 대소문자 구분
AND e.DEPTNO = 10--숫자값 비교시 따옴표 사용 x
;
--(6)연산자 1.산술연산자
--21)사번,이름,급여를 조회하고 급여 3.3%에 해당하는 원천징수 세금을 계산하여 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,e.SAL*0.033 원천징수세금
FROM emp e;
--
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,e.SAL*0.033 원천징수세금
      ,e.SAL*0.967 실수령액
FROM emp e;
--동일 결과출력
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,e.SAL*0.033 원천징수세금
      ,e.SAL - (e.SAL * 0.033) 실수령액
FROM emp e;

--(6)연산자 2.비교연산자
--비교연산자는 SELECT절에 사용할 수 없음
--WHERE,HAVING 절에만 사용함
--22)급여가 2000이 넘는 사원의 사번,이름,금여를 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
    FROM emp e
    WHERE e.SAL > 2000;
--급여가 1000이상인 직원의 사번,이름,급여를 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
    FROM emp e
    WHERE e.SAL >= 1000;
--급여가 1000이상이며 2000미만인 직원 사번,이름,급여를 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
    FROM emp e
    WHERE e.SAL >= 1000 AND e.SAL < 2000;
--COMM값이 0보다 큰 직원의 사번,이름,급여를 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
    FROM emp e
    WHERE e.COMM > 0;
/*
위의 실행결과에서 comm이 (null)인 사람들의 행은
처음부터 비교대상에 들지 않음에 주의해야 한다.
(null)값은 비교 연산자로 비교할 수 없는 값이다.*/


--23)영업사원(SALESMAN)직무를 가진 사람들은 급여와 수당을 함께 받으므로
--영업사원의 실제 수령금을 계산해보자
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL + e.COMM "급여+수당"
      FROM emp e
;
/*숫자값과 널값의 합은 널 값이다.*/
--24)급여가 2000보다 적지 않은 직원의 사번,이름,급여를 조회한다.
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
FROM emp e
WHERE NOT e.SAL < 2000
;
--동일결과를 내는 다른 쿼리 NOT사용하지 않음
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
    FROM emp e
    WHERE e.SAL >= 2000
    ;
--(6)연산자 : 4.SQL연산자
--- IN 연산자 : 비교하고자 하는 기준값이 제시된 항목 목록에 존재하면 참으로 판단
--- 25)급여가 800,3000,5000중 하나인 직원의 사번,이름,급여
SELECT
    e.empno
   ,e.ENAME
   ,e.SAL
FROM emp e
WHERE e.SAL IN(800,3000,5000)
ORDER BY e.SAL ASC
;
--LIKE 연산자 : 유사값을 검색하는데 사용
/*
LIKE 연산자는 유사 값 검색을 위해 함께 사용하는 패턴 인식문자가 있다.
    %:0자릿수 이상의 모든 문자 패턴이 올 수 있음
    _:1자리의 모든 문자 패턴이 올 수 있음
*/
--26)이름이J로 시작하는 직원의 사번,이름 조회
SELECT 
     e.EMPNO
    ,e.ENAME
FROM emp e
WHERE e.ENAME LIKE 'J%'
;
--이름에 E가 들어가는 사람
SELECT 
     e.EMPNO
    ,e.ENAME
FROM emp e
WHERE e.ENAME LIKE '%E%'
;
--이름의 두번째 자리에 M이 들어가는 직원의 사번과 이름 조회
SELECT 
     e.EMPNO
    ,e.ENAME
FROM emp e
WHERE e.ENAME LIKE '_M%' --유사패턴 인식문자를 _패턴으로 사용하면 한글자로 제한함
;
--이름의 두번째 자리에 LA가 들어가는 직원의 사번과 이름 조회
SELECT 
     e.EMPNO
    ,e.ENAME
FROM emp e
WHERE e.ENAME LIKE '_LA%' --유사패턴 인식문자를 _패턴으로 사용하면 한글자로 제한함
;

--이름이 J_ 로 시작하는 직원조회
--조회값에 패턴인식 문자가 들어있는 경우 어떻게 조회할 것인가
SELECT *
FROM emp e
WHERE E.ENAME LIKE 'J\_%' ESCAPE '\'
;
--조회하려는 값에 들어있는 패턴인식 문자를 무효화 하려면 ESCAPE 절과 조합한다.
SELECT *
FROM emp e
WHERE E.ENAME LIKE 'J\%%' ESCAPE '\'
;




--실습1)
SELECT  
     e.empno
    ,e.ename
    ,e.job
    ,e.sal
FROM EMP e
ORDER BY sal desc;
--실습2)
SELECT 
     e.empno
    ,e.ename
    ,e.hiredate
from emp e
ORDER BY hiredate desc;
--실습3)
SELECT 
    e.empno
   ,e.ename
   ,e.comm
FROM emp e
ORDER BY e.comm asc;
--실습4)
SELECT 
    e.empno
   ,e.ename
   ,e.comm
FROM emp e
ORDER BY e.comm desc;
--실습5)
SELECT empno as 사번
      ,ename as 이름
      ,sal  as 급여
      ,hiredate as 입사일
from emp
;
--실습6)
SELECT *
FROM emp
;
--실습7)
SELECT *
FROM emp
WHERE ename = 'ALLEN'
;
--실습8)
SELECT empno
      ,ename
      ,deptno
 FROM emp
WHERE deptno = 20
;
--실습9)
SELECT empno
      ,ename
      ,sal
      ,deptno
FROM emp
where deptno = 20 and sal<3000;
--실습10)
SELECT empno
      ,ename
      ,sal + comm as "급여와 커미션의 합"
FROM emp;
--실습11)
SELECT empno
      ,ename
      ,sal * 12 as "연봉"
FROM emp;      
--실습12)
SELECT empno
      ,ename
      ,job
      ,sal
FROM emp
WHERE ename = 'MARTIN' or ename = 'BLAKE'
;
--실습13)
SELECT empno
      ,ename
      ,job
      ,sal+nvl(comm,0) AS "급여와 커미션의 합"
FROM emp
WHERE ename = 'MARTIN' or ename = 'BLAKE'
;
--실습14)
SELECT *
FROM emp 
WHERE comm != 0;

SELECT *
FROM emp 
WHERE comm > 0;

SELECT *
FROM emp 
WHERE comm >= 1;
--실습15)
SELECT *
FROM emp
WHERE comm is not null;
--실습16)
SELECT *
FROM emp e
WHERE DEPTNO = 20 and SAL > 2500
;
--실습17)
SELECT *
FROM emp e
WHERE job = 'MANAGER' OR deptno = 10
;
--실습18)
SELECT *
FROM emp e
WHERE job IN ('MANAGER','CLERK','SALESMAN')
;
--실습19)
SELECT *
FROM emp e
WHERE ename LIKE 'A%'
;
--실습20)
SELECT *
FROM emp e
WHERE ename LIKE '%A%'
;
--실습21)
SELECT *
FROM emp e
WHERE ename LIKE '%S'
;
--실습22)
SELECT *
FROM emp e
WHERE ename LIKE '%E_'
;
--실습22)
SELECT *
FROM emp e
WHERE ename LIKE '%E_'
;
--실습23)
SELECT *
FROM emp e
WHERE e.SAL BETWEEN 2500 AND 3000
;
--실습24)
SELECT *
FROM emp e
WHERE e.ENAME LIKE '%E_'
;
--실습25)
SELECT *
FROM emp e
WHERE e.COMM IS NOT NULL
;
--실습26)
SELECT e.EMPNO 사번
      ,e.ENAME ||'의 월급은 ' || e.SAL ||'입니다'  as "월급여"   
  FROM emp e
WHERE    e.ENAME = 'SMITH' 
      OR e.ENAME = 'ALLEN' 
      OR e.ENAME = 'WARD' 
      OR e.ENAME = 'JONES'
ORDER BY e.sal asc
;