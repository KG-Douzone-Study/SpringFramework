
# Spring legacy - React 연결 (CORS, JSON)


```txt
개발단계에서 사용할 것이지만
jsp가 아닌 React에서 spring의 localhost:8000으로 요청을 보내보자.

개발단계에서는 React에서의 proxy를 사용해서 CORS를 해결할 것이지만
배포단계에서라면 어떻게 배포하는지에 따라 React Proxy를 계속 사용할 수도
Spring 백엔드 설정에서 CORS를 해결할 것인지 정해야 할거 같다.

먼저 Proxy를 사용해서 CORS를 해결하고
Spring legacy에서 Bean 등록을 java 나 xml 설정을 통해 CORS를 해결해보고
추가적으로 Spring legacy에서 Spring security를 사용한다면 해당 부분으로 CORS 설정을 열어보자.
```

## CORS

```txt
일반적으로 브라우저는 보안 문제로 인해 동일 출처 정책(SOP, Same Origin Policy)을 따른다.
두 URL의 프로토콜, 호스트, 포트가 모두 같아야 동일한 출처로 볼 수 있는데,
예를 들어 a-service.com 호스트에게 받은 페이지에서 b-service.com 호스트로 데이터를 요청할 수 없다.
출처가 다른 호스트로 데이터를 요청하는 경우 CORS 정책을 위반하게 된다.
보통 SPA(Single Page Application)은 데이터를 별도 API 서비스에서 받아오기 때문에
Cross Origin 요청이 발생한다.
```

<img width="462" alt="스크린샷 2023-06-11 오후 11 27 08" src="https://github.com/ParkRio/MegaKGCoffee/assets/96435200/75f5fb1f-c97b-42e1-8893-ce7a088179c3">


## Spring 설정

Controller 와 Service 에서 JSON 을 반환하도록 수정했다.
물론 Spring에서 자동적으로 데이터를 JSON으로 변환하게 해주려면
따로 Bean을 등록해야하지만 우리는 이전에 pom.xml에서 Jackson 라이브러리를 추가해서
자동적으로 Bean이 등록되게 해주었다.

<img width="549" alt="스크린샷 2023-06-11 오후 11 16 26" src="https://github.com/ParkRio/MegaKGCoffee/assets/96435200/b3729294-15af-45dd-b70e-3d3040ab305b">

<img width="473" alt="스크린샷 2023-06-11 오후 11 13 50" src="https://github.com/ParkRio/MegaKGCoffee/assets/96435200/8adb40e3-0198-4281-b48e-0d8ce471b7f2">

<img width="683" alt="스크린샷 2023-06-11 오후 11 17 10" src="https://github.com/ParkRio/MegaKGCoffee/assets/96435200/b8cc2af1-bef8-4a3f-9971-623f7f96b5fd">

```txt
제대로 JSON 형식으로 데이터가 넘어오는지 Postman으로 확인해보자.
```

<img width="832" alt="스크린샷 2023-06-11 오후 11 18 18" src="https://github.com/ParkRio/MegaKGCoffee/assets/96435200/50c7b496-77b2-447b-b4c7-2ee265eb9f2d">

```txt
JSON 형식으로 데이터가 잘 넘오는 것을 확인할 수 있다.
```

---

## React 어플리케이션 프록시 구축하기

리액트 어플리케이션에서도 프록시를 이용하면 이를 CORS 정책을 우회할 수 있다.
별도의 응답 헤더를 받을 필요 없이 브라우저는 리액트 어플리케이션으로 데이터를 요청하고,
해당 요청을 백엔드 서비스로 전달한다.
리액트 어플리케이션이 백엔드 서비스로부터 받은 응답 데이터를 다시 브라우저로 재전달하기 때문에
브라우저는 CORS 정책을 위배한지 모른다.

```txt
(SpringBoot @CrossOrigin 어노테이션 사용시)
- 리액트 어플리케이션으로부터 화면을 전달받습니다. 이때 호스트는 http://localhost:3000 이다.
- 화면 버튼을 눌렀을 때 브라우저가 백엔드 서비스 http://localhost:8080 으로 직접 요청한다.
- 백엔드 서비스는 요청에 대한 응답을 반환한다.
- 응답 헤더 정보에 Access-Control-Allow-Origin: http://localhost:3000 이 추가된다.
  이는 백엔드 서비스가 http://localhost:3000 출처로부터 오는 요청은 허가한다는 의미이다.

(리액트 어플리케이션 프록시 구축시)
- 리액트 어플리케이션으로부터 화면을 전달받는다. 이때 호스트는 http://localhost:3000 이다.
- 화면 버튼을 눌렀을 때 브라우저는 리액트 어플리케이션에게 요청한다.
- 리액트 어플리케이션에서 구축된 프록시를 통해 백엔드 서비스 http://localhost:8080을 호출한다.
- 백엔드 서비스는 요청에 대한 응답을 반환한다.
- 리액트 어플리케이션은 이를 다시 브라우저에게 전달한다.
```


### http-proxy-middleware 모듈 사용하기

package.json 파일에 proxy 옵션을 추가하는 방법으로 프록시 설정이 가능하지만
조금 더 유연하게 사용하고 싶은 경우 http-proxy-middleware 모듈을 사용하자.

```txt
npm install http-proxy-middleware
```

설치가 완료되었다면 리액트의 src 폴더로 가자

```txt
- /src 폴더 바로 하위로 setupProxy.js 파일을 생성하자
- API 요청 경로에 /proxy가 존재하는 경우 http://localhost:8080 호스트로 요청을 전달한다.
```

---

#### GET 요청

<img width="586" alt="스크린샷 2023-06-11 오후 11 39 29" src="https://github.com/ParkRio/MegaKGCoffee/assets/96435200/1efc5530-04a4-4d89-abdb-22efd88703a2">

요청으로 axios 나 fetch를 사용할 수 있지만
axios 설치하기가 귀찮으니 fetch api를 사용하겠다.

<img width="552" alt="스크린샷 2023-06-12 오전 12 53 42" src="https://github.com/ParkRio/MegaKGCoffee/assets/96435200/4b32506a-081a-4fcd-b157-7568780c9bb4">

<img width="555" alt="스크린샷 2023-06-12 오전 12 54 30" src="https://github.com/ParkRio/MegaKGCoffee/assets/96435200/31c03632-fbdc-4f49-9bc2-b5567ca2ac82">

<img width="182" alt="스크린샷 2023-06-12 오전 12 55 54" src="https://github.com/ParkRio/MegaKGCoffee/assets/96435200/b162b063-6f8e-4953-a790-236f242c5b84">
결과값이 잘 출력되는것을 확인할 수 있다.

---

#### POST 요청 (내일 수정)
