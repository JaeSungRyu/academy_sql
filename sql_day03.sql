--3.단일행 함수
--6)CASE 
-- job별로 경조사비를 급여대비 일정 비율로 지급하고 있다.
-- 각 직원들의 경조사비 지원금을 구하자
/*
    CLERK       : 8%
    SALESMAN    : 4%
    MANAGER     : 3.7%
    ANALYST     : 3%
    PRESIDENT   : 1.5%
*/

-- 1. Simple CASE 구문으로 구해보자 : DECODE와 거의 유사, 동일비교만 가능
--                                 괄호가 없고, 콤마 대신 키워드 WHEN,THEN,ELSE등을 사용
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,CASE e.JOB WHEN 'CLERK'    THEN e.SAL * 0.05
                  WHEN 'SALESMAN' THEN e.SAL * 0.04
                  WHEN 'MANAGER'  THEN e.SAL * 0.037
                  WHEN 'ANALYST'  THEN e.SAL * 0.03
                  WHEN 'PRESEDENT'THEN e.SAL * 0.0015                  
                  END AS "경조사 지원금"
FROM emp e
;

-- 2.Searched CASE 구문으로 구해보자.
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,CASE  
      WHEN e.JOB = 'CLERK'     THEN e.SAL * 0.05
      WHEN e.JOB = 'SALESMAN'  THEN e.SAL * 0.04
      WHEN e.JOB = 'MANAGER'   THEN e.SAL * 0.037
      WHEN e.JOB = 'ANALYST'   THEN e.SAL * 0.03
      WHEN e.JOB = 'PRESIDENT' THEN e.SAL * 0.0015
      ELSE 10
      END as "경조사 지원금"
FROM emp e
;
--CASE 결과에 숫자 통화 패턴 씌우기 : $기호,숫자 세자리 끊어 읽기,소수점 이하 2자리
SELECT e.EMPNO
      ,e.ENAME
      ,nvl(e.JOB,'미지정')
      ,TO_CHAR(CASE  
      WHEN e.JOB = 'CLERK'     THEN e.SAL * 0.05
      WHEN e.JOB = 'SALESMAN'  THEN e.SAL * 0.04
      WHEN e.JOB = 'MANAGER'   THEN e.SAL * 0.037
      WHEN e.JOB = 'ANALYST'   THEN e.SAL * 0.03
      WHEN e.JOB = 'PRESIDENT' THEN e.SAL * 0.0015
      ELSE 10
      END,'$99,999.99')as "경조사 지원금"
FROM emp e
;

/*SALGRADE 테이블 내용: 이 회사의 급여 등급 기준 값
GRADE, LOSAL, HISAL
1	   700	   1200
2	   1201	   1400
3	   1401    2000
4	   2001	   3000
5	   3001	   9999
*/
--제공되는 급여 등급을 바탕으로 각 사원들의 급여 등급을 구해보자
--CASE를 사용하여
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,CASE WHEN e.SAL >=700 AND e.SAL <=1200 THEN 1
            WHEN e.SAL >1200 AND e.SAL <=1400 THEN 2
            WHEN e.SAL >1400 AND e.SAL <=2000 THEN 3
            WHEN e.SAL >2000 AND e.SAL <=3000 THEN 4
            WHEN e.SAL >3000 AND e.SAL <=9999 THEN 5
            ELSE 0
      END AS "급여등급"
FROM emp e
ORDER BY "급여등급" asc
;

--WHEN 안의 구문을 BETWEEN AND 로 변경하여 작성
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,CASE  
            WHEN e.SAL BETWEEN 700  AND 1200 THEN 1
            WHEN e.SAL BETWEEN 1201 AND 1400 THEN 2
            WHEN e.SAL BETWEEN 1401 AND 2000 THEN 3
            WHEN e.SAL BETWEEN 2001 AND 3000 THEN 4
            WHEN e.SAL BETWEEN 3001 AND 9999 THEN 5
            ELSE 0
      END AS "급여등급"
FROM emp e
ORDER BY "급여등급" asc
;

SELECT COUNT(MGR) FROM EMP;

--2.그룹함수 (복수행 함수)
--1)COUNT(*) : 특정 테이블의 행의 개수(데이터의 개수)를 세어주는 함수
--             NULL을 처리해주는 <유일한> 그룹함수

--COUNT(expr) : expr으로 등장한 값을 NULL 제외하고 세어주는 함수

--dept, salagrade 테이블의 전체 데이터 개수 조회
SELECT count(*)
FROM dept d;
/*
10	ACCOUNTING	NEW YORK ==>
20	RESEARCH	DALLAS   ==> COUNT(*) ====>4
30	SALES	    CHICAGO  ==>
40	OPERATIONS	BOSTON   ==>
*/
SELECT count(*)  as "급여등급개수"
FROM salgrade s;
/*
1	700	    1200
2	1201	1400
3	1401	2000   count(*) ==> 5
4	2001	3000
5	3001	9999
*/
--emp 테이블에서 job컬럼의 데이터 개수를 카운트
SELECT COUNT(e.JOB) 
 FROM emp e
;
/*7369	CLERK	    SMITH
7499	SALESMAN	ALLEN
7521	SALESMAN	WARD
7566	MANAGER	    JONES
7654	SALESMAN	MARTIN
7698	MANAGER	    BLAKE
7782	MANAGER	    CLARK          ===> count(e.job) = 15
7839	PRESIDENT	KING
7844	SALESMAN	TURNER
7900	CLERK	    JAMES
7902	ANALYST	    FORD
7934	CLERK	    MILLER
9999	CLERK	    J_JONES
8888	CLERK	    J
7777	CLERK	    J\JONES
6666	(null)	    JJ*/  ==> count하지 않음

--회사에 매니저가 배정된 직원이 몇명인가
SELECT COUNT(e.MGR) as "상사있는 직원 수" 
FROM emp e
;

--매니저 직을 맡고 있는 직원이 몇명인가
--1.mgr컬럼을 중복제거해서 조회
--2.그때의 결과를 카운트
SELECT COUNT(DISTINCT e.MGR) as "매니저 수"
FROM emp e
;

--부서가 배정된 직원이 몇명 있는가
SELECT  COUNT(e.deptno) as "부서배정 인원"
       ,COUNT(*) - COUNT(e.deptno) as "부서 미배정 인원" 
FROM emp e;

--COUNT(*) NULL 가 아닌 COUNT(expr) 를 사용한 경우에는
SELECT e.DEPTNO
FROM emp e
WHERE e.DEPTNO IS NOT NULL
;
--을 수행한 결과를 카운트 한 것으로 생각할 수 있다.


--2) SUM() : NULL 항목제외하고
--           합산 가능한 행을 모두 더한 결과를 출력
--           SALESMAN들의 수당 총합을 구해보자
SELECT SUM(e.COMM)
FROM emp e
WHERE e.JOB = 'SALESMAN'
;
/*
(NULL)
(NULL)
300
500
(NULL)
1400
(NULL)
(NULL)
(NULL)
(NULL)           ==> SUM(e.COMM) : comm컬럼이 null인것은 제외
0
(NULL)
(NULL)
(NULL)
(NULL)
(NULL)
*/

--수당 총합 결과에 숫자 출력 패턴,별칭
SELECT TO_CHAR(SUM(e.COMM),'$9,999.99') as "수당총합"
FROM emp e
WHERE e.JOB = 'SALESMAN'
;

--3)AVG(expr) : null값 제외하고 연산 가능한 항목의 산술 평균을 구함
--수당 평균값을 구해보자
SELECT AVG(e.COMM) as "수당 평균"
FROM emp e
;
SELECT TO_CHAR(avg(e.COMM),'$9,999.99') as "수당총합"
FROM emp e
WHERE e.JOB = 'SALESMAN'
;

--4)MAX(expr) : expr에 등장한 값 중 최댓값을 구함
--              expr이 문자인 경우 알파벳 순 뒷쪽에 위치한 최대값으로 계산
--이름이 가장 나중인 직원은 누구인가
SELECT MAX(e.ENAME) 
FROM emp e
;
SELECT MIN(e.ENAME) 
FROM emp e
;

--3.GROUP BY절의 사용
--1)emp 테이블에서 각 부서별 급여의 총합을 조회

--  총합을 구하기 의해 sum()을 사용
--  그룹화 기준을 부서번호(deptno)를 사용
--  그룹화 기준으로 잡은 부서번호가 GROUP BY절에 등장해야 함

--a)emp테이블에서 급여 총합 구하는 구문을 작성
SELECT SUM(e.SAL) 
FROM emp e
;
--b)부서번호(deptno)를 기준으로 그룹화를 진행
--  SUM() 은 그룹함수 이므로 GROUP BY절을 조합하면 그룹화 가능
--  그룹화를 하려면 기준 컬럼을 GROUP BY절에 명시
SELECT   e.deptno
        ,SUM(e.SAL) as "급여총합"
 FROM emp e
GROUP BY e.DEPTNO
;
-------만약 그룹화 기준 컬럼으로 잡지 않은 컬럼이 select에 등장하면 오류 실행 불가
SELECT   e.deptno
        ,SUM(e.SAL) as "급여총합"
        ,e.JOB
FROM emp e
GROUP BY e.DEPTNO
;
--ORA-00979: not a GROUP BY expression
--부서별 급여의 총합,평균,최대급여,최소급여를 구하자
SELECT TO_CHAR(SUM(e.SAL),'99,999.00') "급여총합"
      ,TO_CHAR(AVG(e.SAL),'99,999.00') "급여평균"
      ,TO_CHAR(MAX(e.SAL),'99,999.00') "최대급여"
      ,TO_CHAR(MIN(e.SAL),'99,999.00') "최소급여"
FROM emp e
GROUP BY e.DEPTNO
;
/*GROUP BY절에 등장하는 그룹화 기준 컬럼은 반드시 SELECT 절에 똑같이 등장해야한다.
하지만 위의 쿼리가 실행되는 이유는
SELECT절에 나열된 컬럼중에서 그룹함수가 사용되지 않은 컬럼이 없기 때문
즉,모두다 그룹함수가 사용된 컬럼들이기 때문
*/
--------------------
SELECT e.deptno
      ,TO_CHAR(SUM(e.SAL),'99,999.00') "급여총합"
      ,TO_CHAR(AVG(e.SAL),'99,999.00') "급여평균"
      ,TO_CHAR(MAX(e.SAL),'99,999.00') "최대급여"
      ,TO_CHAR(MIN(e.SAL),'99,999.00') "최소급여"
FROM emp e
GROUP BY e.DEPTNO
ORDER BY e.DEPTNO
;
--부서별,직무별 급여의 총합, 평균, 최대,최소를 구해보자

SELECT e.deptno
      ,e.JOB 
      ,TO_CHAR(SUM(e.SAL),'99,999.00') "급여총합"
      ,TO_CHAR(AVG(e.SAL),'99,999.00') "급여평균"
      ,TO_CHAR(MAX(e.SAL),'99,999.00') "최대급여"
      ,TO_CHAR(MIN(e.SAL),'99,999.00') "최소급여"
FROM emp e
GROUP BY e.DEPTNO,e.JOB
ORDER BY e.DEPTNO,e.JOB
;

-------
SELECT e.deptno
      ,e.JOB --SELECT에는 등장
      ,TO_CHAR(SUM(e.SAL),'99,999.00') "급여총합"
      ,TO_CHAR(AVG(e.SAL),'99,999.00') "급여평균"
      ,TO_CHAR(MAX(e.SAL),'99,999.00') "최대급여"
      ,TO_CHAR(MIN(e.SAL),'99,999.00') "최소급여"
FROM emp e
GROUP BY e.DEPTNO, --GROUP등장하지 않음
ORDER BY e.DEPTNO,e.JOB
;
--ORA-00936: missing expression
--그룹함수가 적용되지 않았고 GROUP BY에도 등장하지 않은 
--JOB컬럼이 SELECT문에 등장하지 않았기 때문에 오류
SELECT e.deptno
      ,e.JOB --SELECT에는 등장
      ,TO_CHAR(SUM(e.SAL),'99,999.00') "급여총합"
      ,TO_CHAR(AVG(e.SAL),'99,999.00') "급여평균"
      ,TO_CHAR(MAX(e.SAL),'99,999.00') "최대급여"
      ,TO_CHAR(MIN(e.SAL),'99,999.00') "최소급여"
FROM emp e
;
--ORA-00937: not a single-group group function
--SELECT에 그룹함수를 썼지만 GROUP BY절을 누락했기 때문에 오류발생
--GROUP BY절에 등장하는 컬럼을 똑같이 SELECT에 등장 시켜야 함!

--JOB별 급여의 총합,평균,최대,최소를 구해보자
SELECT e.JOB
      ,SUM(e.SAL) "급여총합"
      ,AVG(e.SAL) "급여평균"
      ,MAX(e.SAL) "최대급여"
      ,MIN(e.SAL) "최소급여"
FROM emp e
GROUP BY e.JOB
;