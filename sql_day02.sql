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
 
 
 --(6)연산자 : 6.집합연산자
 --첫번째 쿼리
 SELECT * 
 FROM dept
; 
 --두번째 쿼리 : 부서번호가 10번인 부서정보만 조회
 SELECT *
 FROM dept d
 WHERE d.DEPTNO =10
 ;
 --두집합의 중복데이터 허용하여 합집합
 SELECT * 
 FROM dept UNION ALL
 SELECT * FROM dept
 WHERE deptno = 10
 ;
 
--중복을 제거한 합집합
 SELECT * 
 FROM dept UNION
 SELECT * FROM dept
 WHERE deptno = 10
 ;
--INTERSECT : 중복된 데이터만 남기는 교집합
 SELECT * 
 FROM dept INTERSECT
 SELECT * FROM dept
 WHERE deptno = 10
 ;
 --MINUS : 첫번째 쿼리 실행 결과에서 두번째 쿼리 실행결과를 뺀 차집합
  SELECT * 
 FROM dept MINUS
 SELECT * FROM dept
 WHERE deptno = 10
 ;
 --주의 : 각 쿼리 조회 결과의 컬럼 갯수, 데이터 타입이 서로 일치해야 함
 SELECT *
 FROM dept d
 UNION ALL
 SELECT d.DEPTNO
       ,d.DNAME
    FROM dept d
    WHERE d.DEPTNO = 10
    ;
--query block has incorrect number of result columns" 

--
SELECT d.DNAME --문자형
      ,d.DEPTNO --숫자형
 FROM dept d
 UNION ALL
 SELECT d.DEPTNO --숫자형
       ,d.DNAME  --문자형
    FROM dept d
    WHERE d.DEPTNO = 10
    ;
--01790. 00000 -  "expression must have same datatype as corresponding expression"

--서로다른 테이블에서 조회한 결과를 집합연산 가능
--첫번째 쿼리 : emp 테이블에서 조회
SELECT e.EMPNO --숫자
      ,e.ENAME --문자
      ,e.JOB   --문자
    FROM emp e
    ;
--두번째 쿼리 : dept테이블에서 조회
SELECT d.DEPTNO
      ,d.DNAME
      ,d.LOC
    FROM dept d;
    
--서로 다른 테이블에서 조회내용을 UNION
SELECT e.EMPNO --숫자
      ,e.ENAME --문자
      ,e.JOB   --문자
    FROM emp e
    UNION 
SELECT d.DEPTNO --숫자
      ,d.DNAME  --문자
      ,d.LOC    --문자
    FROM dept d;
    
--서로 다른 테이블에서 조회내용을 MINUS
SELECT e.EMPNO --숫자
      ,e.ENAME --문자
      ,e.JOB   --문자
    FROM emp e
    MINUS
SELECT d.DEPTNO --숫자
      ,d.DNAME  --문자
      ,d.LOC    --문자
    FROM dept d;
--중복되는게 없음

--서로 다른 테이블에서 조회내용을 INTERSECT
SELECT e.EMPNO --숫자
      ,e.ENAME --문자
      ,e.JOB   --문자
    FROM emp e
    INTERSECT
SELECT d.DEPTNO --숫자
      ,d.DNAME  --문자
      ,d.LOC    --문자
    FROM dept d;
--중복되는 값이 없으므로 출력 된 행 0

--(6)연산자 : 7.연산자 우선순위
/*
주어진 조건 3가지
1.mgr = 7698
job = 'CLERK'
sal > 1300
*/

--1)매니저가 7698번이며, 직무는 CLERK이거나 
--  급여는 1300이 넘는 조건을 만족하는 직원의 정보를 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
      ,e.MGR
    FROM emp e
    WHERE e.MGR = 7698
    AND   e.JOB = 'CLERK'
    OR    e.SAL > 1300
    ;
/*
EMPNO,  ENAME,  JOB,        SAL,    MGR
7499	ALLEN	SALESMAN	1600	7698
7566	JONES	MANAGER	    2975	7839
7698	BLAKE	MANAGER	    2850	7839
7782	CLARK	MANAGER	    2450	7839
7839	KING	PRESIDENT	5000	
7844	TURNER	SALESMAN	1500	7698
7902	FORD	ANALYST	    3000	7566
7934	MILLER	CLERK	    1300	7782
*/

--2)매니저가 7698번인 직원중에 
--  직무가 CLERK 이거나 급여가 1300이 넘는 조건을 만족하는 직원 정보

SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
      ,e.MGR
    FROM emp e
    WHERE e.MGR = 7698
    AND  (e.JOB= 'CLERK' OR e.SAL > 1300)
    ;
/*
EMPNO, ENAME,     JOB,       SAL,    MGR
7499	ALLEN	SALESMAN	1600	7698
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	     950	7698
*/


--3)직무가 CLERK이거나
--  급여가 1300이 넘으면서 매니저가 7698인 직원의 정보 조회
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,e.SAL
      ,e.MGR
    FROM emp e
    WHERE e.JOB = 'CLERK'
    OR   (e.SAL > 1300 AND e.MGR = 7698)
    --and연산자는 or 연산자보다 우선순위가 높다. 
    --위의 예시는 가독좋게 보이기 위해 쓰인 것. 결과는 같음
    ;

/*
EMPNO,  ENAME,   JOB,      SAL,     MGR
7369	SMITH	CLERK    	800  	7902
7499	ALLEN	SALESMAN	1600	7698
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	    950	    7698
7934	MILLER	CLERK	    1300	7782
9999	J_JONES	CLERK	    500	
8888	J	    CLERK	    400	
7777	J\JONES	CLERK	    300	
*/

-------6.함수 
--(2) dual테이블 :1행 1열로 구성된 시스템 테이블
DESC dual; -->문자데이터 1칸으로 구성된 dummy 컬럼을 가진 테이블
DESC emp; 

SELECT *  -->dummy컬럼에 x값이 하나 들어있음을 확인할 수 있다.
FROM dual
;

select sysdate
from dual;

--(3) 단일행 함수
-- 1) 숫자함수 : 1.MOD(m.n) : m을n으로 나눈 나머지 계산함수
SELECT mod(10,3) as result
FROM dual;

--각 사원의 급여를 3으로 나눈 나머지를 조회
SELECT e.EMPNO
      ,e.ENAME
      ,mod(e.SAL,3) as result
FROM emp e;

/*
EMPNO, ENAME, RESULT
7369	SMITH	2
7499	ALLEN	1
7521	WARD	2
7566	JONES	2
7654	MARTIN	2
7698	BLAKE	0
7782	CLARK	2
7839	KING	2
7844	TURNER	0
7900	JAMES	2
7902	FORD	0
7934	MILLER	1
9999	J_JONES	2
8888	J	    1
7777	J\JONES	0
*/
--단일 행 함수는 테이블 1행당 한번씩 적용

---- 2.ROUND(m,n) : 실수 m을 소수점 n+1자리에서 반올림 한 결과를 계산
SELECT ROUND(1234.56,1) FROM dual; --1234.6
SELECT ROUND(1234.56,0) FROM dual; --1235
SELECT ROUND(1234.46,0) FROM dual; --1234
--ROUND(M) :N값을 생략하면 소수점 이하 첫째자리 반올림바로 수행

SELECT ROUND(1234.56) FROM dual; --1235
SELECT ROUND(1234.46) FROM dual; --1234

--3.TRUNC(m,n) : 실수 m을 n에서 지정한 자리 이하 소수점 버림
SELECT trunc(1234.56,1) FROM dual; --1234.5
SELECT trunc(1234.56,0) FROM dual; --1234
-- trunc(m) n을 생략하면 0으로 수행
SELECT trunc(1234.56) FROM dual; --1234

--4.CEIL(n) : 입력된 실수 n에서 같거나 가장 큰 가까운 정수
SELECT CEIL(1234.56) FROM dual; --1234
SELECT CEIL(1234) FROM dual;  --1234
SELECT CEIL(1234.001) FROM dual; --1235

--5.FLOOR(n) : 입력된 실수 n에서 같거나 가장 가까운 작은 정수
SELECT FLOOR(1234.56) FROM dual; --1234
SELECT FLOOR(1234) FROM dual; --1234
SELECT FLOOR(1235.56) FROM dual; --1235

--6.WIDTH_BUCKET(expr,min,max,buckets)
--:min,max값 사이를 buckets 개수만큼의 구간으로 나누고
--expr이 출력하는 값이 어느 구간인지 위치를 숫자로 구해줌

--급여범위를 0~5000으로 잡고, 5개의 구간으로 나누어서
--각 직원의 급여가 어느 구간에 해당하는지 보고서를 출력하자
SELECT e.EMPNO
      ,e.ENAME
      ,e.SAL
      ,WIDTH_BUCKET(e.SAL,0,5000,5) AS "급여구간"
FROM emp e
ORDER BY "급여구간" desc
;

--2)문자함수
----1.INITCAP(str) : str의 첫 글자를 대문자화(영문인 경우)
SELECT INITCAP('the soap') FROM dual; --The Soap
----2.LOWER(str) : str소문자로 변경
SELECT LOWER('MR. SCOTT MCMILLAN') "Lowercase" FROM dual; --mr. scott mcmillan
----3.UPPER(str) --str을 대문자화
SELECT UPPER('lee')"성을 대문자로 변경" FROM dual; --LEE
SELECT UPPER('hello,world!!')"성을 대문자로 변경" FROM dual; --HELLO,WORLD!!
----4.LENGTH(str),LENGTH(str)
SELECT LENGTH('HELLO,SQL!')"글자길이" FROM dual;
SELECT 'HELLO,SQL!의 '||'글자길이는 '||LENGTH('HELLO,SQL!')||'입니다' "글자길이" FROM dual;
--ORACLE에서 한글은 3byte로 계산
SELECT 'HELLO,SQL!의 '||'글자크기는 '||LENGTHB('오라클')||'입니다' "글자길이" FROM dual;
----5.CONCAT(str1,str2) str1,str2문자열을 집합,||과 동일
SELECT CONCAT('안녕하세요,','SQL') FROM dual;
SELECT '안녕하세요,'||'SQL' FROM dual; 
----6.SUBSTR(str,i,n) : str에서 i번째 위치에서 n개의 글자를 추출
-- SQL에서 문자열 인덱스를 나타내는 ,i는 1부터 시작에 주의함
SELECT SUBSTR('sql is cooooooooool~~!!',3,4) FROM dual;
SELECT SUBSTR('sql is cooooooooool~~!!',3) FROM dual; --i번째부터 문자 끝가지 추출
----7.INSTR(str1,str2) : 2번째 문자열이 1번째 문자열 어디에 위치하는가 등장하는 위치를 계산
SELECT INSTR('sql is cooooooooool~~!!','is') FROM dual;
SELECT INSTR('sql is cooooooooool~~!!','ia') FROM dual;
--2번째가 등장하지 않으면 0으로 계산
----8.LPAD,RPAD(str,n,c)
-- 입력된 str에 전체 글자의 자릿수를 n으로 잡고
-- 남는 공간에 왼쪽,혹은 오른쪽으로 c의 문자를 채워넣는다.
SELECT LPAD('sql is cooooool',20,'!') FROM dual;
SELECT RPAD('sql is cooooool',25,'!') FROM dual;
----9.LTRIM,RTPIM,TRIM : 입력된 문자열의 왼오양쪽 공백 제거
SELECT '>' ||LTRIM('     sql is cool    ')||'<' FROM dual;
SELECT '>' ||RTRIM('     sql is cool    ')||'<' FROM dual;
SELECT '>' ||TRIM('     sql is cool    ')||'<' FROM dual;
----10.NVL(expr1,expr2),NVL2(expr1,expr2,expr3),NVLIF(expr1,expr2)
--nvl(expr1,expr2)  : 첫번째 식의 값이 NULL이면 두번째 식으로 대체하여 출력
--MGR이 배정이 안된 직원의 경우 '매지저없음'으로 변경해서 출력
SELECT e.EMPNO
      ,e.ENAME
      ,nvl(e.MGR,'매니저없음') --MGR은 숫자데이터,변경 출력이 문자
      FROM emp e             --타입 불일치로 실행이 안됨
      ;
-------
SELECT e.EMPNO
      ,e.ENAME
      ,nvl(e.MGR||'','매니저 없음') 
--결합연산자 ||에 ''를 결합해 형변환
      FROM emp e          
;

--nvl2(expr1,expr2) : 첫번째 식의 값이 NOT NULL이면 두번째 식으로 대체하여 출력하고
--                    첫번째 식의 값이 NULL이면 세번째 식의 값으로 대체하여 출력
SELECT e.EMPNO
      ,e.ENAME
      ,nvl2(e.MGR||'','매니저 있음','매니저 없음') 
--결합연산자 ||에 ''를 결합해 형변환
      FROM emp e          
;
--nullif(expr1,expr2) 
--  :첫번째 식,두번째 식의 값이 동일하면 NULL을 출력
--  식의 값이 다르면 첫번째 식의 값을 출력
SELECT NULLIF('AAA','AAA')
FROM dual;
--조회된 결과 1행이 NULL인 결과를 얻게 됨
--1행이라도 NULL이 조회된 결과는 인출된 모든 행 :0 과는 상태가 다름!



--3)날짜함수 : 날짜 출력 패턴 조합으로 다양하게 출력가능
SELECT sysdate FROM dual;
SELECT TO_CHAR(sysdate,'YYYY') FROM dual;
SELECT TO_CHAR(sysdate,'YY') FROM dual;
SELECT TO_CHAR(sysdate,'MM') FROM dual;
SELECT TO_CHAR(sysdate,'MONTH') FROM dual;
SELECT TO_CHAR(sysdate,'MON') FROM dual;
SELECT TO_CHAR(sysdate,'DD') FROM dual;
SELECT TO_CHAR(sysdate,'D') FROM dual;
SELECT TO_CHAR(sysdate,'DY') FROM dual;
SELECT TO_CHAR(sysdate,'DAY') FROM dual;
SELECT TO_CHAR(sysdate,'D') FROM dual;

----패턴을 조합
SELECT TO_CHAR(sysdate,'YYYY-MM-DD') FROM dual;
SELECT TO_CHAR(sysdate,'FMYYYY-MM-DD') FROM dual;
SELECT TO_CHAR(sysdate,'YY-MONTH-DD') FROM dual;
SELECT TO_CHAR(sysdate,'YY-MONTH-DAY') FROM dual;
SELECT TO_CHAR(sysdate,'YY-MONTH-DY') FROM dual;
/*시간패턴 : 
HH:시간을 두자리로 표기
MI:분을 두자리로 표기
SS:초를 두자리로 표기
HH24:시간을 24시간 체계로 표기
*/
SELECT TO_CHAR(sysdate,'YYYY-MM-DD DAY HH24:MI:SS') FROM dual;
SELECT TO_CHAR(sysdate,'YYYY-MM-DD DAY AMHH:MI:SS') FROM dual; --AM은 오전오후 나타냄
--날짜값과 숫자의 연산 : +,-연산 가능
SELECT sysdate + 10 FROM dual; --10일 후 
SELECT sysdate - 10 FROM dual; --10일 전
SELECT TO_CHAR(sysdate + (10/24),'YYYY-MM-DD DAY HH24:MI:SS') FROM dual; --24시간을 나타냄 즉 10시간 후

--1.MONTH_BETWEEEN(날짜1,날짜2) : 두 날짜 사이의 달의 차이
SELECT MONTHS_BETWEEN(SYSDATE,e.hiredate) 
FROM emp e;
--2.ADD_MONTHS(날짜1,숫자) : 날짜 1에 숫자만큼 더한 후의 날짜를 구함
SELECT ADD_MONTHS(SYSDATE,3) FROM dual;
--3.NEXT_DAY,LAST_DAY : 다음 요일에 해당하는 날짜를 구함 , 이 달의 마지막 날짜
SELECT NEXT_DAY(SYSDATE,'일요일') FROM dual; --요일을 문자로 입력했을때
SELECT NEXT_DAY(SYSDATE,1) FROM dual; --숫자로 입력해도 작동
SELECT LAST_DAY(SYSDATE) FROM dual;
--4.ROUND,TRUNC : 날짜관련 반올림, 버림
SELECT ROUND(SYSDATE) FROM dual;
SELECT to_char(ROUND(SYSDATE),'yyyy-mm-dd hh24:mi:ss') FROM dual;
SELECT TRUNC(SYSDATE) FROM dual;
SELECT TO_CHAR(TRUNC(SYSDATE),'yyyy-mm-dd hh24:mi:ss') FROM dual;

---4)데이터 타입 변환 함수
/*
TO_CHAR()   :숫자,날짜 ===>문자
TO_DATE()   :날짜 형식의 문자 ===>날짜
TO_NUMBER() :숫자로만 구성된 문자데이터 ===> 숫자
*/
---1. TO_CHAR():숫자패턴 적용
-- 숫자패턴 : 9==> 한자리 숫자를 나타냄
SELECT TO_CHAR(12345,'9999') FROM dual;
SELECT TO_CHAR(12345,'99999') FROM dual;

SELECT e.EMPNO 
      ,TO_CHAR(e.SAL) AS " " --SAL이 문자형으로 출력됨 왼쪽정렬
FROM emp e;
--앞에 빈칸을 0으로 채우기 
SELECT TO_CHAR(12345,'09999999')AS DATA FROM dual;
--소수점으로 표현
SELECT TO_CHAR(12345,'99999999.99')AS DATA FROM dual;
--숫자패턴에서 3자리씩 끊어 읽기
SELECT TO_CHAR(12345,'999,999,99.99')AS DATA FROM dual;

----2. TO_DATE(): 날짜 패턴에 맞는 문자 값을 날짜 데이터로 변경
SELECT TO_DATE('2018-06-27','YYYY-MM-DD') + 10 as today FROM dual;
--10일 뒤의 연산결과 얻음 : 18/07/07
SELECT '2018-06-27' + 10 TODAY FROM dual;
--ORA-01722: invalid number ==> '2018-06-27' 문자 + 숫자 10의 연산 불가능

--3.TO_NUMBER() : 오라클이 자동 형변환을 제공하므로 자주 사용은 안됨
SELECT '1000' +10 RESULT FROM dual;
SELECT TO_NUMBER('1000') + 10 result FROM dual;

--5).DECODE :(expr,search,result[,search,result]..[,default])
/*
만약에 default가 설정이 안되었고
expr과 일치하는 search가 없을 경우 null을 리턴
*/
SELECT DECODE( 'NO'--expr
              ,'YES','입력값이 YES입니다' --search,result 세트1) 
              ,'NO','입력값이 NO입니다'   --search,result 세트2
) AS RESULT
FROM dual
;
------------
SELECT DECODE( '예'--expr
              ,'YES','입력값이 YES입니다' --search,result 세트1) 
              ,'NO','입력값이 NO입니다'   --search,result 세트2
) AS RESULT
FROM dual
;
-->>expr과 일치하는 search가 없고, default 설정도 안되었을 때
-- 결과가 <인출된 모든 행:0>이 아닌 null이라는 것을 확인

--emp테이블의 hiredate의 입사년도를 추출하여 몇년 근무했는지를 계산
--장기근속 여부를 판단
--1)입사년도 추출 : 날짜 패턴
SELECT e.EMPNO
      ,e.ENAME
      ,TO_CHAR(SYSDATE,'YYYY')
      from emp e;
--2)몇년근무 판단 : 오늘 시스템 날짜와 연산
SELECT e.EMPNO
      ,e.ENAME
      ,TO_CHAR(SYSDATE,'YYYY') - TO_CHAR(e.HIREDATE,'YYYY')  근무햇수
      from emp e;
      --자동 형변환 되어 문자열도 추출 가능
      
--3)37년 이상 된 직원을 장기 근속으로 판단
SELECT a.EMPNO
      ,a.ENMAE
      ,DECODE(a.workingyear
             ,37,'장기 근속자 입니다.' -- search,result 1
             ,38,'장기 근속자 입니다'  -- search,result 1
             ,'장기근속자가 아닙니다')as 장기근속여부 
from (select e.EMPNO
            ,e.ENAME
            ,TO_CHAR(SYSDATE,'YYYY') - TO_CHAR(e.HIREDATE,'YYYY')  workingyear
     from emp e) a;



--job별로 경조사비를 급여대비 일정 비율로 지급하고 있다.
--각 직원들의 경조사비 지원금을 구하자.
/*
CLERK     :5%
SALESMAN  :4%
MANAGER   :3.7%
ANALYST   :3%
PRESIDENT :1.5%
*/
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,DECODE(e.JOB
             ,'CLERK',    e.SAL*0.05
             ,'SALESMAN', e.SAL*0.04
             ,'MANAGER',  e.SAL*0.037
             ,'ANALYST',  e.SAL*0.04
             ,'PRESIDENT',e.SAL*0.015) as 경조사비지원금
FROM emp e
;
--출력결과에 숫자패턴 
SELECT e.EMPNO
      ,e.ENAME
      ,e.JOB
      ,TO_CHAR(DECODE(e.JOB
             ,'CLERK',    e.SAL*0.05
             ,'SALESMAN', e.SAL*0.04
             ,'MANAGER',  e.SAL*0.037
             ,'ANALYST',  e.SAL*0.04
             ,'PRESIDENT',e.SAL*0.015),'$999.99') as 경조사비지원금
FROM emp e
;

