# AOP (Aspect Oriented Programming) -  2 (어노테이션 기반 설정)

## JoinPoint 와 바인드 변수

```txt
횡단관심에 해당하는 어드바이스 메서드를 의미 있게 구현하려면 클라리언트가 호출한
비지니스 메소드의 정보가 필요하다.
스프링에서는 이런 다양한 정보들을 이용할 수 있도록 JoinPoint 인터페이스를 제공한다.
```

- **JoinPoint 메서드**
| 메서드                   | 설명                                                                                                |
| ------------------------ | --------------------------------------------------------------------------------------------------- |
| Signature getSignature() | 클라이언트가 호출한 메서드의 시그니처(리턴타입, 이름, 매개변수) 정보가 저장된 Signature 객체를 리턴 |
| Object getTarget()       | 클라이언트가 호출한 비지니스 메서드를 포함하는 비지니스 객체 리턴                                   |
| Object[] getArgs()       | 클라리언트가 메서드를 호출할 때 넘겨준 인자 목록을 Object 배열로 리턴                                                                                                    |

- Before, After Returning, After Throwing, After 어드바이스는 JoinPoint를 사용하고 Around 어드바이스에서만 ProceedingJoinPoint 를 매개변수로 사용한다.

- **Signauture 제공하는 메서드**
| 메서드                 | 설 명                                                                                 |
| ---------------------- | ------------------------------------------------------------------------------------- |
| String getName()       | 클라이언트가 호출한 메서드 이름을 리턴                                                |
| String toLongString()  | 클라이언트가 호출한 메서드의 리턴타입, 이름, 매개변수를 패키지 경로까지 포함하여 리턴 |
| String toShortString() | 클라이언트가 메서드를 메서드 시그니처를 축약한 문자열로 리턴                          |

- JoinPoint 객체를 사용하려면 단지 JoinPoint를 어드바이스 메서드 매개변수로 선언만 해 주면 된다.
  그러면 클라이언트가 비지니스 메서드를 호출할 때 스프링 컨테이너가 JoinPoint 객체를 생성한다.
  그리고 메서드 호출과 관련된 모든 정보를 JoinPoint 객체에 저장하여 어드바이스 메서드를 호출할 때 인자로 넘겨준다.

---

## 어노테이션 기반의 AOP

- AOP를 어노테이션으로 설정하려면 가장 먼저 스프링 설정 파일에 <aop:aspectj-autoproxy> 엘리먼트를
  선언해야 한다.
  <aop:aspectj-autoproxy> 설정만으로도 스프링 컨테이너는 AOP 관련 어노테이션을 인식하고
  용도에 맞게 처리해 준다.

<img width="488" alt="스크린샷 2023-06-11 오전 2 06 12" src="https://github.com/ParkRio/ParkRio/assets/96435200/c4d85fc8-3fe0-4cec-9946-62ce6ac0fba0">

- **AOP 관련 어노테이션들은 어드바이스 클래스에 설정한다.**
  그리고 어드바이스 클래스에 선언된 어노테이션들을 스프링 컨테이너가 처리하게 하려면 반드시
  어드바이스 객체가 생성되어 있어야 한다.
  따라서 어드바이스 클래스는 반드시 스프링 설정파일에 bean 으로 등록되거나
  @Service 어노테이션을 사용하여 컴포넌트가 검색될 수 있도록 해야 한다.

| Annotation 설정 | @Service                               |
| --------------- | -------------------------------------- |
| XML 설정        | bean id="log" clas="패키지명.클래스명" |

- **포인트컷 설정**
```txt
- 어노테이션 설정으로 포인트컷을 선언할 때는 @Pointcut을 사용하며 참조 메서드는 메서드 몸체가
  비어있는 즉, 구현 로직이 없는 메서드이다.
- @Aspect 어노테이션을 사용하는 경우에 @Pointcut 어노테이션을 이용해서 Pointcut 설정을 재사용
  할 수 있다.
- @Pointcut 어노테이션은 Pointcut 표현식을 값으로 가지며 @Pointcut 어노테이션이 적용된 메서드는
  리턴 타입이 반드시 void여야 한다.
- @Pointcut 어노테이션이 적용된 메서드의 이름을 이용해서 Pointcut을 참조할 수 있다.
  이때 메서드 이름은 범위에 맞게 알맞게 입력해야 한다.
  - 같은 클래스에 위치한 @Pointcut 메서드는 "메서드 이름"만 입력
  - 같은 패키지에 위치한 @Pointcut 메서드는 "클래스단순이름.메서드이름"을 입력
  - 다른 패키지에 위치한 @Pointcut 메서드는 "완전한클래스이름.메서드이름"을 입력
- @Pointcut 메서드를 사용할 때 주의 점은 메서드의 접근제어가 그대로 적용된다는 점이다.
- @Pointcut 메서드는 @Aspect 기반의 Aspect 구현뿐만 아니라 XML 스키마의 pointcut 속성 
  값으로도 사용할 수 있다.
```

XML 설정에세 사용했던 getPointcut 과 allPointcut을 어노테이션으로 변경한 예

<img width="592" alt="스크린샷 2023-06-11 오전 2 20 34" src="https://github.com/ParkRio/ParkRio/assets/96435200/57ed9d87-e796-463f-982a-de43054e1c03">

- **어드바이스 설정**
  어드바이스 클래스에는 횡단관심에 해당하는 어드바이스 메서드가 구현되어 있다.
  어드바이스의 동작시점은 XML과 마찬가지로 다섯 가지가 제공된다.
  이때 반드시 어드바이스가 결합된 포인트컷을 참조해야 한다.
  포인트컷을 참조하는 방법은 어드바이스 어노테이션 뒤에 괄호를 추가하고
  포인트컷 참조메서드를 지정하면 된다.

<img width="582" alt="스크린샷 2023-06-11 오전 2 30 09" src="https://github.com/ParkRio/ParkRio/assets/96435200/3cc2f230-69ed-4d01-aa54-d657e1b28d46">

- **애스팩트 설정**
  AOP 설정에서 가장 중요한 애스팩트는 @Aspect를 이용하여 설정한다.
  애스팩트는 포인트컷과 어드바이스의 결합이다.
  따라서 @Aspect가 설정된 애스팩트 객체에는 반드시 포인트컷과 어드바이스를 결합하는 설정이 있어야 한다.

<img width="982" alt="스크린샷 2023-06-11 오전 2 46 59" src="https://github.com/ParkRio/ParkRio/assets/96435200/53e43141-88d2-4429-9d26-f459a21c9710">

- **외부 Pointcut 참조하기**
  어노테이션으로 설정을 변경하면서 어드바이스 클래스마다 포인트컷을 포함시켰다.
  이렇다보니 비슷하거나 같은 포인트컷이 중복되는 문제가 발생하였다.
  스프링은 이러한 문제를 해결하고자 포인트컷을 외부에 독립된 클래스에 따로 설정할 수 있도록 한다.


<img width="860" alt="스크린샷 2023-06-11 오전 2 59 55" src="https://github.com/ParkRio/ParkRio/assets/96435200/9e0ddad8-a086-4344-93d9-1eb3bc4a28a4">
