---- JOIN 계속..

-- 조인 구문 구조

 

-- 1. 오라클 전용 조인 구조

SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
  FROM 테이블1 별칭1, 테이블2 별칭2 [, ....]
 WHERE 별칭1.공통컬럼1 = 별칭2.공통컬럼1  -- 조인 조건을 WHERE 에 작성
  [AND 별칭1.공통컬럼2 = 별칭n.공통컬럼2] -- FROM 에 나열된 테이블이 2개가 넘을 때 조인 조건 추가
  [AND ... 추가 가능한 일반 조건들 등장]
  ;

-------------------------------------------------------

  -- 2. NATURAL JOIN을 사용하는 구조

SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...
  FROM 테이블1 별칭1 NATURAL JOIN 테이블2 별칭2
                  [NATURAL JOIN 테이블n 별칭n]
;
-------------------------------------------------------

-- 3. JOIN ~ USING 을 사용하는 구조

SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
  FROM 테이블1 별칭1 JOIN 테이블2 별칭2 USING (공통컬럼) -- 공통컬럼에 별칭 사용하지 않음
;
--------------------------------------------------------

-- 4.  JOING ~ ON 을 사용하는 구조 : 표준 SQL 구문

SELECT [별칭1.]컬럼명1, [별칭2.]컬럼명2 [, ...]
  FROM 테이블1 별칭1 JOIN 테이블2 별칭2 ON(별칭1.공통컬럼2 = 별칭n.공통컬럼2)
                   JOIN 테이블2 별칭2 ON(별칭1.공통컬럼n = 별칭n.공통컬럼n)
;
--------------------------------------------------------
--문제1)emp ,salgrade 테이블을 사용하여 직원의 급여에 따른 등급을 함께 조회
--     emp테이블에는 salgrade 테이블과 연결할 수 있는 동일한 값이 없음

SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,s.GRADE
  FROM emp e
     ,salgrade s
 WHERE e.SAL BETWEEN s.LOSAL AND s.HISAL
 ;
 
 ---
 
 
 
 -- 2.(+)연산자 JOIN 구문 구조
 SELECT .....
   FROM 테이블1 별칭1,테이블2 별칭2
 WHERE 별칭1,공동컬럼(+) = 별칭2.공동컬럼 /*RIGHT OUTER JOIN,왼쪽 테이블의 NULL데이터 출력*/
 WHERE 별칭1,공동컬럼 = 별칭2.공동컬럼(+); /*LEFT OUTER JOIN,오른쪽 테이블의 NULL데이터 출력*/
  ------------------------
  --문제)직원 중 부서가 배치되지 않은 사람이 있을 때
  --1.일반 조인을 걸면 조회가 되지 않는다.
  SELECT e.EMPNO
        ,e.ENAME
        ,d.DEPTNO
        ,d.DNAME
    FROM emp e
        ,dept d
 WHERE e.DEPTNO = d.DEPTNO
 ;
 --2.OUTER JOIN으로 해결
SELECT    e.EMPNO
         ,e.ENAME
         ,d.DEPTNO
         ,d.DNAME
    FROM emp e
        ,dept d
 WHERE e.DEPTNO = d.DEPTNO(+)
 ;
 --(+)연산자는 오른쪽에 붙이고 이는 null상태로 출력될 테이블을 결정
 --LEFT OUTER JOIN 발생, 전체 데이터를 기준삼는 테이블이 왼쪽이기 때문에 
 
 --3)LEFT OUTER JOIN _ON으로 해결
 SELECT   e.EMPNO
         ,e.ENAME
         ,d.DEPTNO
         ,d.DNAME
    FROM emp e LEFT OUTER JOIN dept d
 ON e.DEPTNO = d.DEPTNO(+)
 ;
 --문제)아직 아무도 배치되지 않은 부서가 있어도
 --    부서를 다 조회하고 싶다면
 --1.(+) 연산자로 해결
 SELECT e.EMPNO
       ,e.ENAME
       ,e.DEPTNO
       ,'||'
       ,d.DEPTNO
       ,d.DNAME
   FROM emp e
       ,dept d
 WHERE e.DEPTNO(+) = d.DEPTNO
 ;
 --RIGHT OUTER JOIN ~ON으로 해결

 SELECT e.EMPNO
       ,e.ENAME
       ,e.DEPTNO
       ,'||'
       ,d.DEPTNO
       ,d.DNAME
   FROM emp e RIGHT OUTER JOIN dept d
 ON e.DEPTNO(+) = d.DEPTNO
 ;
 
 --문제)부서배치가 안된 직원도 보고 싶고 
 --    직원이 아직 아무도 없는 부서도 모두 보고 싶을때
 --    즉, 양쪽 모두에 존재하는 NULL 값들을 모두 한번에 조회하려면 어떻게 해야 하는가?
 SELECT e.EMPNO
       ,d.DNAME
   FROM emp e
       ,dept d
 WHERE e.DEPTNO(+) = d.DEPTNO(+)
; --ORA-01468: a predicate may reference only one outer-joined table

 SELECT e.EMPNO
       ,e.ENAME
       ,d.DNAME
   FROM emp e FULL OUTER JOIN dept d
 ON e.DEPTNO = d.DEPTNO
; 

--6)SELF JOIN : 한 테이블 내에서 자기 자신의 컬럼끼리 연결하여 새행을 만드는 기법
--문제) emp테이블에서mgr에 해당하는 상사의 이름을 같이 조회하려면
SELECT e1.EMPNO "직원번호"
      ,e1.ENAME "직원이름"
      ,e1.MGR   "상사번호" 
      ,e2.ENAME "상사이름"
  FROM emp e1, emp e2
 WHERE e1.MGR = e2.EMPNO
;
--상사가 없는 사원들도 조회하고 싶다
--a) e1 테이블의 기준 =>SELF OUTER JOIN 
--b) (+)기호를 

SELECT e1.EMPNO "직원번호"

      ,e1.ENAME "직원이름"
      ,e1.MGR   "상사번호" 
      ,e2.ENAME "상사이름"
  FROM emp e1 RIGHT OUTER JOIN emp e2
 ON e1.MGR = e2.EMPNO
;

--부하직원이 없는 직원을 조회
SELECT e1.EMPNO "직원번호"
      ,e1.ENAME "직원이름"
      ,e1.MGR   "상사번호" 
      ,e2.ENAME "상사이름"
  FROM emp e1, emp e2
 WHERE e1.MGR(+) = e2.EMPNO
;

------------7.조인과 서브쿼리
--(2)서브쿼리 : SELECT FROM WHERE절에서 사용할 수 있다
--emp테이블에서 BLAKE와 직무가 동일한 직원의 정보를 조회하고 싶을 때
--a)BLAKE의 직무값을 조회
SELECT e.EMPNO
      ,e.JOB
  FROM emp e
  WHERE e.ENAME = 'BLAKE'
; -- MANAGER
--b)1에서 조회된 믹무값을 다시 WHERE절에서 수행
SELECT e.EMPNO
      ,e.ENAME
  FROM emp e
  WHERE e.JOB = (SELECT e.JOB
  FROM emp e
 WHERE e.ENAME = 'BLAKE')
;






-------------------------------------------------------
--서브쿼리 실습
--1.이 회사의 평균 급여보다 급여가 큰 직원들의 목록을 조회
--a)평균 급여 구하기
SELECT AVG(e.SAL)
  FROM emp e
;

--b)급여보다 큰 직원들 구하기
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
  FROM emp e
 WHERE e.SAL > (SELECT AVG(e.SAL)
  FROM emp e)
;

--2.급여가 평균 급여보다 크면서 사번이 7700보다 높은 직원 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
  FROM emp e
 WHERE e.SAL  > (SELECT AVG(e.SAL) 
  FROM emp e) AND e.EMPNO > 7700
;


--3.각 직무별로 최대 급여를 받는 직원 목록을 조회
--(사번,이름,직무,급여)
--a)직무별 최대급여 조회
SELECT e.JOB
      ,MAX(e.SAL)
  FROM emp e
  GROUP BY e.JOB
;
--b)a를 사용할 메인쿼리
--최대 급여가 자신의 급여가 같은지
--그 때의 직무가 나의 직무와 같은지 비교 필요
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
  FROM emp e
WHERE (e.JOB,e.SAL) IN (SELECT e.JOB --ORA-00913: too many values
               ,MAX(e.SAL)
  FROM emp e
  GROUP BY e.JOB)
; 
-->WHERE절에서 = 비교는 e.SAL 은 컬럼 1행당 비교
-- 그런데 서브쿼리에서 돌아오는 값은 6행
--1행과 6행은 비교자체가 불가능
-->IN연산자 사용해서 해결 / 데이터가 다양해지면 잘못 작동할 수 있기 때문에 IN의 컬럼을 정확히 명시해주는것이 좋음


--4.각 월별 입사인원을 세로로 출력
--a)입사일 데이터에서 월을 추출
SELECT TO_CHAR(e.HIREDATE,'FMMM')
  FROM emp e
;
--b)입사 월별 인원 => 그룹화 기준 월
--  인원을 구하는 함수 =>COUNT(*)사용
SELECT TO_CHAR(e.HIREDATE,'FMMM') "월"
    ,COUNT(*) "인원(명)"
  FROM emp e
  GROUP BY TO_CHAR(e.HIREDATE,'FMMM')
  ORDER BY "월" ASC
;
SELECT TO_NUMBER(TO_CHAR(e.HIREDATE,'FMMM'))||'월' "월"
    ,COUNT(*) "인원(명)"
  FROM emp e
  GROUP BY TO_CHAR(e.HIREDATE,'FMMM')
  ORDER BY "월" ASC
;
-->월을 붙이면 다시문자화 돠어 정렬이 망가짐

--서브쿼리로 감싸서 정렬시도
SELECT a."입사월" || '월' as "입사월"
      ,a."인원(명)"
  FROM (SELECT TO_NUMBER(TO_CHAR(e.HIREDATE,'FMMM'))||'월' "입사월"
    ,COUNT(*) "인원(명)"
  FROM emp e
  GROUP BY TO_CHAR(e.HIREDATE,'FMMM')
  ORDER BY "입사월" ASC) a
;


