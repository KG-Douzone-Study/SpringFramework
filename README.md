
# 스프링 프레임워크 개발 환경 설정하기

```
스프링 개발에서 가장 많이 사용하는 통합 개발도구는 Eclipse 기반으로 개발된
Spring Tool Suite (STS) 를 이용하거나, IntelliJ 또는 Eclipse 플러그인 형태로 사용하는 경우가 많다.

일반적으로 STS를 이용하여 진행되며 이를 사용하기 위해 사전에 JDK의 설치가 필요하다.
```

```txt
STS에서 [File] -> [New] -> Spring Legacy Project 을 클릭하여 생성창을 열어보자.
```

![스크린샷 2023-05-30 오후 2 28 10](https://github.com/whochucompany/ByteClone-BE/assets/96435200/7a004289-9190-49b6-87ec-d40573290142)

```txt
1. Project name : 프로젝트명 입력
2. Templates 에 Spring MVC Project 를 클릭하고 하단 Next을 클릭한다.
3. 이후 나오는 화면에서 사용할 패키지명을 작성해준다. (보통 도메인주소를 입력한다.)
```

![스크린샷 2023-05-30 오후 2 33 51](https://github.com/whochucompany/ByteClone-BE/assets/96435200/61f59e29-ad92-4824-85f4-7a39a518f1c7)

```txt
여기까지 완료되면 maven이 필요한 라이브러리를 다운로드 받기 시작하는데 자동으로 관련 라이브러리를
다운받기 때문에 몇 분정도의 시간이 소요된다.

💡 이후 진행하는 모든 실습에서는 maven 이라는 빌드 도구를 이용하여 필요한 jar파일들과 프로젝트를
구성하게 된다.

💡 maven은 프로젝트 관리 도구로 프로젝트의 시작과 끝까지의 단계에 맞춰서 사용하는 개발 도구이다.
주로 프로젝트에 필요한 의존적인 라이브러리를 관리해주는 용도로 많이 사용된다.
```

---

## JDK 버전의 처리

```txt
STS를 이용하여 스프링 MVC 프로젝트를 생성하면 JDK 버전은 1.6 버전을 기준으로 생성된다.
그 이상의 버전을 사용하고 싶다면 
[Project명 마우스 우클릭] -> [Properties] -> [Project Facets] -> Java Version 변경
```

![스크린샷 2023-05-30 오후 2 42 20](https://github.com/whochucompany/ByteClone-BE/assets/96435200/5867a92b-f5b7-40a0-91f7-fd5502cf0699)

```txt
[Java Compiler] -> JDK Cimpliance -> Java Version 변경
```

![스크린샷 2023-05-30 오후 2 43 49](https://github.com/whochucompany/ByteClone-BE/assets/96435200/1b123fc2-9f67-4423-aa8e-d3e6c8239573)

```txt
그리고 pom.xml에서 java-version을 11로 변경하자.
org.springframework-version 도 5.2.22.RELEASE 버전으로 작성기준 최신으로 올렸다.
```

![스크린샷 2023-06-02 오전 9 23 05](https://github.com/whochucompany/ByteClone-BE/assets/96435200/df365f59-93cf-4a01-9a9d-9cc53ff4fa8d)

```txt
  plugins 하위 artifactId가 maven-compier-plugin 을 찾은 뒤 그 하위 source와 target을 ${java-version}으로 변경하자.
  ${java-version}으로 설정해놓으면 설정한 java-version을 그대로 따라가므로 11로 변경하든 16으로 변경하든 동일한 자바 버전을 따른다.
```

![스크린샷 2023-06-02 오전 9 32 10](https://github.com/whochucompany/ByteClone-BE/assets/96435200/cbcb8fce-03c1-415a-884a-7845d5551d69)

```xml

<!-- build할때 세팅하는 법 -->

<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.1</version>
    <configuration>
        <source>${java.version}</source>
        <target>${java.version}</target>
        <encoding>utf-8</encoding>
    </configuration>
</plugin>

```

```xml

<!-- 처음부터 세팅 -->

<properties>
    <java.version>1.8</java.version>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
</properties>


```

![스크린샷 2023-05-30 오후 2 44 50](https://github.com/whochucompany/ByteClone-BE/assets/96435200/1a3f1584-969a-481c-8700-e3ebc5f8d90c)


```txt
💡 기본적인 프로젝트 설정 완료 후 STS 하단 Server 탭에서 구동할 서버를 설정할 수 있다.
💡 pom.xml 에서 java version이 일치하는지 확인한다.
💡 jre가 버전도 맞는지 확인한다. (properties -> java build path -> libaray -> 버전확인)
```

---

##  lombok 설정

lombok 사이트에서 lombok 을 다운받아 STS에서 설치하고
maven repository 에서 dependency 를 추가한다.

```xml
<!-- https://mvnrepository.com/artifact/org.projectlombok/lombok -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.24</version>
    <scope>provided</scope>
</dependency>
```

---

## Log4j2 설정 (log 설정)

spring legacy project 의 spring mvc project 로 만들었다면 기본적으로 Log4j 가 되어있다.
하지만 우린 log4j2 버전을 사용할 것이다.

pom.xml 파일에 log4j2 를 사용가능하게 하는 dependency 를 추가하자.
```xml
<!-- log4j2 -->

<!-- https://mvnrepository.com/artifact/org.apache.logging.log4j/log4j-core -->
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <version>2.17.1</version>
</dependency>

<!-- https://mvnrepository.com/artifact/org.apache.logging.log4j/log4j-api -->
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-api</artifactId>
    <version>2.17.1</version>
</dependency>

<!-- https://mvnrepository.com/artifact/org.apache.logging.log4j/log4j-slf4j-impl -->
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-slf4j-impl</artifactId>
    <version>2.17.1</version>
    <scope>test</scope>
</dependency>
```

dependency를 추가했다면 다른 log dependency와 충돌되는 부분이 있는지 테스트를 돌려서 확인해보자.
에러가 나는 부분의 dependency를 에러메시지에서 확인해주자.
지금은 한 부분이 충돌이나서 log4j 쪽 dependency를 주석처리하거나 제거하자.

```xml
<!-- 제거 -->
<!-- <dependency>
<groupId>org.slf4j</groupId>
<artifactId>slf4j-log4j12</artifactId>
<version>${org.slf4j-version}</version>
<scope>runtime</scope>
</dependency> -->
```

---

## Servlet 설정

pom.xml 설정에서 자동적으로 등록되어있던 dependency 에서 최신 버전으로 변경해주었다.

```xml
<!-- Servlet -->

<!-- https://mvnrepository.com/artifact/javax.servlet/javax.servlet-api -->
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
    <scope>provided</scope>
</dependency>

<!-- https://mvnrepository.com/artifact/javax.servlet.jsp/javax.servlet.jsp-api -->
<dependency>
    <groupId>javax.servlet.jsp</groupId>
    <artifactId>javax.servlet.jsp-api</artifactId>
    <version>2.3.3</version>
    <scope>provided</scope>
</dependency>

<!-- https://mvnrepository.com/artifact/javax.servlet/jstl -->

<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jstl</artifactId>
    <version>1.2</version>
</dependency>
```

---

## junit 설정

STS에서 Spring Legacy Project 로 MVC 프로젝트를 만들게되면 pom.xml 에 test 관련부분이 없다
따라서 pom.xml에 몇가지 dependency를 넣어주어야 한다.

```xml
<!-- https://mvnrepository.com/artifact/org.springframework/spring-test -->
<!-- spring-test dependency 가 없다면 Junit 은 동작하지 않는 방식으로 되어있다.하단 junit dependency 도 물론 있어야 한다. -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-test</artifactId>
    <version>${org.springframework-version}</version>
    <scope>test</scope>
</dependency>

```

```xml
<!-- test -->
<!-- https://mvnrepository.com/artifact/junit/junit -->
<!-- junit 버전은 4.10 버전이상으로 해야한다. -->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.12</version>
    <scope>test</scope>
</dependency>
```



---
## MyBatis / Connection Pool 연결

### 필요한 Connection Pool dependency

#### HikariCP (Connection Pool) + DataSource 설정
##### HikariCP 가 Oracle에서는 Class 변환 오류가 났기에 MariaDB로 변경했다. (Oracle은 Commons-CP를 쓰는것이 좋을 거 같다.)

![스크린샷 2023-06-02 오후 1 40 59](https://github.com/whochucompany/ByteClone-BE/assets/96435200/5e7d4e98-3e46-46a2-bd66-a52bf2dcd4cd)

![스크린샷 2023-06-02 오후 3 01 53](https://github.com/whochucompany/ByteClone-BE/assets/96435200/69447abd-f1dc-4141-91f0-f799eb181cff)

```txt
dependency 라이브러리를 추가했다면 DataSource를 설정하자
root-context.xml에 들어가자

```
![스크린샷 2023-06-07 오후 3 25 49](https://github.com/whochucompany/ByteClone-BE/assets/96435200/693e7b2b-0c7d-45fd-b669-bd85a169fdd2)

```txt
잘 등록되었는지 실험해보면?
```

![스크린샷 2023-06-07 오후 3 28 17](https://github.com/whochucompany/ByteClone-BE/assets/96435200/63b597fb-2454-4cc5-9dd0-785ca8e63e3b)


### 필요한 MyBatis dependency

```txt
총 4가지의 dependency가 필요하다.
1. mybatis
2. mybatis-spring : 스프링과 마이바티스를 연동해주는 라이브러리
3. spring-jdbc : 데이터베이스 처리
4. spring-tx : 트랜잭션 처리
```

![스크린샷 2023-06-02 오후 3 09 20](https://github.com/whochucompany/ByteClone-BE/assets/96435200/820d4ae3-825f-40ca-be2d-5b9d752b8469)

![스크린샷 2023-06-02 오후 3 09 38](https://github.com/whochucompany/ByteClone-BE/assets/96435200/1219ebd0-c66e-4f93-b992-fc8fa144deca)

이후 mapper 패키지를 하나 생성하고 TimeMapper interface를 하나 만들자.

```java
package com.rio.base.mapper;

import org.apache.ibatis.annotations.Select;

public interface TimeMapper {

@Select("select now()")
String getTime();

}
```

```txt
지금만든 TimeMapper는 데이터베이스의 현재 시각을 문자열로 처리하도록 구성되었다.
MyBatis에는 @Select 어노테이션을 이용해서 쿼리를 작성할 수 있는데 JDBC와 마찬가지로 ';'을
이용하지 않으므로 주의해야 한다.

작성된 인터페이스를 매퍼(Mapper) 인터페이스라고 하는데 마지막으로 어떠한 매퍼 인터페이스를
설정했는지 root-context.xml에 등록해 주어야 한다.

root-context.xml에는 <mybatis:scan> 태그를 이용해서 매퍼 인터페이스의 설정을 추가하자.

root-context.xml 파일 상단의 xmlns, xsi 설정에 mybatis-spring 관련 설정이
추가되어 있어야 한다.
```

### XML로 SQL 분리하기

```txt
MyBatis를 이용할 때 SQL은 @Select와 같은 어노테이션을 이용해서 사용하기도 한다.
다만 대부분은 SQL을 별도의 파일로 분리하는 것을 권장한다.
XML을 이용하는 이유는 SQL이 길어지면 이를 어노테이션으로 처리하기가 복잡해지기 때문이기도 하고
어노테이션이 나중에 변경되면 프로젝트 전체를 다시 빌드하는 작업이 필요하기 때문이다.

- 매퍼 인터페이스를 정의하고 메소드를 선언
- 해당 XML 파일을 작성 (파일 이름과 매퍼 인터페이스 이름을 같게)하고 <select>와 같은 태그를 이용
- <select>, <insert> 등의 태그에 id 속성 값을 매퍼 인터페이스의 메소드 이름과 같게 작성
```

![스크린샷 2023-06-07 오후 4 08 13](https://github.com/whochucompany/ByteClone-BE/assets/96435200/5aaf5ab3-b3ac-4f3f-b7b3-ef3b2d6a78ea)


```txt
main/resources/mappers 폴더를 추가하자.

mappers 폴더에는 TimeMapper2.xml 을 다음과 같이 작성하자.
(매퍼 인터페이스와 같은 이름으로 대소문자 주의)
```


![스크린샷 2023-06-07 오후 4 23 52](https://github.com/whochucompany/ByteClone-BE/assets/96435200/fc363a6d-eb66-4b04-b15e-5bb63a75bec9)


```txt
TimeMapper2.xml을 작성할 때는 <mapper> 태그의 namespace 속성을 반드시 매퍼 인터페이스의 이름과 동일하게 지정해야만 한다.

<select> 태그는 반드시 resultType 이나 resultMap 이라는 속성을 지정해야만 한다.

마지막으로 root-context.xml 에 있는 MyBatis 설정에 XML 파일들을 인식하도록 설정을 추가하자.
```

![스크린샷 2023-06-07 오후 4 22 29](https://github.com/whochucompany/ByteClone-BE/assets/96435200/d60dc31d-32e3-45af-847c-f8628387806c)

![스크린샷 2023-06-07 오후 4 24 57](https://github.com/whochucompany/ByteClone-BE/assets/96435200/80353b16-2495-4f7a-b0d6-d4a7262fba46)
