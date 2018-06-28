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
----
SELECT nvl(e.JOB,'직무미배정')
      ,SUM(e.SAL) "급여총합"
      ,AVG(e.SAL) "급여평균"
      ,MAX(e.SAL) "최대급여"
      ,MIN(e.SAL) "최소급여"
FROM emp e
GROUP BY e.JOB
;

--부서 미배정이어서 NULL데이터는 부서번호대신 '미배정'이라고 분류
SELECT NVL(e.deptno||'','미배정')
      ,TO_CHAR(SUM(e.SAL),'99,999.00') "급여총합"
      ,TO_CHAR(AVG(e.SAL),'99,999.00') "급여평균"
      ,TO_CHAR(MAX(e.SAL),'99,999.00') "최대급여"
      ,TO_CHAR(MIN(e.SAL),'99,999.00') "최소급여"
FROM emp e
GROUP BY e.DEPTNO
ORDER BY e.DEPTNO
;
--------
SELECT DECODE(NVL(e.deptno,0),
              e.DEPTNO,e.DEPTNO||''
             ,'미배정')부서번호
      ,TO_CHAR(SUM(e.SAL),'99,999.00') "급여총합"
      ,TO_CHAR(AVG(e.SAL),'99,999.00') "급여평균"
      ,TO_CHAR(MAX(e.SAL),'99,999.00') "최대급여"
      ,TO_CHAR(MIN(e.SAL),'99,999.00') "최소급여"
FROM emp e
GROUP BY e.DEPTNO
ORDER BY e.DEPTNO
;

----4.HAVING절의 사용
--GROUP BY 결과에 조건을 걸어서
--결과를 제한(필터링) 할 목적으로 사용되는 절

--문제)부서별 급여평균이 2000인 부서 
--a)부서별 급여 평균구함
SELECT e.deptno
      ,TO_CHAR(AVG(e.SAL),'99,999.00') "급여평균"
      FROM emp e
GROUP BY e.DEPTNO 
ORDER BY e.DEPTNO
;
--b)a의 결과에서 2000이상인 부서만 남긴다
SELECT e.deptno
      ,TO_CHAR(AVG(e.SAL),'99,999.00') "급여평균"
      FROM emp e
GROUP BY e.DEPTNO 
HAVING AVG(e.SAL) >= 2000
ORDER BY e.DEPTNO
;

SELECT e.deptno
      ,TO_CHAR(AVG(e.SAL),'99,999.00') "급여평균"
      FROM emp e
GROUP BY e.DEPTNO 
HAVING "급여평균" >= 2000
ORDER BY e.DEPTNO
;
--HAVING절을 사용하여 조건을 걸때 주의할 점 : 별칭을 쓸 수 없음
-- HAVING 절이 존재하는 경우 SELECT의 구문의 실행 순서 정리
/*
1. FROM 절의 테이블 각 행을 대상으로
2. WHERE 절의 조건에 맞는 행만 선택하고
3. GROUP BY 졸에 나온 컬럼, 식(함수 식등)으로 그룹화를 진행
4. HAVING절의 조건을 만족시키는 그룹행만 선택
5. 4까지 선택된 그룹 정보를 가진 행에 대해서
   SELECT 절에 명시된 컬럼, 식(함수 식)등만 출력
6. ORDER BY 가 있다면 정렬 조건에 맞추어 최종 정렬하여 보여준다.
*/




--수업중 실습
--1.매니저별,부하직원의 수를 구하고, 많은 순으로 정렬
SELECT e.MGR
      ,COUNT(e.MGR)
 FROM emp e
 WHERE e.MGR IS NOT NULL
 GROUP by e.MGR
 ORDER BY count(*) desc
 ;


--2.부서별 인원 수을 구하고, 인원수 많은 순으로 정렬
SELECT e.DEPTNO
      ,COUNT(*)
 FROM emp e
 GROUP BY deptno
 ORDER BY count(*) desc;

--3.직무별 급여 평균을 구하고, 급여평균 높은 순으로 정렬
SELECT e.JOB "직무"
      ,AVG(e.SAL) "평균급여"
 FROM emp e
 GROUP BY job
 ORDER BY "평균급여" desc
 ;


--4.직무별 급여총합을 구하고 높은 순으로 정렬
SELECT e.DEPTNO
      ,SUM(e.SAL) "급여총합"
 FROM emp e
 GROUP BY deptno
 ORDER BY "급여총합" desc
 ;

--5.급여의 앞 단위가 1000이하,1000,2000,3000,4000,5000별로 인원수를 구하시오
--  급여단위 오름차순 정렬

--a)급여 단위를 어떻게 구할것인가? TRUNC()활용
SELECT e.EMPNO
      ,e.ENAME
      ,TRUNC(e.SAL,-3) as "급여단위"
    FROM emp e
    ;
--b)TRUNC로 얻어낸 급여단위를 COUNT 하면 인원를 구할 수 있다.
SELECT TRUNC(e.SAL,-3) as "급여단위"
      ,COUNT(TRUNC(e.SAL,-3)) "인원수" 
    FROM emp e
    GROUP BY TRUNC(e.SAL,-3)
    ORDER BY "급여단위" desc
    ;
--c)급여단위가 1000미만인 경우 0으로 출력되는 것을 변경
--  :범위 연산이 필요해 보임 ==>CASE구문 선택
SELECT CASE WHEN TRUNC(e.SAL,-3) < 1000 THEN '1000미만'
            ELSE TRUNC(e.SAL,-3)||''
       END as "급여단위"
       ,COUNT(TRUNC(e.SAL,-3)) "인원수" 
    FROM emp e
    GROUP BY TRUNC(e.SAL,-3)
    ORDER BY TRUNC(e.SAL,-3) desc
    ;
--5번을 다른 방법으로 풀이
--a)sal 컬럼에 왼쪽으로 패딩을 붙여서 0을 채움
SELECT e.EMPNO
      ,e.ENAME
      ,LPAD(e.SAL,4,'0')
 FROM emp e
;
--b) 맨 앞의 글자를 잘라낸다.
SELECT e.EMPNO
      ,e.ENAME
      ,SUBSTR(LPAD(e.SAL,4,'0'),1,1)
 FROM emp e
;
--C) COUNT + 그룹화
SELECT SUBSTR(LPAD(e.SAL,4,'0'),1,1)
      ,COUNT(*) "인원명"
 FROM emp e
 GROUP BY  SUBSTR(LPAD(e.SAL,4,'0'),1,1)
 ;
--D)1000단위로 출력 형태 변경
SELECT CASE WHEN SUBSTR(LPAD(e.SAL,4,'0'),1,1) = 0 THEN '1000미만'
            WHEN SUBSTR(LPAD(e.SAL,4,'0'),1,1) = 1 THEN '1000'
            WHEN SUBSTR(LPAD(e.SAL,4,'0'),1,1) = 2 THEN '2000'
            WHEN SUBSTR(LPAD(e.SAL,4,'0'),1,1) = 3 THEN '3000'
            WHEN SUBSTR(LPAD(e.SAL,4,'0'),1,1) = 4 THEN '4000'
            WHEN SUBSTR(LPAD(e.SAL,4,'0'),1,1) = 5 THEN '5000'
            END "급여단위"
           ,COUNT(*) "인원명"
 FROM emp e
 GROUP BY SUBSTR(LPAD(e.SAL,4,'0'),1,1)
 ORDER BY SUBSTR(LPAD(e.SAL,4,'0'),1,1) desc
;

--6.직무별 급여 합의 단위를 구하고,급여 합의 단위가 큰 순으로 정렬

--a)JOB별로 급여의 합을 구함
SELECT  e.JOB
       ,SUM(e.SAL)
 FROM emp e
 GROUP BY e.JOB
;
--b)
SELECT  nvl(e.JOB,'미배정') "직무"
       ,TRUNC(SUM(e.SAL),-3) as "급여단위"
 FROM emp e
 GROUP BY e.JOB
 ORDER BY  "급여단위" desc
;

--7.직무별 급여 평균이 2000이하인 경우를 구하고 평균이 높은 순으로 정렬
SELECT e.JOB
      ,TO_CHAR(AVG(e.SAL),'$9,999.00') "급여평균"
    FROM emp e
    GROUP BY e.JOB
    HAVING AVG(e.SAL) <= 2000
    ORDER BY "급여평균" desc
;

--8.년도별 입사인원을 구하시오
SELECT  
        TO_CHAR(e.HIREDATE,'YYYY') as "입사년도"
       ,count(*)
  FROM emp e
 GROUP BY TO_CHAR(e.HIREDATE,'YYYY')
 ORDER BY "입사년도" asc
    ;

--9.년도별 원별 입사 인원을 구하시오
SELECT  
        TO_CHAR(e.HIREDATE,'YYYY-MM')
       ,count(*)
    FROM emp e
    GROUP BY TO_CHAR(e.HIREDATE,'YYYY-MM')
    ORDER BY TO_CHAR(e.HIREDATE,'YYYY-MM');
    ;
--a)두 가지 그룹화 기준 적용된 구문 작성
SELECT TO_CHAR(e.HIREDATE,'YYYY') "입사년도"
      ,TO_CHAR(e.HIREDATE,'MM')   "입사 월"
      ,COUNT(*)                 "인원(명)"
  FROM emp e
 GROUP BY TO_CHAR(e.HIREDATE,'YYYY'),TO_CHAR(e.HIREDATE,'MM')
 ORDER BY "입사년도","입사 월"
;
-------------
--년도별,월별 입사 인원을 가로 표 형태로 출력
--a)년도 추출 ,월 추출
       TO_CHAR(e.HIREDATE,'YYYY') "입사년도"
      ,TO_CHAR(e.HIREDATE,'MM')   "입사 월"
--b)hiredate에서 월을 추출한 값이 01이 나오면 그 때의 숫자만 1월에서 카운트
--  이 과정을 12월까지 반복
SELECT 
       TO_CHAR(e.HIREDATE,'YYYY') "입사년도" --그룹화 기준 컬럼
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),01,1) "1월"
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),02,1) "2월"
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),03,1) "3월"
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),04,1) "4월"
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),05,1) "5월" 
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),06,1) "6월"
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),07,1) "7월"
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),08,1) "8월"
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),09,1) "9월"
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),10,1) "10월"
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),11,1) "11월"
      ,DECODE(TO_CHAR(e.HIREDATE,'MM'),12,1) "12월"
  FROM emp e
  ORDER BY "입사년도"
;
--C)입사 년도 기준으로 COUNT 함수 결과를 그룹화
SELECT 
       TO_CHAR(e.HIREDATE,'YYYY') "입사년도" --그룹화 기준 컬럼
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'01',1)) "1월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'02',1)) "2월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'03',1)) "3월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'04',1)) "4월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'05',1)) "5월" 
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'06',1)) "6월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'07',1)) "7월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'08',1)) "8월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'09',1)) "9월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'10',1)) "10월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'11',1)) "11월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'12',1)) "12월"
      FROM emp e
      GROUP BY TO_CHAR(e.HIREDATE,'YYYY')
  ORDER BY "입사년도" DESC
;

SELECT '인원 명' AS "입사월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'01',1)) "1월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'02',1)) "2월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'03',1)) "3월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'04',1)) "4월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'05',1)) "5월" 
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'06',1)) "6월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'07',1)) "7월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'08',1)) "8월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'09',1)) "9월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'10',1)) "10월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'11',1)) "11월"
      ,COUNT(DECODE(TO_CHAR(e.HIREDATE,'MM'),'12',1)) "12월"
      FROM emp e
;

-----7.조인과 서브쿼리
--(1)조인:JOIN
--하나 이상의 테이블을 논리적으로 묶어서 하나의 테이블 인 것 처럼 다루는 기술
--FROM절에 조인이 사용할 테이블 이름을 나열
--문제) 직원의 소속 부서 번호가 아닌,부서 명을 알고 싶다.
--a)from절에 emp,dept 두 테이블을 나열 ==> 조인 발생 ==>카티션 곱 ==> 두 테이블의 모든 조합
SELECT e.ENAME
      ,d.DNAME
  FROM emp e
      ,dept d
;
--16*4 = 64건의 데이터조회


SELECT e.ENAME
      ,d.DNAME
  FROM emp e
      ,dept d
 WHERE e.DEPTNO = d.DEPTNO --오라클의 전통적인 조인 조건 작성기법
  ORDER BY d.DEPTNO
;
SELECT e.ENAME
      ,d.DNAME
  FROM emp e join dept d ON (d.DEPTNO = e.DEPTNO)  --최근 사용하는 기법  
;
--조인 조건이 적절히 추가되어 12행의 의미 있는 데이터만 남김
--문제)위의 결과에서 ACCOUNTING 부서의 직원만 알고 있다.
--    조인 조건과 일반 조건이 같이 사용될 수 있다.
SELECT e.ENAME
      ,d.DNAME
  FROM emp e
      ,dept d
 WHERE e.DEPTNO = d.DEPTNO --오라클의 전통적인 조인 조건 작성기법
  AND d.DNAME = 'ACCOUNTING'
  ORDER BY d.DEPTNO
;

----2)조인 : 카티션 곱
--          조인대상 테이블의 데이터를 가능한 모든 경우로 엮는 것
--          조인조건 누락시 발생
--          ORACLE 9i 버전 이후 CROSS JOIN 키워드 지원
SELECT e.ENAME
      ,d.DNAME
      ,s.grade
FROM emp e CROSS JOIN dept d
           CroSS JOIN salgrade s
           ;
SELECT e.ENAME
      ,d.DNAME
      ,s.GRADE
FROM emp e
    ,dept d
    ,salgrade s
;
--(2)서브쿼리

-----1.오라클 전통적인 WHERE에 조인 조건 작성 방법
SELECT e.ENAME
      ,d.DNAME
  FROM emp e
      ,dept d
 WHERE e.DEPTNO = d.DEPTNO --오라클의 전통적인 조인 조건 작성기법
  ORDER BY d.DEPTNO
;
------2.NATURAL JOIN키워드로 자동 조인
SELECT e.ENAME
      ,d.DNAME
  FROM emp e NATURAL JOIN dept d  --조인 공통 컬럼 명시가 필요없다
;
-----3.JOIN ~USING 키워드로 조인
SELECT e.ENAME
      ,d.DNAME
  FROM emp e JOIN dept d USING (deptno) --조인 공통 컬럼 명시가 필요없다
;
-----4.JOIN ON 키워드로 조인
SELECT e.ENAME
      ,d.DNAME
  FROM emp e JOIN dept d ON (e.DEPTNO = d.DEPTNO) --조인 공통 컬럼 명시가 필요없다;


