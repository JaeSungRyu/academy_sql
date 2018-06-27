--SQL DAY02
--------------------------------------

--IS NULL,IS NOT NULL

--27)
/* is null : 비교하려는 컬럼의 값이 null이면 true,null이 아니면 false
is not null : 바교하려는 컬럼의 값이 null이 아니면 ture, null이면 false

null값은 컬럼은 비교연산자와 연산이 불가능 하므로
null값 비교 연산자가 다로 존재함

col1 = null --> null값에 대해서는 =비교 연산자 사용 불가능
col1 != null --> null값에 대해서는 !=,<> 비교 연산자 불가능

*/

--27)어떤 직원의 mgr가 지정되지 않은 직원 정보 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.MGR 
FROM emp e
WHERE e.MGR IS NULL; -- = NULL이라고 쓸수 없음 

--MGR이 배정된 직원들 정보조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.MGR 
FROM emp e
WHERE e.MGR IS NOT NULL; -- != NULL이라고 쓸수 없음 
--11행 출력
SELECT e.EMPNO
      ,e.ENAME
      ,e.MGR 
FROM emp e
WHERE e.MGR <> NULL; 
--에러발생은 안나지만 결과 나오지 않음.
--물리적 오류가 아닌 논리적 오류이기 때문.
--이런 경우 에러를 찾기 어렵기 때문에 NULL데이터는 신중히 다뤄야함

-- BETWEEN A AND B :범위 비교 연산자 범위 포함
--ex) <= sal <=b : 이러한 범위 연산과 동일

--28)급여가 500~1200사이인 직원 정보 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
FROM emp e
WHERE e.SAL BETWEEN 500 AND 1200 
   OR e.SAL BETWEEN 3000 AND 5000
;

--BETWEEN 500 AND 1200과 같은 결과를 출력하는 비교연산자
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
FROM emp e
WHERE e.SAL >= 500 AND e.SAL <= 1200 
;

--EXIST 연산자 : 조회한 결과가 1행 이상 있다.
--              어떤 SELECT  구문을 실행했을 때 조회결과가 1행 이상 있으면
--              이 연산자의 결과가 true
--              조회 결과 : <인출된 모든 행 : 0> 인 경우 false
--              따라서 서브쿼리와 함께 사용 됨.
--              EXISTS(조회결과 유/무)
--29)급여가 10,000이 넘는 사람이 있는가?
--(1)급여가 10,000이 넘는 사람을 찾는 구문을 작성
SELECT e.ENAME
 FROM emp e
 WHERE e.SAL>10000
 ;
 /*위의 쿼리 실행결과가 1행이라도 있으면 화면에 
 "급여가 3000이 넘는 직원이 존재함" 이라고 출력*/

SELECT '급여가 3000이 넘는 직원이 존재함' as "시스템 메세지"
FROM dual
WHERE EXISTS(SELECT e.ENAME 
 FROM emp e
 WHERE e.SAL>3000)
 ;
  /*위의 쿼리 실행결과가 1행이라도 있지않으면 화면에 
 "급여가 10000이 넘는 직원이 존재하지않음" 이라고 출력*/

SELECT '급여가 10000이 넘는 직원이 존재하지 않음' as "시스템 메세지"
FROM dual
WHERE NOT EXISTS(SELECT e.ENAME 
 FROM emp e
 WHERE e.SAL>10000)
 ;
 
 
 --(6)연산자 : 결합연산자(||)
 --오라클에만 존재, 문자열 결합(접합)
 --다른 자바 등의 프로그래밍 언어에서는 OR연산자로 사용이 되므로
 --혼동에 주의
 
 --오늘의 날짜를 화면에 조회
 SELECT '오늘의 날짜는 '||sysdate||' 입니다.' as "오늘의 날짜" 
 FROM dual
 ;
 
 --직원의 사번을 알려주는 구문을 ||을 이용해 작성
 SELECT '안녕하세요 '||e.ename||'님 당신의 사번은 '
        ||e.EMPNO||'입니다' AS "사번알리미"
 FROM emp e;