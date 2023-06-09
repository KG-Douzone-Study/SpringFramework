
# Spring Legacy에 Formatter 적용하기

## Formatter

Formatter 는 문자에 특화된 타입 변환 Converter 의 특별한 버전이다.
객체와 문자, 문자와 객체 타입 변환시 특정 포멧으로 Locale 정보에 따라 문자를 출력하거나
또는 그 반대의 역할을 하는 특화된 기능이 포함된 인터페이스이다.

Converter는 타입 변환이 범용적으로 쓰이는 타입 변환기라고 볼 수 있으며
Formatter는 문자에 특화된 타입 변환기라고 볼 수 있다.

```txt
예) 날짜 객체 -> 2022-03-02 16:14:00
```

```txt
@RequestParam, @ModelAttribute, @PathVariable 등에서 사용가능한 메시지 컨버터(JSON)
에는 컨버전 서비스가 적용되지 않는다.
```

---

## Formatter 인터페이스

- Formatter 인터페이스는 Printer 인터페이스와 Parser 인터페이스를 상속 받는다.

```txt
- Printer<T> -> 객체를 문자로 변경하는 역할
- Parser<T> -> 문자를 객체로 변경하는 역할
```

---

## Formatter 구현

날짜변환 Formatter 를 구현해보자.

```java
@Log4j2
public class LocalDateFormatter implements Formatter<LocalDate> {

	@Override
	public String print(LocalDate object, Locale locale) {
	// **TODO** Auto-generated method stub
	return DateTimeFormatter.ofPattern("yyyy-MM-dd").format(object);
	}

	@Override
	public LocalDate parse(String text, Locale locale) throws ParseException {
	// **TODO** Auto-generated method stub
	return LocalDate.parse(text, DateTimeFormatter._ofPattern_("yyyy-MM-dd"));
	}
}
```

---

## Formatter 등록

작성한 Formatter를 servlet-context.xml 에 적용해야 하는데
조금 복잡한 과정이 필요하다.

FormattingConversion-ServiceFactoryBean 객체를 스프링의 Bean 으로 등록해야 하고
이 안에 작성한 LocalDateFormatter를 추가해야 한다.

```xml
<!-- servlet-context -->

<!--Formatter -->
<!-- conversionService 라는 Bean을 등록한 후에는 스프링 MVC를 처리할 때
<mvc:annotation-driven> 에 이를 이용한다는 것을 지정해야만 한다.
-->

<bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
	<property name="formatters">
		<set>
			<bean class="패캐지경로.LocalDateFormatter" />
		</set>
	</property>
</bean>

<!-- 아래 태그는 SpringMVC가 @Controller 에 요청을 보내기 위해 HandlerMapping 과 HandlerAdapter 를 bean 으로 등록한다. -->
<!-- 이렇게 등록된 bean 에 의해 요청 url 과 컨트롤러를 매칭할 수 있다. -->
<!-- 근본적으로 @Controller 없이는 이 태그는 아무것도 하지 않는다고 할 수 있다. -->
<mvc:annotation-driven conversion-service="conversionService" />
```
