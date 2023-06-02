
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
```

![스크린샷 2023-06-02 오전 9 23 05](https://github.com/whochucompany/ByteClone-BE/assets/96435200/df365f59-93cf-4a01-9a9d-9cc53ff4fa8d)

```txt
  plugins 하위 artifactId가 maven-compier-plugin 을 찾은 뒤 그 하위 source와 target을 ${java-version}으로 변경하자.
  ${java-version}으로 설정해놓으면 설정한 java-version을 그대로 따라가므로 11로 변경하든 16으로 변경하든 동일한 자바 버전을 따른다.
```

![스크린샷 2023-06-02 오전 9 27 57](https://github.com/whochucompany/ByteClone-BE/assets/96435200/0593eaba-0557-4f02-b454-387954663fb4)

![스크린샷 2023-05-30 오후 2 44 50](https://github.com/whochucompany/ByteClone-BE/assets/96435200/1a3f1584-969a-481c-8700-e3ebc5f8d90c)



```txt
💡 기본적인 프로젝트 설정 완료 후 STS 하단 Server 탭에서 구동할 서버를 설정할 수 있다.
💡 pom.xml 에서 java version이 일치하는지 확인한다.
```





