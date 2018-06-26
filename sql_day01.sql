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




--------실습1---------
SELECT DISTINCT 
     e.empno
    ,e.ename
    ,e.job
    ,e.sal
FROM EMP e
ORDER BY sal desc;
--------실습2---------
SELECT DISTINCT
     e.empno
    ,e.ename
    ,e.hiredate
from emp e
ORDER BY hiredate desc;
--------실습3---------
SELECT 
    e.empno
   ,e.
   
   commit;

